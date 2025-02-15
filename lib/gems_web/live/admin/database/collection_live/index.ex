defmodule GEMSWeb.Admin.Database.CollectionLive.Index do
  @moduledoc false
  use GEMSWeb, :live_view

  alias GEMSWeb.Collections
  import GEMSWeb.UIKIT.Admin.DataTable

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
    %{columns: columns} = Collections.spec(collection)

    entities =
      if connected?(socket),
        do: Collections.list_entities(collection),
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

  defp render_table_column(%{field: :code} = assigns) do
    ~H"""
    <span class="rounded px-1 bg-base-content/10 shadow">{@value}</span>
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
