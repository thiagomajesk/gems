defmodule GEMSWeb.Admin.Database.ResourceLive.Forms.SharedInputs do
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
  attr :rest, :global, include: ~w(step)

  def input(assigns) do
    assigns = Forms.input_assigns(assigns)

    ~H"""
    <div id={"#{@id}-wrapper"} class="flex flex-col items-start gap-0.5 grow">
      <small :if={@label} class="text-base-content/30 text-[10px] uppercase">{@label}</small>
      <label class="flex items-center gap-1 w-full input input-sm">
        <UI.Icons.page :if={@icon} name={@icon} size={12} />
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

  attr :errors, :list, required: true

  defp error_indicator(assigns) do
    ~H"""
    <div
      :if={@errors != []}
      class="flex items-center tooltip tooltip-error"
      data-tip={Enum.join(@errors, ",")}
    >
      <UI.Icons.page name="circle-alert" class="text-error" size={16} />
    </div>
    """
  end
end
