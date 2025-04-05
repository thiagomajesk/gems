defmodule GEMS.Engine.Battler.Turn do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Action
  alias GEMS.Engine.Battler.Event

  embedded_schema do
    field :summary, :map, default: %{}
    field :number, :integer, default: 0

    embeds_one :leader, GEMS.Engine.Battler.Actor
    embeds_one :actors, GEMS.Engine.Battler.Actor
    embeds_one :action, GEMS.Engine.Battler.Action

    embeds_many :events, GEMS.Engine.Battler.Event
  end

  def new(number, leader, actors) do
    %Turn{number: number, leader: leader, actors: actors}
  end

  @doc """
  Picks the turn action based on actors participating on the turn.
  The next actor in line (source) is chosen based on the charge gauge.
  Then the action is chosen based on the existing source's action patterns.
  """
  def choose_action(%Turn{actors: []} = turn), do: turn

  def choose_action(%Turn{} = turn) do
    turn.leader.action_patterns
    |> Enum.sort_by(& &1.priority)
    |> Enum.reduce_while(turn, fn action_pattern, turn ->
      filtered_targets = filter_targets(action_pattern, turn.leader, turn.actors)
      selected_targets = select_targets(action_pattern, filtered_targets)
      action = build_action(action_pattern, turn.leader, selected_targets)

      if action_pattern_matches?(action_pattern, turn.leader, turn) and
           action_can_be_performed?(action),
         do: {:halt, %{turn | action: action}},
         else: {:cont, turn}
    end)
  end

  @doc """
  Processes the turn action by creating the respective events
  from the source and applying the effects to the respective targets.
  """
  def process_action(%Turn{action: nil} = turn), do: turn

  def process_action(%Turn{} = turn) do
    turn
    |> process_source_effects()
    |> process_target_effects()
  end

  defp process_source_effects(turn) do
    process_effects(
      turn,
      [turn.action.source],
      turn.action.source_effects
    )
  end

  defp process_target_effects(turn) do
    process_effects(
      turn,
      turn.action.targets,
      turn.action.target_effects
    )
  end

  defp process_effects(turn, targets, effects) do
    Enum.reduce(targets, turn, fn target, turn ->
      event =
        turn.action.source
        |> Event.new(target, effects)
        |> Event.apply_effects()

      turn
      |> Map.update!(:events, &[event | &1])
      # Action source and Action targets are outdated (desynched)
      |> put_in([:action, :source], event.source)
      |> replace_actors([event.source, event.target])
    end)
  end

  defp build_action(%{skill: skill}, source, targets) do
    %Action{
      name: skill.name,
      affinity: skill.affinity,
      source: source,
      targets: targets,
      health_cost: skill.health_cost,
      energy_cost: skill.energy_cost,
      source_effects: skill.source_effects,
      target_effects: skill.target_effects
    }
  end

  defp filter_targets(%{skill: %{target_scope: :self}}, source, actors),
    do: Enum.filter(actors, &Actor.self?(&1, source))

  defp filter_targets(%{skill: %{target_scope: :anyone}}, source, actors),
    do: Enum.reject(actors, &Actor.self?(&1, source))

  defp filter_targets(%{skill: %{target_scope: :ally}}, source, actors),
    do: Enum.filter(actors, &Actor.ally?(&1, source))

  defp filter_targets(%{skill: %{target_scope: :enemy}}, source, actors),
    do: Enum.filter(actors, &Actor.enemy?(&1, source))

  defp select_targets(%{skill: skill}, actors) do
    sorted = Enum.sort_by(actors, & &1.aggro, :desc)
    fixed_targets = Enum.take(sorted, skill.target_number)

    remaining = actors -- fixed_targets
    random_targets = Enum.take_random(remaining, skill.random_targets)

    Enum.concat(fixed_targets, random_targets)
  end

  defp action_pattern_matches?(%{condition: :always}, _source, _turn),
    do: true

  defp action_pattern_matches?(%{condition: :random} = action_pattern, _source, _turn),
    do: action_pattern.chance >= :rand.uniform()

  defp action_pattern_matches?(%{condition: :turn_number} = action_pattern, _source, turn) do
    turn.number >= action_pattern.start_turn and
      rem(turn.number - action_pattern.start_turn, action_pattern.every_turn) == 0
  end

  defp action_pattern_matches?(%{condition: :health_number} = action_pattern, source, _turn) do
    action_pattern.minimum_health <= source.health and
      action_pattern.maximum_health >= source.health
  end

  defp action_pattern_matches?(%{condition: :energy_number} = action_pattern, source, _turn) do
    action_pattern.minimum_energy <= source.energy and
      action_pattern.maximum_energy >= source.energy
  end

  defp action_can_be_performed?(action) do
    Enum.any?(action.targets) and
      action.source.health >= action.health_cost and
      action.source.energy >= action.energy_cost
  end

  defp replace_actors(turn, actors) do
    Enum.reduce(actors, turn, fn actor, turn ->
      Map.update!(turn, :actors, fn actors ->
        Enum.map(actors, fn existing ->
          if Actor.self?(existing, actor),
            do: actor,
            else: existing
        end)
      end)
    end)
  end
end
