defmodule GEMSWeb.CharacterLive.AttributeAllocatorComponent do
  use GEMSWeb, :live_component

  @max_points GEMSData.GameInfo.starting_character_points()

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 bg-base-content/5 rounded-btn p-4">
      <div role="alert" class="alert">
        <UI.Icons.page
          :if={@total < @max_points && @errors == []}
          name="circle-alert"
          class="text-info"
          size={18}
        />
        <UI.Icons.page
          :if={@total == @max_points && @errors == []}
          name="thumbs-up"
          class="text-success"
          size={18}
        />
        <div>
          <h3 class="font-bold">Distribute your attributes!</h3>
          <p :if={@errors == []}>You have distributed {@total} of {@max_points}</p>
          <p :if={@errors != []} class="text-error">{@errors}</p>
        </div>
      </div>
      <div class="flex items-center gap-4">
        <div class="flex items-center gap-2 w-32">
          <UI.Icons.game name="biceps" size={24} class="text-rose-500" />
          <span class="font-medium text-lg">Strength</span>
        </div>
        <.range_input
          field={@form[:strength]}
          target={@myself}
          value={@strength}
          attribute="strength"
        />
      </div>
      <div class="flex items-center gap-4">
        <div class="flex items-center gap-2 w-32">
          <UI.Icons.game name="sprint" size={24} class="text-emerald-500" />
          <span class="font-medium text-lg">Dexterity</span>
        </div>
        <.range_input
          field={@form[:dexterity]}
          target={@myself}
          value={@dexterity}
          attribute="dexterity"
        />
      </div>
      <div class="flex items-center gap-4">
        <div class="flex items-center gap-2 w-32">
          <UI.Icons.game name="brain" size={24} class="text-indigo-500" />
          <span class="font-medium text-lg">Intelligence</span>
        </div>
        <.range_input
          field={@form[:intelligence]}
          target={@myself}
          value={@intelligence}
          attribute="intelligence"
        />
      </div>
    </div>
    """
  end

  def handle_event("change-attribute", %{"character" => attr_and_value}, socket) do
    %{strength: str, dexterity: dex, intelligence: int} = socket.assigns

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
    {:ok,
     socket
     |> update_attributes(0, 0, 0)
     |> assign(max_points: @max_points)}
  end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign_required(assigns, [:id, :form])
     |> assign_attribute_errors()}
  end

  defp update_attributes(socket, strength, dexterity, intelligence) do
    assign(socket,
      strength: strength,
      dexterity: dexterity,
      intelligence: intelligence,
      total: strength + dexterity + intelligence
    )
  end

  defp assign_attribute_errors(socket) do
    %{form: %{source: changeset} = form} = socket.assigns

    if used_any_input?(form, [:strength, :dexterity, :intelligence]),
      do: assign(socket, :errors, get_errors(changeset, :attributes)),
      else: assign(socket, :errors, [])
  end

  attr :target, :any, required: true
  attr :field, Phoenix.HTML.FormField, required: true
  attr :value, :integer, required: true
  attr :attribute, :string, required: true, values: ~w(strength dexterity intelligence)

  defp range_input(assigns) do
    assigns = assign_input_state(assigns, assigns.field)

    ~H"""
    <div class="flex items-center grow gap-4">
      <input
        type="range"
        min="0"
        max="100"
        value={@value}
        name={@name}
        class="range range-xs range-primary"
        phx-target={@target}
        phx-change="change-attribute"
      />
      <output class="tabular-nums bg-base-200 px-2 py-1 rounded-btn shadow text-primary w-10 flex items-center justify-center">
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
