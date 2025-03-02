defmodule GEMSWeb.UIKIT.Admin.DataTable do
  use GEMSWeb, :html

  attr :id, :string, required: true
  attr :rows, :list, required: true

  slot :col, required: true do
    attr :label, :string, required: true
    attr :class, :any
  end

  def table_view(assigns) do
    ~H"""
    <div class="overflow-x-auto card bg-base-100 shadow">
      <table class="table">
        <thead>
          <tr>
            <th :for={col <- @col} class={col[:class]}>
              {col[:label]}
            </th>
          </tr>
        </thead>
        <tbody id={@id} phx-update="stream">
          <tr :for={row <- @rows} id={"resource-#{row.id}"}>
            <td :for={{col, _i} <- Enum.with_index(@col)}>
              {render_slot(col, row)}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
