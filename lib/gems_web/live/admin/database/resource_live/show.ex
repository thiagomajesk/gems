defmodule GEMSWeb.Admin.Database.ResourceLive.Show do
  @moduledoc false
  use GEMSWeb, :live_view

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

  alias GEMSWeb.Admin.Database.ResourceLive.Forms

  @collections %{
    "abilities" => %{
      module: Ability,
      component: Forms.AbilityComponent,
      preloads: [
        effects: [
          :recovery,
          :state_change,
          :parameter_change
        ]
      ]
    },
    "ability-types" => %{
      module: AbilityType,
      component: Forms.AbilityTypeComponent,
      preloads: []
    },
    "biomes" => %{
      module: Biome,
      component: Forms.BiomeComponent,
      preloads: []
    },
    "creature-types" => %{
      module: CreatureType,
      component: Forms.CreatureTypeComponent,
      preloads: []
    },
    "creatures" => %{
      module: Creature,
      component: Forms.CreatureComponent,
      preloads: [
        traits: [
          :ability_seal,
          :attack_ability,
          :attack_element,
          :attack_state,
          :element_rate,
          :equipment_seal,
          :item_seal,
          :parameter_change,
          :parameter_rate,
          :state_rate
        ]
      ]
    },
    "elements" => %{
      module: Element,
      component: Forms.ElementComponent,
      preloads: []
    },
    "equipment-types" => %{
      module: EquipmentType,
      component: Forms.EquipmentTypeComponent,
      preloads: []
    },
    "equipments" => %{
      module: Equipment,
      component: Forms.EquipmentComponent,
      preloads: [
        traits: [
          :ability_seal,
          :attack_ability,
          :attack_element,
          :attack_state,
          :element_rate,
          :equipment_seal,
          :item_seal,
          :parameter_change,
          :parameter_rate,
          :state_rate
        ]
      ]
    },
    "items" => %{
      module: Item,
      component: Forms.ItemComponent,
      preloads: [
        effects: [
          :recovery,
          :state_change,
          :parameter_change
        ]
      ]
    },
    "item-types" => %{
      module: ItemType,
      component: Forms.ItemTypeComponent,
      preloads: []
    },
    "professions" => %{
      module: Profession,
      component: Forms.ProfessionComponent,
      preloads: []
    },
    "states" => %{
      module: State,
      component: Forms.StateComponent,
      preloads: [
        traits: [
          :ability_seal,
          :attack_ability,
          :attack_element,
          :attack_state,
          :element_rate,
          :equipment_seal,
          :item_seal,
          :parameter_change,
          :parameter_rate,
          :state_rate
        ]
      ]
    }
  }

  def render(assigns) do
    ~H"""
    <section class="space-y-8">
      <header class="flex items-center justify-between w-full mb-4">
        <h1 class="text-2xl font-bold uppercase">{@title}</h1>
      </header>
      <div class="card card-bordered p-4 bg-base-100">
        <.live_component module={@component} id="entity-form" form={@form} live_action={@live_action} />
      </div>
    </section>
    """
  end

  def mount(%{"collection" => collection}, _session, socket) do
    %{
      module: module,
      preloads: preloads,
      component: component
    } = Map.fetch!(@collections, collection)

    {:ok,
     assign(socket,
       module: module,
       preloads: preloads,
       component: component,
       collection: collection
     )}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    %{
      module: module,
      preloads: preloads,
      live_action: live_action,
      collection: collection
    } = socket.assigns

    entity = get_entity!(module, id, preloads)
    changeset = change_entity(module, entity)

    {:noreply,
     assign(
       socket,
       form: to_form(changeset),
       title: page_title(collection, live_action)
     )}
  end

  def handle_params(_params, _uri, socket) do
    %{
      module: module,
      live_action: live_action,
      collection: collection
    } = socket.assigns

    changeset = change_entity(module)

    {:noreply,
     assign(
       socket,
       form: to_form(changeset),
       title: page_title(collection, live_action)
     )}
  end

  def handle_event("validate", %{"entity" => params}, socket) do
    %{
      module: module,
      form: %{data: entity}
    } = socket.assigns

    changeset = change_entity(module, entity, params)

    {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"entity" => params}, socket) do
    action = socket.assigns.live_action
    {:noreply, save_entity(socket, action, params)}
  end

  def handle_event("code-hint", %{"prefix" => prefix, "value" => name}, socket) do
    %{form: %{source: changeset}} = socket.assigns

    code = Recase.to_snake("#{prefix}-#{name}")
    changeset = Ecto.Changeset.put_change(changeset, :code, code)
    {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
  end

  defp page_title(collection, :new), do: "New • #{title(collection)}"
  defp page_title(collection, :edit), do: "Update • #{title(collection)}"

  defp title(collection) do
    collection
    |> Recase.to_sentence()
    |> Exflect.singularize()
    |> String.capitalize()
  end

  defp get_entity!(module, id, preloads), do: apply(module, :get!, [id, preloads])

  defp change_entity(module, entity \\ nil, attrs \\ %{}),
    do: apply(module, :change, [entity, attrs])

  defp create_entity(module, attrs), do: apply(module, :create, [attrs])
  defp update_entity(module, entity, attrs), do: apply(module, :update, [entity, attrs])

  defp save_entity(socket, :new, params) do
    %{module: module, collection: collection} = socket.assigns

    case create_entity(module, params) do
      {:ok, entity} ->
        changeset = change_entity(module, entity)

        socket
        |> assign(:entity, entity)
        |> assign(:form, to_form(changeset))
        |> put_flash(:success, "Entity created successfully.")
        |> push_patch(to: ~p"/admin/database/#{collection}/#{entity}/edit")

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> assign(:form, to_form(changeset))
        |> put_flash(:error, "Failed to create entity.")
    end
  end

  defp save_entity(socket, :edit, params) do
    %{
      module: module,
      form: %{data: entity},
      collection: collection
    } = socket.assigns

    case update_entity(module, entity, params) do
      {:ok, entity} ->
        changeset = change_entity(module, entity)

        socket
        |> assign(:form, to_form(changeset))
        |> put_flash(:success, "Entity updated successfully.")
        |> push_patch(to: ~p"/admin/database/#{collection}/#{entity}/edit")

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> assign(:form, %{to_form(changeset) | params: params})
        |> put_flash(:error, "Failed to update entity.")
    end
  end
end
