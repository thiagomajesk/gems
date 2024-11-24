defmodule GEMSWeb.Admin.Database.ResourceLive.Index do
  @moduledoc false
  use GEMSWeb, :live_view

  import GemsWeb.UIKIT.Admin.DataTable

  alias GEMS.Engine.Schema.Ability
  alias GEMS.Engine.Schema.AbilityType
  alias GEMS.Engine.Schema.Biome
  alias GEMS.Engine.Schema.Blessing
  alias GEMS.Engine.Schema.Creature
  alias GEMS.Engine.Schema.CreatureType
  alias GEMS.Engine.Schema.Element
  alias GEMS.Engine.Schema.Equipment
  alias GEMS.Engine.Schema.EquipmentType
  alias GEMS.Engine.Schema.Faction
  alias GEMS.Engine.Schema.Guild
  alias GEMS.Engine.Schema.Item
  alias GEMS.Engine.Schema.ItemType
  alias GEMS.Engine.Schema.Pet
  alias GEMS.Engine.Schema.Profession
  alias GEMS.Engine.Schema.State
  alias GEMS.Engine.Schema.Zone

  @valid_resources [
    "abilities",
    "ability-types",
    "biomes",
    "blessings",
    "creature-types",
    "creatures",
    "elements",
    "equipment-types",
    "equipments",
    "factions",
    "guilds",
    "item-types",
    "items",
    "pets",
    "professions",
    "states",
    "zones"
  ]

  def render(assigns) do
    ~H"""
    <section class="space-y-8">
      <header class="flex items-center justify-between w-full mb-4">
        <h1 class="text-2xl font-bold uppercase">{@title}</h1>
        <.link navigate={~p"/admin/database/#{@resource}/new"} class="btn btn-neutral">
          <UI.Media.icon name="circle-plus" /> New
        </.link>
      </header>
      <div class="card card-bordered bg-base-100">
        <.table_view id={"#{@resource}-catalog"} rows={@entities}>
          <:col :let={entity} :for={{field, label} <- @columns} label={label}>
            <.table_column resource={@resource} entity={entity} field={field} />
          </:col>
        </.table_view>
      </div>
    </section>
    """
  end

  def mount(%{"resource" => resource}, _session, socket)
      when resource in @valid_resources do
    {:ok,
     assign(socket,
       resource: resource,
       title: title(resource),
       columns: columns(resource),
       entities: entities(resource)
     )}
  end

  defp entities("abilities"), do: Ability.list([:type])
  defp entities("ability-types"), do: AbilityType.list()
  defp entities("biomes"), do: Biome.list([:affinity, :aversion])
  defp entities("blessings"), do: Blessing.list()
  defp entities("creature-types"), do: CreatureType.list()
  defp entities("creatures"), do: Creature.list([:type])
  defp entities("elements"), do: Element.list()
  defp entities("equipment-types"), do: EquipmentType.list()
  defp entities("equipments"), do: Equipment.list([:type])
  defp entities("factions"), do: Faction.list()
  defp entities("guilds"), do: Guild.list()
  defp entities("item-types"), do: ItemType.list()
  defp entities("items"), do: Item.list([:type])
  defp entities("pets"), do: Pet.list()
  defp entities("professions"), do: Profession.list()
  defp entities("states"), do: State.list()
  defp entities("zones"), do: Zone.list()

  defp title(resource) do
    resource
    |> Recase.to_sentence()
    |> Exflect.pluralize()
    |> String.capitalize()
  end

  defp columns("abilities"),
    do: [
      {:id, "ID"},
      {:name, "Name"},
      {:type, "Type"}
    ]

  defp columns("blessings"), do: [{:id, "ID"}, {:name, "Name"}]

  defp columns("equipments"),
    do: [
      {:id, "ID"},
      {:name, "Name"},
      {:type, "Type"},
      {:slot, "Slot"},
      {:price, "Price"}
    ]

  defp columns("items"),
    do: [
      {:id, "ID"},
      {:name, "Name"},
      {:type, "Type"},
      {:price, "Price"},
      {:purpose, "Purpose"}
    ]

  defp columns("pets"), do: [{:id, "ID"}, {:name, "Name"}]
  defp columns("professions"), do: [{:id, "ID"}, {:name, "Name"}, {:type, "Type"}]
  defp columns("states"), do: [{:id, "ID"}, {:name, "Name"}]

  defp columns("creatures"),
    do: [
      {:id, "ID"},
      {:name, "Name"},
      {:type, "Type"}
    ]

  defp columns("factions"), do: [{:id, "ID"}, {:name, "Name"}]
  defp columns("guilds"), do: [{:id, "ID"}, {:name, "Name"}]
  defp columns("zones"), do: [{:id, "ID"}, {:name, "Name"}, {:skull, "Skull"}]
  defp columns("elements"), do: [{:id, "ID"}, {:name, "Name"}]

  defp columns("biomes"),
    do: [
      {:id, "ID"},
      {:name, "Name"},
      {:affinity, "Affinity"},
      {:aversion, "Aversion"}
    ]

  defp columns("ability-types"), do: [{:id, "ID"}, {:name, "Name"}]
  defp columns("item-types"), do: [{:id, "ID"}, {:name, "Name"}]

  defp columns("equipment-types"), do: [{:id, "ID"}, {:name, "Name"}]

  defp columns("creature-types"), do: [{:id, "ID"}, {:name, "Name"}]

  defp table_column(%{field: :id} = assigns) do
    assigns =
      assigns
      |> assign_new(:id, & &1.entity.id)
      |> assign_new(:formatted_id, &short_sha(&1.id))

    ~H"""
    <.link
      title={@id}
      navigate={~p"/admin/database/#{@resource}/#{@id}/edit"}
      class="font-medium hover:underline"
    >
      {@formatted_id}
    </.link>
    """
  end

  defp table_column(%{field: :type, resource: "professions"} = assigns) do
    ~H"""
    <span>
      {Recase.to_title(to_string(Map.fetch!(@entity, @field)))}
    </span>
    """
  end

  defp table_column(%{field: :type} = assigns) do
    assigns =
      assigns
      |> assign_new(:type_id, & &1.entity.type.id)
      |> assign_new(:type_name, & &1.entity.type.name)

    ~H"""
    <.link
      title={@type_id}
      navigate={~p"/admin/database/#{@resource}/#{@type_id}/edit"}
      class="hover:underline"
    >
      {@type_name}
    </.link>
    """
  end

  defp table_column(%{resource: "biomes", field: field} = assigns)
       when field in [:affinity, :aversion] do
    assoc = Map.get(assigns.entity, field)

    assigns =
      assigns
      |> assign(:assoc_id, get_in(assoc.id))
      |> assign(:assoc_name, get_in(assoc.name))

    ~H"""
    <%= if @assoc_id do %>
      <.link
        title={@assoc_id}
        navigate={~p"/admin/database/elements/#{@assoc_id}/edit"}
        class="hover:underline"
      >
        {@assoc_name}
      </.link>
    <% else %>
      <span>---</span>
    <% end %>
    """
  end

  defp table_column(assigns) do
    ~H"""
    {Map.fetch!(@entity, @field)}
    """
  end

  defp short_sha(id) do
    id
    |> String.split("-")
    |> List.first()
  end
end
