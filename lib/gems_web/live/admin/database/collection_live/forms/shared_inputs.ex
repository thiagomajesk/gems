defmodule GEMSWeb.Admin.Database.CollectionLive.Forms.SharedInputs do
  use GEMSWeb, :html

  alias GEMSWeb.UIKIT.Admin.Forms

  attr :label, :string, default: nil
  attr :options, :list, required: true
  attr :field, :any, required: true
  attr :rest, :global

  def select(assigns) do
    assigns = Forms.input_assigns(assigns)

    ~H"""
    <div id={"#{@id}-wrapper"} class="flex flex-col items-start gap-0.5 grow">
      <small :if={@label} class="text-base-content/30 text-[10px] uppercase">{@label}</small>
      <label class="flex gap-1 w-full">
        <select
          id={@id}
          name={@name}
          class={["select select-sm grow", @errors != [] && "select-error"]}
          {@rest}
        >
          <option disabled selected value="">Select an option</option>
          {Phoenix.HTML.Form.options_for_select(@options, @value)}
        </select>
        <.error_indicator errors={@errors} />
      </label>
    </div>
    """
  end

  attr :label, :string, default: nil
  attr :icon, :string, default: nil
  attr :type, :string, required: true
  attr :field, :any, required: true
  attr :rest, :global, include: ~w(step min max)

  def input(assigns) do
    assigns = Forms.input_assigns(assigns)

    ~H"""
    <div id={"#{@id}-wrapper"} class="flex flex-col items-start gap-0.5 grow">
      <small :if={@label} class="text-base-content/30 text-[10px] uppercase">{@label}</small>
      <label class="flex items-center gap-1 w-full input input-sm">
        <UI.Icons.page :if={@icon} name={@icon} />
        <input
          type={@type}
          name={@name}
          value={@value}
          class={["w-full", @errors != [] && "input-error"]}
          {@rest}
        />
        <.error_indicator errors={@errors} />
      </label>
    </div>
    """
  end

  attr :field, :any, required: true
  attr :rest, :global

  def colorpicker(assigns) do
    assigns = Forms.input_assigns(assigns)

    ~H"""
    <label class="bg-base-content/10 p-2 rounded-box relative cursor-pointer group">
      <span
        class="block w-4 h-4 rounded-full border border-base-content/50 transition-transform duration-500 group-hover:scale-125"
        style={"background-color: #{@value}"}
      >
      </span>
      <input
        type="color"
        id={@id}
        name={@name}
        value={@value}
        class="absolute top-8 size-0 opacity-0"
        {@rest}
      />
    </label>
    """
  end

  attr :type, :string, required: true
  attr :field, :any, required: true
  attr :rest, :global, include: ~w(readonly)

  def unstyled(assigns) do
    assigns = Forms.input_assigns(assigns)

    ~H"""
    <input type={@type} id={@id} name={@name} value={@value} {@rest} />
    """
  end

  attr :form, :any, required: true

  def stats_fieldset(assigns) do
    ~H"""
    <Forms.fieldset legend="Stats">
      <div class="grid grid-cols-2 md:grid-cols-3 gap-6">
        <Forms.field_input type="number" field={@form[:damage]} label="Damage" />
        <Forms.field_input type="number" field={@form[:maximum_health]} label="Max Health" />
        <Forms.field_input
          type="number"
          step="0.01"
          field={@form[:health_regeneration]}
          label="Health Regen"
        />

        <Forms.field_input
          type="number"
          field={@form[:maximum_physical_armor]}
          label="Physical Armor"
        />
        <Forms.field_input type="number" field={@form[:maximum_magical_armor]} label="Magical Armor" />
        <Forms.field_input type="number" field={@form[:attack_speed]} label="Attack Speed" />
        <Forms.field_input type="number" step="0.01" field={@form[:accuracy]} label="Accuracy" />
        <Forms.field_input type="number" step="0.01" field={@form[:evasion]} label="Evasion" />
        <Forms.field_input
          type="number"
          step="0.01"
          field={@form[:critical_chance]}
          label="Critical Chance"
        />
        <Forms.field_input
          type="number"
          step="0.01"
          field={@form[:critical_multiplier]}
          label="Critical Multiplier"
        />
        <Forms.field_input type="number" step="0.01" field={@form[:recovery]} label="Recovery" />
        <Forms.field_input type="number" step="0.01" field={@form[:fortitude]} label="Fortitude" />
        <Forms.field_input
          type="number"
          field={@form[:damage_penetration]}
          label="Damage Penetration"
        />
        <Forms.field_input type="number" field={@form[:damage_reflection]} label="Damage Reflection" />
        <Forms.field_input
          type="number"
          step="0.01"
          field={@form[:fire_resistance]}
          label="Fire Resistance"
        />
        <Forms.field_input
          type="number"
          step="0.01"
          field={@form[:water_resistance]}
          label="Water Resistance"
        />
        <Forms.field_input
          type="number"
          step="0.01"
          field={@form[:earth_resistance]}
          label="Earth Resistance"
        />
        <Forms.field_input
          type="number"
          step="0.01"
          field={@form[:air_resistance]}
          label="Air Resistance"
        />
      </div>
    </Forms.fieldset>
    """
  end

  attr :errors, :list, required: true

  defp error_indicator(assigns) do
    ~H"""
    <div
      :if={@errors != []}
      class="flex items-center tooltip tooltip-error"
      data-tip={Enum.join(@errors, ",")}
    >
      <UI.Icons.page name="circle-alert" class="text-error" />
    </div>
    """
  end
end
