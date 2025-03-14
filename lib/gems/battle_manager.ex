defmodule GEMS.BattleManager do
  use GenServer

  alias GEMS.World.Schema.Character
  alias GEMS.Engine.Battler.Battle

  @topic_prefix "battles"

  require Logger

  def start_link(args \\ %{}) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def subscribe(%Character{} = character) do
    topic = build_topic(character)
    Phoenix.PubSub.subscribe(GEMS.PubSub, topic)
  end

  def unsubscribe(%Character{} = character) do
    topic = build_topic(character)
    Phoenix.PubSub.unsubscribe(GEMS.PubSub, topic)
  end

  # def fetch_state(%Character{} = character) do
  #   GenServer.call(__MODULE__, {:fetch_state, character})
  # end

  def create_battle(%Battle{} = battle) do
    GenServer.call(__MODULE__, {:create_battle, battle})
  end

  @impl true
  def init(_args) do
    {:ok, %{battle_lookup: %{}, character_lookup: %{}}}
  end

  @impl true
  def handle_call({:create_battle, battle}, _from, state) do
    %{battle_lookup: battle_lookup} = state

    identifier = Ecto.UUID.generate()

    # Chances of collision are low but not none. It doesn't hurt
    # to be carefull, so we check if the identifier is already in use
    case Map.get(battle_lookup, identifier) do
      %Battle{} ->
        reason = "Battle with identifier #{identifier} already exists"
        {:reply, {:error, reason}, state}

      nil ->
        battle_lookup = Map.put(battle_lookup, identifier, battle)
        {:reply, {:ok, identifier}, Map.put(state, :battle_lookup, battle_lookup)}
    end
  end

  @impl true
  def handle_call({:fetch_state, character}, _from, state) do
    {:reply, Map.get(state.battle_lookup, character.id), state}
  end

  @impl true
  def handle_cast({:stop_battle, character, battle}, state) do
    send(self(), {:stop_battle, character, battle})
    {:noreply, state}
  end

  defp build_topic(character) do
    %{id: id, zone_id: zone_id} = character
    "#{@topic_prefix}:zone:#{zone_id}:character:#{id}"
  end
end
