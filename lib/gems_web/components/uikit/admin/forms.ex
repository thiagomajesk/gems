defmodule GEMSWeb.UIKIT.Admin.Forms do
  use GEMSWeb, :html

  attr :id, :string, required: true
  attr :for, :any, required: true
  attr :return_to, :string, required: true
  slot :inner_block, required: true

  def base_form(assigns) do
    ~H"""
    <.form
      :let={f}
      id={@id}
      for={@for}
      as={:entity}
      phx-submit="save"
      phx-change="validate"
      class="space-y-8"
    >
      <div class="flex flex-col space-y-6">
        {render_slot(@inner_block, f)}
      </div>
      <div class="flex items-center justify-between">
        <.link navigate={@return_to} class="btn btn-sm btn-link">
          <UI.Icons.page name="arrow-left" class="text-[1.2em]" /> Return
        </.link>
        <button type="submit" class="btn btn-sm btn-primary">
          <UI.Icons.page name="save" class="text-[1.2em]" /> Save
        </button>
      </div>
    </.form>
    """
  end

  attr :legend, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def fieldset(assigns) do
    ~H"""
    <fieldset
      class={["fieldset text-center bg-base-content/5 rounded-box p-4 shadow", @class]}
      {@rest}
    >
      <legend :if={@legend} class="fieldset-legend uppercase font-semibold">
        {@legend}
      </legend>
      {render_slot(@inner_block)}
    </fieldset>
    """
  end

  attr :label, :string, required: true
  attr :field, Phoenix.HTML.FormField, required: true
  attr :placeholder, :string, default: nil
  attr :type, :string, required: true, values: ~w(text number textarea select percentage)
  attr :options, :list, default: nil
  attr :rest, :global, include: ~w(disabled step)

  def field_input(%{field: %{} = field} = assigns) do
    assigns
    |> assign(:field, nil)
    |> assign(:id, field.id)
    |> assign(:name, field.name)
    |> assign(:value, field.value)
    |> assign(:errors, input_errors(field))
    |> render_field_input()
  end

  def render_field_input(%{type: "textarea"} = assigns) do
    ~H"""
    <fieldset class="fieldset">
      <label class="label font-medium">{@label}</label>
      <textarea
        id={@id}
        name={@name}
        value={@value}
        placeholder={@placeholder}
        class={["textarea w-full", @errors != [] && "textarea-error"]}
        {@rest}
      ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <.error_message :for={msg <- @errors}>{msg}</.error_message>
    </fieldset>
    """
  end

  def render_field_input(%{type: "select"} = assigns) do
    ~H"""
    <fieldset class="fieldset">
      <label class="label font-medium">{@label}</label>
      <select id={@id} name={@name} class={["select w-full", @errors != [] && "select-error"]} {@rest}>
        <option value="">Select an option</option>
        {Phoenix.HTML.Form.options_for_select(@options, @value)}
      </select>
      <.error_message :for={msg <- @errors}>{msg}</.error_message>
    </fieldset>
    """
  end

  def render_field_input(%{type: "percentage"} = assigns) do
    ~H"""
    <fieldset class="fieldset">
      <label class="label font-medium">{@label}</label>
      <div class="flex items-center input w-full gap-2">
        <UI.Icons.page name="percent" />
        <input
          id={@id}
          name={@name}
          value={@value}
          type="number"
          placeholder={@placeholder}
          step="0.1"
          class={["grow", @errors != [] && "input-error"]}
          {@rest}
        />
        <.error_message :for={msg <- @errors}>{msg}</.error_message>
      </div>
    </fieldset>
    """
  end

  # HACK: Using a different function name while this issue is open:
  # https://github.com/phoenixframework/phoenix_live_view/issues/3531
  def render_field_input(assigns) do
    ~H"""
    <fieldset class="fieldset">
      <label class="label font-medium">{@label}</label>
      <input
        id={@id}
        name={@name}
        value={@value}
        type={@type}
        placeholder={@placeholder}
        class={["input w-full", @errors != [] && "input-error"]}
        {@rest}
      />
      <.error_message :for={msg <- @errors}>{msg}</.error_message>
    </fieldset>
    """
  end

  slot :inner_block, required: true

  def error_message(assigns) do
    ~H"""
    <p class="mt-2 flex items-center gap-2 text-sm leading-6 text-error">
      <UI.Icons.page name="circle-alert" />
      {render_slot(@inner_block)}
    </p>
    """
  end

  def input_assigns(%{field: field} = assigns) do
    assigns
    |> assign(:id, field.id)
    |> assign(:name, field.name)
    |> assign(:value, field.value)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
  end
end
