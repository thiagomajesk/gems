defmodule GemsWeb.UIKIT.Admin.DataTable do
  use GEMSWeb, :html

  attr :id, :string, required: true
  attr :rows, :list, required: true

  slot :col, required: true do
    attr :label, :string, required: true
  end

  def table_view(assigns) do
    ~H"""
    <div class="overflow-x-auto">
      <table class="table table-zebra">
        <thead>
          <tr>
            <th :for={col <- @col}>{col[:label]}</th>
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
