defmodule GEMSWeb.Admin.Database.CollectionLive.Show do
  @moduledoc false
  use GEMSWeb, :live_view

  require Logger

  alias GEMSWeb.Collections

  def render(assigns) do
    ~H"""
    <section class="space-y-8">
      <header class="flex items-center justify-between w-full mb-4">
        <h1 class="text-2xl font-bold uppercase">{@title}</h1>
      </header>
      <div class="card card-border p-4 bg-base-100">
        <.live_component module={@component} id="entity-form" form={@form} live_action={@live_action} />
      </div>
    </section>
    """
  end

  def mount(%{"collection" => collection}, _session, socket) do
    %{form: component} = Collections.spec(collection)

    {:ok,
     assign(socket,
       component: component,
       collection: collection
     )}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    %{live_action: live_action, collection: collection} = socket.assigns

    entity = Collections.get_entity(collection, id)
    changeset = Collections.change_entity(collection, entity)

    {:noreply,
     assign(
       socket,
       form: to_form(changeset),
       title: page_title(collection, live_action)
     )}
  end

  def handle_params(_params, _uri, socket) do
    %{live_action: live_action, collection: collection} = socket.assigns

    changeset = Collections.change_entity(collection)

    {:noreply,
     assign(
       socket,
       form: to_form(changeset),
       title: page_title(collection, live_action)
     )}
  end

  def handle_event("validate", %{"entity" => params}, socket) do
    %{collection: collection, form: %{data: entity}} = socket.assigns

    changeset = Collections.change_entity(collection, entity, params)

    {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"entity" => params}, socket) do
    action = socket.assigns.live_action
    {:noreply, save_entity(socket, action, params)}
  end

  def handle_event("code-hint", %{"value" => name}, socket) do
    %{form: %{source: changeset}} = socket.assigns

    code = Recase.to_snake(name)
    changeset = Ecto.Changeset.put_change(changeset, :code, code)
    {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
  end

  def handle_info({_component, :validate, merge_params}, socket) do
    %{collection: collection, form: %{data: entity, params: params}} = socket.assigns
    changeset = Collections.change_entity(collection, entity, Map.merge(params, merge_params))
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  defp page_title(collection, :new), do: "New • #{title(collection)}"
  defp page_title(collection, :edit), do: "Update • #{title(collection)}"

  defp title(collection) do
    collection
    |> Recase.to_sentence()
    |> Exflect.singularize()
    |> String.capitalize()
  end

  defp save_entity(socket, :new, params) do
    %{collection: collection} = socket.assigns

    case Collections.create_entity(collection, params) do
      {:ok, entity} ->
        changeset = Collections.change_entity(collection, entity)

        socket
        |> assign(:entity, entity)
        |> assign(:form, to_form(changeset))
        |> put_flash(:success, "Entity created successfully.")
        |> push_patch(to: ~p"/admin/database/#{collection}/#{entity}/edit")

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = GEMS.ErrorHelpers.collect_errors(changeset)
        Logger.error("Failed to save entity: #{inspect(errors)}")

        socket
        |> assign(:form, to_form(changeset))
        |> put_flash(:error, "Failed to create entity.")
    end
  end

  defp save_entity(socket, :edit, params) do
    %{collection: collection, form: %{data: entity}} = socket.assigns

    case Collections.update_entity(collection, entity, params) do
      {:ok, entity} ->
        changeset = Collections.change_entity(collection, entity)

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
