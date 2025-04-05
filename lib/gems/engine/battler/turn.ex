defmodule GEMS.Engine.Battler.Turn do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Action
  alias GEMS.Engine.Battler.Event

  embedded_schema do
    field :number, :integer, default: 0

    embeds_one :leader, GEMS.Engine.Battler.Actor
    embeds_one :actors, GEMS.Engine.Battler.Actor
    embeds_one :action, GEMS.Engine.Battler.Action

    embeds_many :events, GEMS.Engine.Battler.Event
  end

  def new(number, actors) do
    # Sort the actors by charge to determine who's acting this turn (leader).
    # We only store store the leader snapshot in the turn struct to consume its current state.
    # We should NEVER rely on the leader to determine the current actor's state when applying effects.
    [leader | others] =
      actors
      |> Enum.reject(&Actor.dead?/1)
      |> Enum.sort_by(&{&1.charge, :rand.uniform()})

    %Turn{
      number: number,
      leader: leader,
      actors: [leader | others],
      events: []
    }
  end

  @doc """
  Chooses the action to be executed this turn.
  """
  def choose_action(%Turn{} = turn) do
    turn.leader.action_patterns
    |> Enum.sort_by(& &1.priority)
    |> Enum.reduce_while(turn, fn action_pattern, turn ->
      valid_targets = filter_targets(action_pattern, turn)
      final_targets = acquire_targets(action_pattern, valid_targets)

      action = build_action(action_pattern, final_targets)

      if action_can_be_executed?(action, turn.leader) and
           action_pattern_matches?(action_pattern, turn),
         do: {:halt, %{turn | action: action}},
         else: {:cont, turn}
    end)
  end

  @doc """
  Processes the turn action by creating the respective events.
  """
  def process_action(%Turn{action: nil} = turn), do: turn

  def process_action(%Turn{} = turn) do
    %{action: %{effects: effects}} = turn
    effects = Enum.group_by(effects, & &1.target)

    # We want to process the available events step by step
    # and retrieve the target information directly from the turn.
    # This way, the turn can always provide the current actor state.

    turn
    |> process_caster_effects(Map.get(effects, :caster, []))
    |> process_target_effects(Map.get(effects, :target, []))
  end

  defp build_action(%{skill: skill}, targets) do
    # The target information should be limited to ids so we can
    # avoid the woes of caching the actor state inside the action.
    # When processing the action, we'll source the actual actor from the turn.
    target_ids = Enum.map(targets, & &1.id)

    %Action{
      name: skill.name,
      effects: skill.effects,
      target_ids: target_ids,
      affinity: skill.affinity,
      critical?: Enum.random([true, false]),
      health_cost: skill.health_cost,
      energy_cost: skill.energy_cost
    }
  end

  defp acquire_targets(%{skill: skill}, actors) do
    sorted = Enum.sort_by(actors, & &1.aggro, :desc)
    fixed_targets = Enum.take(sorted, skill.target_number)

    remaining = actors -- fixed_targets
    random_targets = Enum.take_random(remaining, skill.random_targets)

    Enum.concat(fixed_targets, random_targets)
  end

  defp filter_targets(%{skill: %{target_scope: :self}}, turn),
    do: [turn.leader]

  defp filter_targets(%{skill: %{target_scope: :anyone}}, turn),
    do: turn.actors

  defp filter_targets(%{skill: %{target_scope: :ally}}, turn),
    do: Enum.filter(turn.actors, &Actor.ally?(&1, turn.leader))

  defp filter_targets(%{skill: %{target_scope: :enemy}}, turn),
    do: Enum.filter(turn.actors, &Actor.enemy?(&1, turn.leader))

  defp action_can_be_executed?(action, caster) do
    Enum.any?(action.target_ids) and
      caster.health >= action.health_cost and
      caster.energy >= action.energy_cost
  end

  defp action_pattern_matches?(%{condition: :always}, _turn),
    do: true

  defp action_pattern_matches?(%{condition: :random} = action_pattern, _turn),
    do: action_pattern.chance >= :rand.uniform()

  defp action_pattern_matches?(%{condition: :turn_number} = action_pattern, turn) do
    turn.number >= action_pattern.start_turn and
      rem(turn.number - action_pattern.start_turn, action_pattern.every_turn) == 0
  end

  defp action_pattern_matches?(%{condition: :health_number} = action_pattern, turn) do
    action_pattern.minimum_health <= turn.leader.health and
      action_pattern.maximum_health >= turn.leader.health
  end

  defp action_pattern_matches?(%{condition: :energy_number} = action_pattern, turn) do
    action_pattern.minimum_energy <= turn.leader.energy and
      action_pattern.maximum_energy >= turn.leader.energy
  end

  defp process_caster_effects(turn, []), do: turn

  defp process_caster_effects(turn, effects) do
    caster = find_caster(turn)

    process_effects(turn, caster, [caster], effects)
  end

  defp process_target_effects(turn, []), do: turn

  defp process_target_effects(turn, effects) do
    caster = find_caster(turn)

    %{action: %{target_ids: target_ids}} = turn
    targets = Enum.filter(turn.actors, &(&1.id in target_ids))

    process_effects(turn, caster, targets, effects)
  end

  defp process_effects(turn, caster, targets, effects) do
    Enum.reduce(targets, turn, fn target, turn ->
      event =
        caster
        |> Event.new(target, effects)
        |> Event.apply_effects()

      turn
      |> Map.update!(:events, &[event | &1])
      |> replace_actors([event.caster, event.target])
    end)
  end

  defp find_caster(turn) do
    # Find the updated version of the leader from the turn.
    # Even though the leader is usually the first actor in the list, it's
    # safer to rely on the actor's id to find the correct one (just in case).
    Enum.find(turn.actors, &Actor.self?(&1, turn.leader))
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
