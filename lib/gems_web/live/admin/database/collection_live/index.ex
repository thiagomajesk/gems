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
        <.link navigate={~p"/admin/database/#{@collection}/new"} class="btn btn-sm btn-primary">
          <UI.Icons.page name="circle-plus" class="text-[1.2em]" /> Add
        </.link>
      </header>
      <.table_view id={"#{@collection}-catalog"} rows={@entities}>
        <:col
          :let={entity}
          :for={column <- @columns}
          label={column.label}
          class={if column.field == :name, do: "w-full"}
        >
          <.table_column
            collection={@collection}
            entity={entity}
            type={column.type}
            field={column.field}
          />
        </:col>
      </.table_view>
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
    <small class="badge badge-soft badge-neutral">
      {@value}
    </small>
    """
  end

  defp render_table_column(%{type: :id} = assigns) do
    ~H"""
    <span class="badge badge-soft badge-accent">
      <.link
        title={@value}
        navigate={~p"/admin/database/#{@collection}/#{@value}/edit"}
        class="link-hover"
      >
        {List.first(String.split(@value, "-"))}
      </.link>
    </span>
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

  defp render_table_column(%{type: {:assoc, collection}} = assigns) do
    assigns = assign(assigns, :assoc, collection)

    ~H"""
    <.link
      title={@value.name}
      navigate={~p"/admin/database/#{@assoc}/#{@value.id}/edit"}
      class="flex items-center gap-2 hover:underline"
    >
      <UI.Icons.page name="external-link" />
      <span>{@value.name}</span>
    </.link>
    """
  end

  defp render_table_column(assigns) do
    ~H"""
    <i>Missing column</i>
    """
  end
end
