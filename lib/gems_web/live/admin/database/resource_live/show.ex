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
  alias GEMS.Engine.Schema.Profession
  alias GEMS.Engine.Schema.State

  alias GEMSWeb.Admin.Database.ResourceLive.Forms

  def render(assigns) do
    ~H"""
    <section class="space-y-8">
      <header class="flex items-center justify-between w-full mb-4">
        <h1 class="text-2xl font-bold uppercase">{@title}</h1>
      </header>
      <div class="card card-bordered p-4 bg-base-100">
        <.live_component module={@component} id="entity-form" form={@form} />
      </div>
    </section>
    """
  end

  def mount(%{"resource" => resource}, _session, socket) do
    {:ok,
     socket
     |> assign(:assocs, %{})
     |> assign(:resource, resource)
     |> assign(:component, form_module(resource))}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    %{
      live_action: action,
      resource: resource
    } = socket.assigns

    entity = entity(resource, id)
    changeset = changeset(resource, entity)

    {:noreply,
     socket
     |> assign(:form, to_form(changeset))
     |> assign(:title, page_title(resource, action))}
  end

  def handle_params(_params, _uri, socket) do
    %{
      live_action: action,
      resource: resource
    } = socket.assigns

    changeset = changeset(resource)

    {:noreply,
     socket
     |> assign(:form, to_form(changeset))
     |> assign(:title, page_title(resource, action))}
  end

  def handle_event("validate", %{"entity" => params}, socket) do
    %{
      form: %{data: entity},
      resource: resource
    } = socket.assigns

    changeset = changeset(resource, entity, params)

    {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"entity" => params}, socket) do
    action = socket.assigns.live_action
    {:noreply, save_entity(socket, action, params)}
  end

  defp page_title(resource, :new), do: "New • #{title(resource)}"
  defp page_title(resource, :edit), do: "Update • #{title(resource)}"

  defp title(resource) do
    resource
    |> Recase.to_sentence()
    |> Exflect.singularize()
    |> String.capitalize()
  end

  defp entity("abilities", id),
    do:
      Ability.get!(id,
        effects: [
          :recovery,
          :state_change,
          :parameter_change
        ]
      )

  defp entity("ability-types", id), do: AbilityType.get!(id)
  defp entity("biomes", id), do: Biome.get!(id)
  defp entity("creature-types", id), do: CreatureType.get!(id)

  defp entity("creatures", id),
    do:
      Creature.get!(id,
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
      )

  defp entity("elements", id), do: Element.get!(id)
  defp entity("equipment-types", id), do: EquipmentType.get!(id)

  defp entity("equipments", id),
    do:
      Equipment.get!(id,
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
      )

  defp entity("item-types", id), do: ItemType.get!(id)

  defp entity("items", id),
    do:
      Item.get!(id,
        effects: [
          :recovery,
          :state_change,
          :parameter_change
        ]
      )

  defp entity("professions", id), do: Profession.get!(id)

  defp entity("states", id),
    do:
      State.get!(id,
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
      )

  defp changeset(resource, entity \\ nil, attrs \\ %{})

  defp changeset("abilities", entity, attrs), do: Ability.change(entity, attrs)
  defp changeset("ability-types", entity, attrs), do: AbilityType.change(entity, attrs)
  defp changeset("biomes", entity, attrs), do: Biome.change(entity, attrs)
  defp changeset("creature-types", entity, attrs), do: CreatureType.change(entity, attrs)
  defp changeset("creatures", entity, attrs), do: Creature.change(entity, attrs)
  defp changeset("elements", entity, attrs), do: Element.change(entity, attrs)
  defp changeset("equipment-types", entity, attrs), do: EquipmentType.change(entity, attrs)
  defp changeset("equipments", entity, attrs), do: Equipment.change(entity, attrs)
  defp changeset("item-types", entity, attrs), do: ItemType.change(entity, attrs)
  defp changeset("items", entity, attrs), do: Item.change(entity, attrs)
  defp changeset("professions", entity, attrs), do: Profession.change(entity, attrs)
  defp changeset("states", entity, attrs), do: State.change(entity, attrs)

  defp create_resource("abilities", attrs), do: Ability.create(attrs)
  defp create_resource("ability-types", attrs), do: AbilityType.create(attrs)
  defp create_resource("biomes", attrs), do: Biome.create(attrs)
  defp create_resource("creature-types", attrs), do: CreatureType.create(attrs)
  defp create_resource("creatures", attrs), do: Creature.create(attrs)
  defp create_resource("elements", attrs), do: Element.create(attrs)
  defp create_resource("equipment-types", attrs), do: EquipmentType.create(attrs)
  defp create_resource("equipments", attrs), do: Equipment.create(attrs)
  defp create_resource("item-types", attrs), do: ItemType.create(attrs)
  defp create_resource("items", attrs), do: Item.create(attrs)
  defp create_resource("professions", attrs), do: Profession.create(attrs)
  defp create_resource("states", attrs), do: State.create(attrs)

  defp update_resource("abilities", entity, attrs), do: Ability.update(entity, attrs)
  defp update_resource("ability-types", entity, attrs), do: AbilityType.update(entity, attrs)
  defp update_resource("biomes", entity, attrs), do: Biome.update(entity, attrs)
  defp update_resource("creature-types", entity, attrs), do: CreatureType.update(entity, attrs)
  defp update_resource("creatures", entity, attrs), do: Creature.update(entity, attrs)
  defp update_resource("elements", entity, attrs), do: Element.update(entity, attrs)
  defp update_resource("equipment-types", entity, attrs), do: EquipmentType.update(entity, attrs)
  defp update_resource("equipments", entity, attrs), do: Equipment.update(entity, attrs)
  defp update_resource("item-types", entity, attrs), do: ItemType.update(entity, attrs)
  defp update_resource("items", entity, attrs), do: Item.update(entity, attrs)
  defp update_resource("professions", entity, attrs), do: Profession.update(entity, attrs)
  defp update_resource("states", entity, attrs), do: State.update(entity, attrs)

  defp form_module("abilities"), do: Forms.AbilityComponent
  defp form_module("ability-types"), do: Forms.AbilityTypeComponent
  defp form_module("biomes"), do: Forms.BiomeComponent
  defp form_module("creature-types"), do: Forms.CreatureTypeComponent
  defp form_module("creatures"), do: Forms.CreatureComponent
  defp form_module("elements"), do: Forms.ElementComponent
  defp form_module("equipment-types"), do: Forms.EquipmentTypeComponent
  defp form_module("equipments"), do: Forms.EquipmentComponent
  defp form_module("item-types"), do: Forms.ItemTypeComponent
  defp form_module("items"), do: Forms.ItemComponent
  defp form_module("professions"), do: Forms.ProfessionComponent
  defp form_module("states"), do: Forms.StateComponent

  defp save_entity(socket, :new, params) do
    %{resource: resource} = socket.assigns

    case create_resource(resource, params) do
      {:ok, entity} ->
        changeset = changeset(resource, entity)

        socket
        |> assign(:entity, entity)
        |> assign(:form, to_form(changeset))
        |> put_flash(:success, "Entity created successfully.")
        |> push_patch(to: ~p"/admin/database/#{resource}/#{entity}/edit")

      {:error, %Ecto.Changeset{} = changeset} ->
        dbg(changeset)

        socket
        |> assign(:form, to_form(changeset))
        |> put_flash(:error, "Failed to create entity.")
    end
  end

  defp save_entity(socket, :edit, params) do
    %{
      form: %{data: entity},
      resource: resource
    } = socket.assigns

    case update_resource(resource, entity, params) do
      {:ok, entity} ->
        changeset = changeset(resource, entity)

        socket
        |> assign(:form, to_form(changeset))
        |> put_flash(:success, "Entity updated successfully.")
        |> push_patch(to: ~p"/admin/database/#{resource}/#{entity}/edit")

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> assign(:form, %{to_form(changeset) | params: params})
        |> put_flash(:error, "Failed to update entity.")
    end
  end
end
