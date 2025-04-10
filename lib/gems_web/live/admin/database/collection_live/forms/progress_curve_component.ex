defmodule GEMSWeb.Admin.Database.CollectionLive.Forms.ProgressCurveComponent do
  use GEMSWeb, :live_component

  alias GEMSWeb.Admin.Database.CollectionLive.Forms.SharedInputs

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col" data-auto-animate>
      <.inputs_for :let={f} field={@field}>
        <section class="rounded-box bg-base-content/5 shadow p-2 my-1">
          <header class="flex items-center justify-between mb-0.5">
            <span class="text-xs font-medium uppercase">{@label}</span>
            <button
              type="button"
              class="btn btn-sm btn-square ml-auto self-end"
              phx-target={@myself}
              phx-click="toggle-preview"
            >
              <UI.Icons.page name="eye" class="text-[1.2em]" />
            </button>
          </header>
          <div class="grid grid-cols-5 gap-2">
            <SharedInputs.input type="number" min="0" label="Base Value" field={f[:value]} />
            <SharedInputs.input type="number" min="0" label="Max Value" field={f[:max_value]} />
            <SharedInputs.input
              type="number"
              min="0"
              max="100"
              label="Extra Value"
              field={f[:extra_value]}
            />
            <SharedInputs.input
              type="number"
              min="0"
              max="100"
              label="Acceleration"
              field={f[:acceleration]}
            />
            <SharedInputs.input
              type="number"
              min="0"
              max="100"
              label="Inflation"
              field={f[:inflation]}
            />
          </div>
        </section>
        <.curve_preview :if={@preview_open} curve={normalize_value(@value)} target={@myself} />
      </.inputs_for>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:search, "")
     |> assign(preview_open: false)}
  end

  @impl true
  def update(assigns, socket) do
    assigns = fetch_assigns(assigns, [:id, :field, :label])

    {:ok,
     socket
     |> assign(assigns)
     |> assign_input_state(assigns.field, force: true)}
  end

  @impl true
  def handle_event("toggle-preview", _params, socket) do
    open = socket.assigns.preview_open
    {:noreply, assign(socket, preview_open: !open)}
  end

  attr :curve, :map, required: true
  attr :target, :any, required: true

  defp curve_preview(assigns) do
    assigns =
      assign_new(assigns, :svg, fn %{curve: curve} ->
        curve
        |> GEMS.Progression.curve_table()
        |> generate_sparkline()
      end)

    ~H"{raw(@svg)}"
  end

  defp normalize_value(%Ecto.Changeset{} = changeset),
    do: Ecto.Changeset.apply_changes(changeset)

  defp normalize_value(%GEMS.Database.ProgressCurve{} = curve), do: curve

  defp generate_sparkline(table) do
    table
    |> Enum.map(fn %{level: y, value: x} -> {y, x} end)
    |> SparklineSvg.new(width: 200, height: 30, smoothing: 0)
    |> SparklineSvg.show_line(color: "rgba(40, 255, 118, 0.8)", width: 0.4)
    |> SparklineSvg.show_area(color: "rgba(40, 255, 118, 0.2)")
    |> SparklineSvg.show_ref_line(:avg, width: 0.2, color: "yellow")
    |> SparklineSvg.to_svg!()
  end
end
