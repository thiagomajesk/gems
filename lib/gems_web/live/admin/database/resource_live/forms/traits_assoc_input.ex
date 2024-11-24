defmodule GEMSWeb.Admin.Database.ResourceLive.Forms.TraitsAssocInput do
  use GEMSWeb, :html

  alias GEMSWeb.Admin.Database.ResourceLive.Forms.SharedInputs

  attr :field, Phoenix.HTML.FormField, required: true

  def inputs_for_assoc(assigns) do
    assigns = assign_options(assigns)

    ~H"""
    <div class="flex flex-col h-full min-h-64" data-auto-animate>
      <input type="hidden" name="entity[traits_drop][]" />
      <.inputs_for :let={f} field={@field}>
        <section class="rounded-btn bg-base-content/5 p-2 my-1">
          <input type="hidden" name="entity[traits_sort][]" value={f.index} />
          <header class="flex items-center justify-between mb-0.5">
            <SharedInputs.select
              :if={f[:id].value == nil}
              label="New trait"
              field={f[:kind]}
              options={@trait_options}
              phx-blur={on_select(f[:kind].id)}
            />
            <span :if={f[:id].value != nil} class="text-sm font-medium uppercase">
              {Recase.to_title(to_string(f[:kind].value))}
            </span>
            <button
              :if={f[:id].value != nil}
              type="button"
              class="btn btn-ghost btn-square btn-xs"
              name="entity[traits_drop][]"
              value={f.index}
              phx-click={JS.dispatch("change")}
            >
              <UI.Media.icon name="minus-circle" size={14} />
            </button>
          </header>
          <div>
            <.ability_seal_inputs
              :if={to_string(f[:kind].value) == "ability_seal"}
              field={f[:ability_seal]}
              options={@ability_options}
            />
            <.attack_ability_inputs
              :if={to_string(f[:kind].value) == "attack_ability"}
              field={f[:attack_ability]}
              options={@ability_options}
            />
            <.attack_element_inputs
              :if={to_string(f[:kind].value) == "attack_element"}
              field={f[:attack_element]}
              options={@element_options}
            />
            <.attack_state_inputs
              :if={to_string(f[:kind].value) == "attack_state"}
              field={f[:attack_state]}
              options={@state_options}
            />
            <.element_rate_inputs
              :if={to_string(f[:kind].value) == "element_rate"}
              field={f[:element_rate]}
              options={@element_options}
            />
            <.equipment_seal_inputs
              :if={to_string(f[:kind].value) == "equipment_seal"}
              field={f[:equipment_seal]}
              options={@equipment_options}
            />
            <.item_seal_inputs
              :if={to_string(f[:kind].value) == "item_seal"}
              field={f[:item_seal]}
              options={@item_options}
            />
            <.parameter_change_inputs
              :if={to_string(f[:kind].value) == "parameter_change"}
              field={f[:parameter_change]}
              options={@stat_options}
            />
            <.parameter_rate_inputs
              :if={to_string(f[:kind].value) == "parameter_rate"}
              field={f[:parameter_rate]}
              options={@stat_options}
            />
            <.state_rate_inputs
              :if={to_string(f[:kind].value) == "state_rate"}
              field={f[:state_rate]}
              options={@state_options}
            />
          </div>
        </section>
      </.inputs_for>
      <button
        type="button"
        name="entity[traits_sort][]"
        value="new"
        phx-click={JS.dispatch("change")}
        class="btn btn-neutral btn-sm w-full mt-auto"
      >
        <UI.Media.icon name="plus-circle" /> Add
      </button>
    </div>
    """
  end

  defp assign_options(socket) do
    socket
    |> assign_new(:trait_options, fn -> trait_options() end)
    |> assign_new(:stat_options, fn -> stat_options() end)
    |> assign_new(:ability_options, fn -> GEMS.Engine.Schema.Ability.options() end)
    |> assign_new(:state_options, fn -> GEMS.Engine.Schema.State.options() end)
    |> assign_new(:element_options, fn -> GEMS.Engine.Schema.Element.options() end)
    |> assign_new(:equipment_options, fn -> GEMS.Engine.Schema.Equipment.options() end)
    |> assign_new(:item_options, fn -> GEMS.Engine.Schema.Item.options() end)
  end

  defp trait_options() do
    GEMS.Engine.Schema.Trait
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

  defp ability_seal_inputs(assigns) do
    ~H"""
    <.inputs_for :let={f} field={@field}>
      <SharedInputs.select label="Ability" field={f[:ability_id]} options={@options} />
    </.inputs_for>
    """
  end

  attr :field, :any, required: true
  attr :options, :list, required: true

  defp attack_ability_inputs(assigns) do
    ~H"""
    <.inputs_for :let={f} field={@field}>
      <SharedInputs.select label="Ability" field={f[:ability_id]} options={@options} />
    </.inputs_for>
    """
  end

  attr :field, :any, required: true
  attr :options, :list, required: true

  defp attack_element_inputs(assigns) do
    ~H"""
    <.inputs_for :let={f} field={@field}>
      <SharedInputs.select label="Element" field={f[:element_id]} options={@options} />
    </.inputs_for>
    """
  end

  attr :field, :any, required: true
  attr :options, :list, required: true

  defp attack_state_inputs(assigns) do
    ~H"""
    <.inputs_for :let={f} field={@field}>
      <SharedInputs.select label="State" field={f[:state_id]} options={@options} />
    </.inputs_for>
    """
  end

  attr :field, :any, required: true
  attr :options, :list, required: true

  defp element_rate_inputs(assigns) do
    ~H"""
    <.inputs_for :let={f} field={@field}>
      <div class="grid grid-cols-2 gap-4">
        <SharedInputs.select label="Element" field={f[:element_id]} options={@options} />
        <SharedInputs.input label="Rate" field={f[:rate]} type="number" step="0.1" icon="percent" />
      </div>
    </.inputs_for>
    """
  end

  attr :field, :any, required: true
  attr :options, :list, required: true

  defp equipment_seal_inputs(assigns) do
    ~H"""
    <.inputs_for :let={f} field={@field}>
      <SharedInputs.select label="Equipment" field={f[:equipment_id]} options={@options} />
    </.inputs_for>
    """
  end

  attr :field, :any, required: true
  attr :options, :list, required: true

  defp item_seal_inputs(assigns) do
    ~H"""
    <.inputs_for :let={f} field={@field}>
      <SharedInputs.select label="Item" field={f[:item_id]} options={@options} />
    </.inputs_for>
    """
  end

  attr :field, :any, required: true
  attr :options, :list, required: true

  defp parameter_change_inputs(assigns) do
    ~H"""
    <.inputs_for :let={f} field={@field}>
      <div class="grid grid-cols-3 gap-4">
        <SharedInputs.select label="Parameter" field={f[:parameter]} options={@options} />
        <SharedInputs.input label="Flat" field={f[:flat]} type="number" icon="hash" />
        <SharedInputs.input label="Rate" field={f[:rate]} type="number" step="0.1" icon="percent" />
      </div>
    </.inputs_for>
    """
  end

  attr :field, :any, required: true
  attr :options, :list, required: true

  defp parameter_rate_inputs(assigns) do
    ~H"""
    <.inputs_for :let={f} field={@field}>
      <div class="grid grid-cols-3 gap-4">
        <SharedInputs.select label="Parameter" field={f[:parameter]} options={@options} />
        <SharedInputs.select label="Type" field={f[:type]} options={[Buff: :buff, Debuff: :debuff]} />
        <SharedInputs.input label="Rate" field={f[:rate]} type="number" step="0.1" icon="percent" />
      </div>
    </.inputs_for>
    """
  end

  attr :field, :any, required: true
  attr :options, :list, required: true

  defp state_rate_inputs(assigns) do
    ~H"""
    <.inputs_for :let={f} field={@field}>
      <div class="grid grid-cols-2 gap-4">
        <SharedInputs.select label="State" field={f[:state_id]} options={@options} />
        <SharedInputs.input label="Rate" field={f[:rate]} type="number" step="0.1" icon="percent" />
      </div>
    </.inputs_for>
    """
  end
end
