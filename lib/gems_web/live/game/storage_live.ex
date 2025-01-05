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
            equipment={character_equipment.equipment}
            level={character_equipment.level}
            experience={character_equipment.experience}
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
    <div
      class={[
        "card items-center p-2 relative",
        tier_style_classes(@item.tier)
      ]}
      title={@item.name}
    >
      <img src="https://placehold.co/100" class="rounded-xl" />
      <span class="badge font-medium badge-ghost shadow-sm absolute top-1 gap-1">
        <UI.Icons.page name="star" class="fill-red-500" />
        <span>{format_tier_name(@item.tier)}</span>
      </span>
      <span class="badge badge-neutral mt-2">{@amount}</span>
    </div>
    """
  end

  attr :equipment, :any, required: true
  attr :level, :integer, required: true
  attr :experience, :integer, required: true

  defp equipment_card(assigns) do
    ~H"""
    <div
      class={[
        "card items-center p-2 relative",
        tier_style_classes(@equipment.tier)
      ]}
      title={@equipment.name}
    >
      <img src="https://placehold.co/100" class="rounded-xl" />
      <span class="badge font-medium badge-ghost shadow-sm absolute top-1 gap-1">
        <UI.Icons.page name="star" class="fill-red-500" />
        <span>{format_tier_name(@equipment.tier)}</span>
      </span>
      <div class="flex items-center w-full gap-2 mt-2">
        <span class="badge badge-neutral">{@level}</span>
        <progress class="progress" value={@experience} max="100"></progress>
      </div>
    </div>
    """
  end

  defp format_tier_name(:t1), do: "I"
  defp format_tier_name(:t2), do: "II"
  defp format_tier_name(:t3), do: "III"
  defp format_tier_name(:t4), do: "IV"
  defp format_tier_name(:t5), do: "V"
  defp format_tier_name(:t6), do: "VI"
  defp format_tier_name(:t7), do: "VII"
  defp format_tier_name(:t8), do: "VIII"
  defp format_tier_name(:t9), do: "IX"

  defp tier_style_classes(:t1),
    do: [
      "bg-gradient-to-t from-base-300",
      "to-gray-500/10 border border-gray-500/40"
    ]

  defp tier_style_classes(:t2),
    do: [
      "bg-gradient-to-t from-base-300",
      "to-stone-500/10 border border-stone-500/40"
    ]

  defp tier_style_classes(:t3),
    do: [
      "bg-gradient-to-t from-base-300",
      "to-green-500/10 border border-green-500/40 shadow-sm shadow-green-500/50"
    ]

  defp tier_style_classes(:t4),
    do: [
      "bg-gradient-to-t from-base-300",
      "to-blue-500/10 border border-blue-500/40 shadow-sm shadow-blue-500/50"
    ]

  defp tier_style_classes(:t5),
    do: [
      "bg-gradient-to-t from-base-300",
      "to-red-500/10 border border-red-500/40 shadow-sm shadow-red-500/50"
    ]

  defp tier_style_classes(:t6),
    do: [
      "bg-gradient-to-t from-base-300",
      "to-orange-500/10 border border-orange-500/40 shadow-sm shadow-orange-500/50"
    ]

  defp tier_style_classes(:t7),
    do: [
      "bg-gradient-to-t from-base-300",
      "to-yellow-500/10 border border-yellow-500/40 shadow-sm shadow-yellow-500/50"
    ]

  defp tier_style_classes(:t8),
    do: [
      "bg-gradient-to-t from-base-300",
      "to-purple-500/10 border border-purple-500/40 shadow-sm shadow-purple-500/50"
    ]

  defp tier_style_classes(:t9),
    do: [
      "bg-gradient-to-t from-base-300",
      "to-pink-500/10 border border-pink-500/40 shadow-sm shadow-pink-500/50"
    ]
end
