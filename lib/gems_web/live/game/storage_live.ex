defmodule GEMSWeb.Game.StorageLive do
  use GEMSWeb, :live_view

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <UI.Navigation.tabs current_path={~p"/game/storage"} current_action={@action}>
      <:tabs action={:items} label="Items">
        <.async_result :let={character_items} assign={@character_items}>
          <:loading>Loading items...</:loading>
          <.item_card
            :for={character_item <- character_items}
            item={character_item.item}
            amount={character_item.amount}
          />
        </.async_result>
      </:tabs>
      <:tabs action={:equipments} label="Equipments">
        <.async_result :let={character_equipments} assign={@character_equipments}>
          <:loading>Loading equipments...</:loading>
          <.equipment_card
            :for={character_equipment <- character_equipments}
            equipment={character_equipment.equipment}
            level={character_equipment.level}
            experience={character_equipment.experience}
          />
        </.async_result>
      </:tabs>
    </UI.Navigation.tabs>
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
        "card items-center relative",
        tier_style_classes(@item.tier)
      ]}
      title={@item.name}
    >
      <div class="card-body p-2 w-32 gap-1">
        <UI.Media.image placeholder={%{height: 80, width: 80}} class="rounded-box" />
        <span class="flex items-center rounded-box px-2 font-medium bg-base-100/50 backdrop-blur-sm shadow absolute top-1 self-center gap-1">
          <UI.Icons.page name="star" />
          <span>{format_tier_name(@item.tier)}</span>
        </span>
        <span class="font-semibold self-center">{@item.name}</span>
        <span class="badge badge-neutral self-center">{@amount}</span>
      </div>
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
        "card items-center relative",
        tier_style_classes(@equipment.tier)
      ]}
      title={@equipment.name}
    >
      <div class="card-body p-2 w-32 gap-1">
        <UI.Media.image placeholder={%{height: 80, width: 80}} class="rounded-box" />
        <span class="flex items-center rounded-box px-2 font-medium bg-base-100/50 backdrop-blur-sm shadow absolute top-1 self-center gap-1">
          <UI.Icons.page name="star" class="fill-red-500" />
          <span>{format_tier_name(@equipment.tier)}</span>
        </span>
        <span class="font-semibold self-center">{@level}</span>
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
      "bg-linear-to-t from-base-100 to-gray-500/20",
      "border border-gray-500/20 shadow-xs shadow-gray-500/20"
    ]

  defp tier_style_classes(:t2),
    do: [
      "bg-linear-to-t from-base-100 to-stone-500/20",
      "border border-stone-500/20 shadow-xs shadow-stone-500/20"
    ]

  defp tier_style_classes(:t3),
    do: [
      "bg-linear-to-t from-base-100 to-green-500/20",
      "border border-green-500/20 shadow-xs shadow-green-500/20"
    ]

  defp tier_style_classes(:t4),
    do: [
      "bg-linear-to-t from-base-100 to-blue-500/20",
      "border border-blue-500/20 shadow-xs shadow-blue-500/20"
    ]

  defp tier_style_classes(:t5),
    do: [
      "bg-linear-to-t from-base-100 to-red-500/20",
      "border border-red-500/20 shadow-xs shadow-red-500/20"
    ]

  defp tier_style_classes(:t6),
    do: [
      "bg-linear-to-t from-base-100 to-orange-500/20",
      "border border-orange-500/20 shadow-xs shadow-orange-500/20"
    ]

  defp tier_style_classes(:t7),
    do: [
      "bg-linear-to-t from-base-100 to-yellow-500/20",
      "border border-yellow-500/20 shadow-xs shadow-yellow-500/20"
    ]

  defp tier_style_classes(:t8),
    do: [
      "bg-linear-to-t from-base-100 to-purple-500/20",
      "border border-purple-500/20 shadow-xs shadow-purple-500/20"
    ]

  defp tier_style_classes(:t9),
    do: [
      "bg-linear-to-t from-base-100 to-pink-500/20",
      "border border-pink-500/20 shadow-xs shadow-pink-500/20"
    ]
end
