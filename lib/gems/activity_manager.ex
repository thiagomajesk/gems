defmodule GEMS.ActivityManager do
  use GenServer

  alias GEMS.World.Schema.Character

  @topic_prefix "activities"

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

  def fetch_state(%Character{} = character) do
    GenServer.call(__MODULE__, {:fetch_state, character})
  end

  def start_activity(character, activity) do
    GenServer.cast(__MODULE__, {:start_activity, character, activity})
  end

  def stop_activity(character, activity) do
    GenServer.cast(__MODULE__, {:stop_activity, character, activity})
  end

  @impl true
  def init(_args) do
    {:ok, %{activity_lookup: %{}}}
  end

  @impl true
  def handle_cast({:start_activity, character, activity}, state) do
    send(self(), {:start_activity, character, activity})
    {:noreply, state}
  end

  @impl true
  def handle_cast({:stop_activity, character, activity}, state) do
    send(self(), {:stop_activity, character, activity})
    {:noreply, state}
  end

  @impl true
  def handle_call({:fetch_state, character}, _from, state) do
    {:reply, Map.get(state.activity_lookup, character.id), state}
  end

  @impl true
  def handle_info({:start_activity, character, activity}, state) do
    %{activity_lookup: activity_lookup} = state

    case Map.get(activity_lookup, character.id) do
      nil ->
        time = :timer.seconds(activity.duration)

        message = {:stop_activity, character, activity}
        timer = Process.send_after(self(), message, time)

        activity_metadata = %{
          timer: timer,
          activity: activity,
          character: character
        }

        Phoenix.PubSub.broadcast_from(
          GEMS.PubSub,
          self(),
          build_topic(character),
          {:activity_started, activity_metadata}
        )

        activity_lookup = Map.put(activity_lookup, character.id, activity_metadata)
        {:noreply, Map.put(state, :activity_lookup, activity_lookup)}

      %{activity: ^activity} ->
        Logger.info("""
        Trying to start already running activity, ignoring... \n
        #{inspect(character.id)} | #{inspect(activity.id)}
        """)

        {:noreply, state}

      %{activity: running_activity} ->
        send(self(), {:stop_activity, character, running_activity})
        send(self(), {:start_activity, character, activity})

        {:noreply, state}
    end
  end

  @impl true
  def handle_info({:stop_activity, character, activity}, state) do
    %{activity_lookup: activity_lookup} = state

    case Map.get(activity_lookup, character.id) do
      nil ->
        Logger.info("""
        Trying to stop already stopped activity, ignoring... \n
        #{inspect(character.id)} | #{inspect(activity.id)}
        """)

        {:noreply, state}

      %{timer: timer} = activity_metadata ->
        Process.cancel_timer(timer)

        Phoenix.PubSub.broadcast_from(
          GEMS.PubSub,
          self(),
          build_topic(character),
          {:activity_stopped, activity_metadata}
        )

        activity_lookup = Map.delete(activity_lookup, character.id)
        {:noreply, Map.put(state, :activity_lookup, activity_lookup)}
    end
  end

  defp build_topic(character) do
    %{id: id, zone_id: zone_id} = character
    "#{@topic_prefix}:zone:#{zone_id}:character:#{id}"
  end
end