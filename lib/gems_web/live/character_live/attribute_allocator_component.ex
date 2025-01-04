defmodule GEMSWeb.CharacterLive.AttributeAllocatorComponent do
  use GEMSWeb, :live_component

  @max_points GEMSData.GameInfo.starting_character_points()

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 card bg-base-300 p-4">
      <div role="alert" class="alert">
        <UI.Icons.page :if={@total < @max_points} name="circle-alert" class="text-info" />
        <UI.Icons.page :if={@total == @max_points} name="thumbs-up" class="text-success" />
        <div>
          <h3 class="font-bold">Time to distribute your attributes</h3>
          <p :if={@errors == []}>You have distributed {@total} of {@max_points} points</p>
          <p :if={@errors != []} class="text-error">{@errors}</p>
        </div>
      </div>
      <div class="flex flex-col">
        <div class="flex items-center gap-4">
          <div class="flex items-center gap-2 w-32">
            <UI.Icons.game name="biceps" size="24" class="text-rose-500" />
            <span class="font-medium text-lg">Strength</span>
          </div>
          <.range_input field={@form[:strength]} target={@myself} attribute="strength" />
        </div>
        <p class="text-base-content/50">
          The raw power behind heavy blows and unmatched resilience in the heat of battle.
        </p>
      </div>
      <div class="flex flex-col">
        <div class="flex items-center gap-4">
          <div class="flex items-center gap-2 w-32">
            <UI.Icons.game name="sprint" size="24" class="text-emerald-500" />
            <span class="font-medium text-lg">Dexterity</span>
          </div>
          <.range_input field={@form[:dexterity]} target={@myself} attribute="dexterity" />
        </div>
        <p class="text-base-content/50">
          The speed, precision, and finesse that define a master of agility and control.
        </p>
      </div>
      <div class="flex flex-col">
        <div class="flex items-center gap-4">
          <div class="flex items-center gap-2 w-32">
            <UI.Icons.game name="brain" size="24" class="text-indigo-500" />
            <span class="font-medium text-lg">Intelligence</span>
          </div>
          <.range_input field={@form[:intelligence]} target={@myself} attribute="intelligence" />
        </div>
        <p class="text-base-content/50">
          The sharp mind capable of unraveling mysteries and wielding arcane knowledge.
        </p>
      </div>
    </div>
    """
  end

  def handle_event("change-attribute", %{"character" => attr_and_value}, socket) do
    %{form: %{source: changeset}} = socket.assigns

    str = Ecto.Changeset.get_field(changeset, :strength)
    dex = Ecto.Changeset.get_field(changeset, :dexterity)
    int = Ecto.Changeset.get_field(changeset, :intelligence)

    case Map.to_list(attr_and_value) do
      [{"strength", value}] ->
        str = String.to_integer(value)
        {dex, int} = redistribute(str, dex, int)
        {:noreply, update_attributes(socket, str, dex, int)}

      [{"intelligence", value}] ->
        int = String.to_integer(value)
        {str, dex} = redistribute(int, str, dex)
        {:noreply, update_attributes(socket, str, dex, int)}

      [{"dexterity", value}] ->
        dex = String.to_integer(value)
        {int, str} = redistribute(dex, int, str)
        {:noreply, update_attributes(socket, str, dex, int)}
    end
  end

  def mount(socket) do
    {:ok, assign(socket, max_points: @max_points, total: 0)}
  end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign_required(assigns, [:id, :form])
     |> assign_attribute_errors()}
  end

  defp update_attributes(socket, str, dex, int) do
    attributes = %{
      "strength" => str,
      "dexterity" => dex,
      "intelligence" => int
    }

    send(self(), {__MODULE__, :validate, attributes})

    assign(socket, total: str + dex + int)
  end

  defp assign_attribute_errors(socket) do
    %{form: %{source: changeset} = form} = socket.assigns

    if changeset.action == :insert and
         used_any_input?(form, [:strength, :dexterity, :intelligence]),
       do: assign(socket, :errors, get_errors(changeset, :attributes)),
       else: assign(socket, :errors, [])
  end

  attr :target, :any, required: true
  attr :field, Phoenix.HTML.FormField, required: true
  attr :attribute, :string, required: true, values: ~w(strength dexterity intelligence)

  defp range_input(assigns) do
    assigns = assign_input_state(assigns, assigns.field)

    ~H"""
    <div class="flex items-center grow gap-4">
      <input
        type="range"
        min="0"
        max="100"
        name={@name}
        id={@id}
        value={@value}
        class="range range-xs range-primary"
        phx-target={@target}
        phx-change="change-attribute"
      />
      <output class="tabular-nums bg-base-content/5 px-2 py-1 rounded-btn w-10 flex items-center justify-center">
        {@value}
      </output>
    </div>
    """
  end

  defp redistribute(updated, primary, secondary) do
    case updated + primary + secondary do
      total when total > @max_points ->
        overflow = total - @max_points

        total_to_reduce = primary + secondary
        primary_reduce = trunc(Float.floor(overflow * (primary / total_to_reduce)))
        secondary_reduce = overflow - primary_reduce

        {primary - primary_reduce, secondary - secondary_reduce}

      _lesser_than_max_value ->
        {primary, secondary}
    end
  end
end
