defmodule GEMSWeb.Game.StorageLive do
  use GEMSWeb, :live_view

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <section>
      <header class="mb-4">
        <div role="tablist" class="tabs tabs-bordered">
          <.link
            patch={~p"/game/storage?showing=items"}
            role="tab"
            class={["tab", @action == :items && "tab-active"]}
          >
            Items
          </.link>
          <.link
            patch={~p"/game/storage?showing=equipments"}
            role="tab"
            class={["tab", @action == :equipments && "tab-active"]}
          >
            Equipments
          </.link>
        </div>
      </header>
      <div :if={@action == :items} class="flex flex-wrap gap-4">
        <.async_result :let={character_items} assign={@character_items}>
          <:loading>Loading items...</:loading>
          <.item_card
            :for={character_item <- character_items}
            item={character_item.item}
            amount={character_item.amount}
          />
        </.async_result>
      </div>
      <div :if={@action == :equipments} class="flex flex-wrap gap-4">
        <.async_result :let={character_equipments} assign={@character_equipments}>
          <:loading>Loading equipments...</:loading>
          <.equipment_card
            :for={character_equipment <- character_equipments}
            item={character_equipment.equipment}
          />
        </.async_result>
      </div>
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    character = socket.assigns.selected_character

    {:ok,
     assign_async(socket, [:character_items, :character_equipments], fn ->
       character_items = GEMS.Characters.list_character_items(character, [:item])
       character_equipments = GEMS.Characters.list_character_equipments(character, [:equipment])
       {:ok, %{character_items: character_items, character_equipments: character_equipments}}
     end)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    case Map.get(params, "showing", "items") do
      "items" ->
        {:noreply, assign(socket, :action, :items)}

      "equipments" ->
        {:noreply, assign(socket, :action, :equipments)}
    end
  end

  attr :item, :any, required: true
  attr :amount, :integer, required: true

  defp item_card(assigns) do
    ~H"""
    <div class="card items-center bg-base-200 p-2 shadow" title={@item.name}>
      <img src="https://placehold.co/100" class="rounded-xl" />
      <span class="badge badge-neutral mt-2">{@amount}</span>
    </div>
    """
  end

  attr :item, :any, required: true
  attr :grade, :integer, default: 1

  defp equipment_card(assigns) do
    ~H"""
    <div class="card items-center bg-base-200 p-2 shadow" title={@item.name}>
      <img src="https://placehold.co/100" class="rounded-xl" />
      <span class="badge badge-neutral mt-2">{@grade}</span>
    </div>
    """
  end
end
