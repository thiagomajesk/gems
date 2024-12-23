defmodule GEMSWeb.Admin.Database.ResourceLive.Index do
  @moduledoc false
  use GEMSWeb, :live_view

  import GEMSWeb.UIKIT.Admin.DataTable

  alias GEMS.Engine.Schema.Ability
  alias GEMS.Engine.Schema.AbilityType
  alias GEMS.Engine.Schema.Biome
  alias GEMS.Engine.Schema.Creature
  alias GEMS.Engine.Schema.CreatureType
  alias GEMS.Engine.Schema.Element
  alias GEMS.Engine.Schema.Equipment
  alias GEMS.Engine.Schema.EquipmentType
  alias GEMS.Engine.Schema.Item
  alias GEMS.Engine.Schema.ItemType
  alias GEMS.World.Schema.Profession
  alias GEMS.Engine.Schema.State

  @collections %{
    "abilities" => %{
      module: Ability,
      preloads: [:type],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :code, type: :enum, label: "Code"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :type, type: :assoc, label: "Type"}
      ]
    },
    "ability-types" => %{
      module: AbilityType,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    },
    "biomes" => %{
      module: Biome,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    },
    "ability_types" => %{
      module: AbilityType,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    },
    "creature-types" => %{
      module: CreatureType,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    },
    "creatures" => %{
      module: Creature,
      preloads: [:type],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"},
        %{field: :type, type: :assoc, label: "Type"}
      ]
    },
    "elements" => %{
      module: Element,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    },
    "equipment-types" => %{
      module: EquipmentType,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    },
    "equipments" => %{
      module: Equipment,
      preloads: [:type],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"},
        %{field: :type, type: :assoc, label: "Type"}
      ]
    },
    "item-types" => %{
      module: ItemType,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    },
    "items" => %{
      module: Item,
      preloads: [:type],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"},
        %{field: :type, type: :assoc, label: "Type"}
      ]
    },
    "professions" => %{
      module: Profession,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    },
    "states" => %{
      module: State,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    }
  }

  def render(assigns) do
    ~H"""
    <section class="space-y-8">
      <header class="flex items-center justify-between w-full mb-4">
        <h1 class="text-2xl font-bold uppercase">{@title}</h1>
        <.link navigate={~p"/admin/database/#{@collection}/new"} class="btn btn-neutral">
          <UI.Icons.page name="circle-plus" /> New
        </.link>
      </header>
      <div class="card card-bordered bg-base-100">
        <.table_view id={"#{@collection}-catalog"} rows={@entities}>
          <:col :let={entity} :for={column <- @columns} label={column.label}>
            <.table_column
              collection={@collection}
              entity={entity}
              type={column.type}
              field={column.field}
            />
          </:col>
        </.table_view>
      </div>
    </section>
    """
  end

  def mount(%{"collection" => collection}, _session, socket) do
    %{
      module: module,
      preloads: preloads,
      columns: columns
    } = Map.fetch!(@collections, collection)

    entities =
      if connected?(socket),
        do: apply(module, :list, [preloads]),
        else: []

    {:ok,
     assign(socket,
       columns: columns,
       entities: entities,
       collection: collection,
       title: page_title(collection)
     )}
  end

  defp page_title(resource) do
    resource
    |> Recase.to_sentence()
    |> Exflect.pluralize()
    |> String.capitalize()
  end

  attr :type, :atom, required: true
  attr :field, :atom, required: true
  attr :entity, :map, required: true
  attr :collection, :string, required: true

  defp table_column(assigns) do
    %{entity: entity, field: field} = assigns
    value = Map.fetch!(entity, field)

    assigns
    |> assign(:value, value)
    |> render_table_column()
  end

  defp render_table_column(%{value: nil} = assigns) do
    ~H"""
    <span>---</span>
    """
  end

  defp render_table_column(%{type: :id} = assigns) do
    ~H"""
    <.link
      title={@value}
      navigate={~p"/admin/database/#{@collection}/#{@value}/edit"}
      class="font-medium link-primary hover:underline"
    >
      {List.first(String.split(@value, "-"))}
    </.link>
    """
  end

  defp render_table_column(%{type: :text} = assigns) do
    ~H"""
    <span>{@value}</span>
    """
  end

  defp render_table_column(%{type: :enum} = assigns) do
    ~H"""
    <i class="text-xs text-neutral uppercase">
      {Recase.to_title(to_string(@value))}
    </i>
    """
  end

  defp render_table_column(%{type: :assoc} = assigns) do
    ~H"""
    <.link
      title={@value.name}
      navigate={~p"/admin/database/elements/#{@value.id}/edit"}
      class="hover:underline"
    >
      {@value.name}
    </.link>
    """
  end

  defp render_table_column(assigns) do
    ~H"""
    <i>Missing column</i>
    """
  end
end
