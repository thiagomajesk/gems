defmodule GEMSWeb.UIKIT.Lists do
  use GEMSWeb, :html

  slot :card, required: true do
    attr :title, :string, required: true
    attr :subtitle, :string, required: true
    attr :cover, :string, required: true
  end

  def cards_with_covers(assigns) do
    ~H"""
    <ul class="space-y-2">
      <li :for={card <- @card} class="flex rounded-lg bg-base-200 overflow-hidden shadow">
        <UI.Media.image
          src={GEMS.public_asset_path(card.cover)}
          width="150"
          class="object-cover"
          placeholder={%{width: "150", height: "150"}}
        />
        <div class="flex flex-col p-2 w-full">
          <h6 class="font-semibold text-base">{card.title}</h6>
          <p class="text-sm text-gray-400 mb-4">{card.subtitle}</p>
          <div class="mt-auto">{render_slot(card)}</div>
        </div>
      </li>
    </ul>
    """
  end
end
