defmodule GEMSWeb.Admin.Database.ResourceLive.Forms.EffectsAssocInput do
  use GEMSWeb, :html

  alias GEMSWeb.Admin.Database.ResourceLive.Forms.SharedInputs

  attr :field, Phoenix.HTML.FormField, required: true

  def inputs_for_assoc(assigns) do
    assigns = assign_options(assigns)

    ~H"""
    <div class="flex flex-col h-full min-h-64" data-auto-animate>
      <input type="hidden" name="entity[effects_drop][]" />
      <.inputs_for :let={f} field={@field}>
        <section class="rounded-btn bg-base-content/5 p-2 my-1">
          <input type="hidden" name="entity[effects_sort][]" value={f.index} />
          <header class="flex items-center justify-between mb-0.5">
            <SharedInputs.select
              :if={f[:id].value == nil}
              label="New effect"
              field={f[:kind]}
              options={@effect_options}
              phx-blur={on_select(f[:kind].id)}
            />
            <span :if={f[:id].value != nil} class="text-sm font-medium uppercase">
              {Recase.to_title(to_string(f[:kind].value))}
            </span>
            <button
              :if={f[:id].value != nil}
              type="button"
              class="btn btn-ghost btn-square btn-xs"
              name="entity[effects_drop][]"
              value={f.index}
              phx-click={JS.dispatch("change")}
            >
              <UI.Icons.page name="minus-circle" size={14} />
            </button>
          </header>
          <div>
            <.recovery_inputs
              :if={to_string(f[:kind].value) == "recovery"}
              field={f[:recovery]}
              options={[Health: :health, Energy: :energy]}
            />
            <.state_change_inputs
              :if={to_string(f[:kind].value) == "state_change"}
              field={f[:state_change]}
              options={@state_options}
            />
            <.parameter_change_inputs
              :if={to_string(f[:kind].value) == "parameter_change"}
              field={f[:parameter_change]}
              options={@stat_options}
            />
          </div>
        </section>
      </.inputs_for>
      <button
        type="button"
        name="entity[effects_sort][]"
        value="new"
        phx-click={JS.dispatch("change")}
        class="btn btn-neutral btn-sm w-full mt-auto"
      >
        <UI.Icons.page name="plus-circle" /> Add
      </button>
    </div>
    """
  end

  defp assign_options(socket) do
    socket
    |> assign_new(:effect_options, fn -> effect_options() end)
    |> assign_new(:stat_options, fn -> stat_options() end)
    |> assign_new(:state_options, fn -> GEMS.Engine.Schema.State.options() end)
  end

  defp effect_options() do
    GEMS.Engine.Schema.Effect
    |> Ecto.Enum.mappings(:kind)
    |> Enum.map(fn {k, v} -> {Recase.to_title(v), k} end)
  end

  defp stat_options() do
    Enum.map(GEMS.Engine.Constants.stats(), fn v ->
      {Recase.to_title(to_string(v)), to_string(v)}
    end)
  end

  defp on_select(id) do
    %JS{}
    |> JS.dispatch("change")
    |> JS.hide(to: "##{id}-wrapper")
  end

  attr :field, :any, required: true
  attr :options, :list, required: true

  defp recovery_inputs(assigns) do
    ~H"""
    <.inputs_for :let={f} field={@field}>
      <div class="flex flex-col gap-1">
        <div class="grid grid-cols-2 gap-4">
          <SharedInputs.select label="Parameter" field={f[:parameter]} options={@options} />
          <SharedInputs.input label="Maximum" field={f[:maximum]} type="number" icon="hash" />
        </div>
        <div class="grid grid-cols-3 gap-4">
          <SharedInputs.input label="Flat" field={f[:flat]} type="number" icon="hash" />
          <SharedInputs.input label="Rate" field={f[:rate]} type="number" step="0.1" icon="percent" />
          <SharedInputs.input
            label="Variance"
            field={f[:variance]}
            type="number"
            step="0.1"
            icon="percent"
          />
        </div>
      </div>
    </.inputs_for>
    """
  end

  attr :field, :any, required: true
  attr :options, :list, required: true

  defp state_change_inputs(assigns) do
    ~H"""
    <.inputs_for :let={f} field={@field}>
      <div class="grid grid-cols-3 gap-4">
        <SharedInputs.select label="Action" field={f[:action]} options={[Add: :add, Remove: :remove]} />
        <SharedInputs.select label="State" field={f[:state_id]} options={@options} />
        <SharedInputs.input label="Chance" field={f[:chance]} type="number" icon="percent" />
      </div>
    </.inputs_for>
    """
  end

  attr :field, :any, required: true
  attr :options, :list, required: true

  defp parameter_change_inputs(assigns) do
    ~H"""
    <.inputs_for :let={f} field={@field}>
      <div class="flex flex-col gap-1">
        <div class="grid grid-cols-2 gap-4">
          <SharedInputs.select label="Parameter" field={f[:parameter]} options={@options} />
          <SharedInputs.select label="Type" field={f[:type]} options={[Buff: :buff, Debuff: :debuff]} />
        </div>
        <div class="grid grid-cols-2 gap-4">
          <SharedInputs.select
            label="Action"
            field={f[:action]}
            options={[Add: :add, Remove: :remove]}
          />
          <SharedInputs.input
            label="Variance"
            field={f[:variance]}
            type="number"
            step="0.1"
            icon="percent"
          />
        </div>
      </div>
    </.inputs_for>
    """
  end
end
