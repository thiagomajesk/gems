defmodule GEMS.Engine.Battler.Turn do
  use Ecto.Schema

  alias __MODULE__
  alias GEMS.Engine.Battler.Actor
  alias GEMS.Engine.Battler.Action
  alias GEMS.Engine.Battler.Event
  alias GEMS.Engine.Battler.Snapshot

  embedded_schema do
    field :number, :integer, default: 0

    embeds_one :leader, Snapshot
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
      |> Enum.sort_by(&{&1.charge, :rand.uniform()}, :desc)

    # When starting a new turn, the leader will:
    # - Gain an additional action point that can be used
    # - Decrease aggro, tick buffs, debuffs and conditions
    leader = Actor.upkeep(leader)

    %Turn{
      number: number,
      leader: Snapshot.new(leader),
      actors: [leader | others],
      events: []
    }
  end

  @doc """
  Chooses the action to be executed this turn.
  """
  def choose_action(%Turn{} = turn) do
    # Fetch the updated turn leader and start
    caster = fetch_leader(turn)

    caster.action_patterns
    |> Enum.sort_by(& &1.priority)
    |> Enum.reduce_while(turn, fn action_pattern, turn ->
      valid_targets = filter_targets(action_pattern, caster, turn)
      final_targets = select_targets(action_pattern, valid_targets)

      action = build_action(action_pattern, final_targets)

      if action_can_be_executed?(action, caster) and
           action_pattern_matches?(action_pattern, turn),
         do: {:halt, %{turn | action: action}},
         else: {:cont, turn}
    end)
  end

  @doc """
  Processes the turn action by creating the respective events.
  """
  def process_action(%Turn{action: nil} = turn) do
    turn
    |> process_token_effects()
    |> process_restoration_effects()
  end

  def process_action(%Turn{} = turn) do
    turn
    |> spend_action_points()
    |> process_token_effects()
    |> process_action_effects()
    |> process_restoration_effects()
  end

  defp build_action(%{skill: skill}, targets) do
    # The target information should be limited to ids so we can
    # avoid the woes of caching the actor state inside the action.
    # When processing the action, we'll source the actual actor from the turn.
    target_ids = Enum.map(targets, & &1.id)

    %Action{
      name: skill.name,
      effects: skill.effects,
      repeats: skill.repeats,
      target_ids: target_ids,
      affinity: skill.affinity,
      action_cost: skill.action_cost
    }
  end

  defp select_targets(%{skill: skill}, actors) do
    sorted = Enum.sort_by(actors, & &1.aggro, :desc)
    fixed_targets = Enum.take(sorted, skill.target_number)

    remaining = actors -- fixed_targets
    random_targets = Enum.take_random(remaining, skill.random_targets)

    Enum.concat(fixed_targets, random_targets)
  end

  defp filter_targets(%{skill: %{target_scope: :self}}, caster, _turn),
    do: [caster]

  defp filter_targets(%{skill: %{target_scope: :anyone}}, _caster, turn),
    do: turn.actors

  defp filter_targets(%{skill: %{target_scope: :ally}}, caster, turn),
    do: Enum.filter(turn.actors, &Actor.ally?(&1, caster))

  defp filter_targets(%{skill: %{target_scope: :enemy}}, caster, turn),
    do: Enum.filter(turn.actors, &Actor.enemy?(&1, caster))

  defp action_can_be_executed?(action, caster),
    do: Enum.any?(action.target_ids) and caster.action_points >= action.action_cost

  defp action_pattern_matches?(%{trigger: :always}, _turn),
    do: true

  defp action_pattern_matches?(%{trigger: :random} = action_pattern, _turn),
    do: action_pattern.chance >= :rand.uniform()

  defp action_pattern_matches?(%{trigger: :when_turn} = action_pattern, turn) do
    turn.number >= action_pattern.start_turn and
      rem(turn.number - action_pattern.start_turn, action_pattern.every_turn) == 0
  end

  defp action_pattern_matches?(%{trigger: :when_health} = action_pattern, turn) do
    action_pattern.minimum_health <= turn.leader.health and
      action_pattern.maximum_health >= turn.leader.health
  end

  defp action_pattern_matches?(%{trigger: :when_action_points} = action_pattern, turn) do
    action_pattern.minimum_action_points <= turn.leader.action_points and
      action_pattern.maximum_action_points >= turn.leader.action_points
  end

  defp spend_action_points(turn) do
    leader = fetch_leader(turn)

    %{action: %{action_cost: cost}} = turn
    leader = Actor.change_action_points(leader, -cost)

    Map.update!(turn, :actors, fn actors ->
      Actor.replace_with(actors, [leader])
    end)
  end

  defp process_token_effects(turn) do
    caster = fetch_leader(turn)

    create_event(turn,
      caster: caster,
      target: caster,
      effects: [],
      trigger: :token
    )
  end

  defp process_restoration_effects(turn) do
    caster = fetch_leader(turn)

    create_event(turn,
      caster: caster,
      target: caster,
      effects: [],
      trigger: :other
    )
  end

  defp process_action_effects(turn) do
    # We want to process the available events step by step
    # and retrieve the target information directly from the turn.
    # This way, the turn can always provide the current actor state.
    %{action: %{effects: effects, repeats: repeats}} = turn

    effects
    |> List.duplicate(repeats)
    |> Enum.reduce(turn, fn effects, turn ->
      lookup = Enum.group_by(effects, & &1.target)

      turn
      |> process_caster_effects(Map.get(lookup, :caster, []))
      |> process_target_effects(Map.get(lookup, :target, []))
    end)
  end

  defp process_caster_effects(turn, []), do: turn

  defp process_caster_effects(turn, effects) do
    caster = fetch_leader(turn)

    create_event(turn,
      caster: caster,
      target: caster,
      effects: effects,
      trigger: :action
    )
  end

  defp process_target_effects(turn, []), do: turn

  defp process_target_effects(turn, effects) do
    caster = fetch_leader(turn)
    targets = fetch_targets(turn)

    Enum.reduce(targets, turn, fn target, turn ->
      outcome = Action.outcome(caster, target)

      create_event(turn,
        caster: caster,
        target: target,
        effects: effects,
        trigger: outcome
      )
    end)
  end

  defp create_event(turn, opts) do
    caster = Keyword.fetch!(opts, :caster)
    target = Keyword.fetch!(opts, :target)
    effects = Keyword.fetch!(opts, :effects)
    trigger = Keyword.fetch!(opts, :trigger)

    event =
      {caster, target}
      |> Event.new(trigger, effects)
      |> Event.apply_effects()

    turn
    |> Map.update!(:events, &[event | &1])
    |> Map.update!(:actors, fn actors ->
      updated = [event.caster, event.target]
      Actor.replace_with(actors, updated)
    end)
  end

  # Find the updated version of the leader from the turn.
  # Even though the leader is usually the first actor in the list, it's
  # safer to rely on the actor's id to find the correct one (just in case).
  defp fetch_leader(turn), do: Enum.find(turn.actors, &(&1.id == turn.leader.id))
  defp fetch_targets(turn), do: fetch_actors(turn, turn.action.target_ids)
  defp fetch_actors(turn, ids), do: Enum.filter(turn.actors, &(&1.id in ids))
end
