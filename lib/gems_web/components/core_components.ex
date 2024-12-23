defmodule GEMSWeb.CoreComponents do
  use Phoenix.Component
  use Gettext, backend: GEMSWeb.Gettext

  import GEMSWeb.ErrorHelpers

  alias GEMSWeb.UIKIT.Icons

  attr :id, :string, default: nil
  attr :flash, :map, default: %{}
  attr :title, :string, default: nil
  attr :message, :string, default: nil
  attr :kind, :atom, values: [:success, :info, :warning, :error]
  attr :icon, :string, default: nil
  attr :autoclear, :boolean, default: false
  attr :rest, :global

  def flash(assigns) do
    ~H"""
    <div
      :if={content = @message || Phoenix.Flash.get(@flash, @kind)}
      id={@id || "flash-#{@kind}"}
      class={["alert shadow-lg select-none", flash_class(@kind)]}
      phx-hook={@autoclear && "ClearFlash"}
      role="alert"
      {@rest}
    >
      <div class="flex gap-2">
        <Icons.page name={@icon || flash_icon(@kind)} />
        <div class="flex flex-col">
          <strong class="text-sm">{@title}</strong>
          <p class="text-xs">{content}</p>
        </div>
      </div>
    </div>
    """
  end

  attr :flash, :map, required: true

  def flash_group(assigns) do
    ~H"""
    <div class="toast toast-top toast-end z-50">
      <.flash kind={:info} title={gettext("Info!")} flash={@flash} autoclear />
      <.flash kind={:error} title={gettext("Error!")} flash={@flash} autoclear />
      <.flash kind={:success} title={gettext("Success!")} flash={@flash} autoclear />
      <.flash kind={:warning} title={gettext("Warning!")} flash={@flash} autoclear />
    </div>
    """
  end

  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, required: true
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox email file number password text select)

  attr :field, Phoenix.HTML.FormField
  attr :errors, :list, default: []
  attr :options, :list, default: []

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  def input(%{field: %{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox"} = assigns) do
    ~H"""
    <div class="form-control">
      <label class="label cursor-pointer">
        <span class="label-text">{@label}</span>
        <input
          id={@id}
          name={@name}
          value={@value}
          type="checkbox"
          checked="checked"
          class={["checkbox", @errors != [] && "checkbox-error"]}
        />
      </label>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <label class="form-control w-full">
      <div class="label font-medium">
        <span class="label-text">
          {@label}
        </span>
      </div>
      <select
        id={@id}
        name={@name}
        class={["select select-bordered", @errors != [] && "select-error"]}
      >
        <option value="">Select an option</option>
        {Phoenix.HTML.Form.options_for_select(@options, @value)}
      </select>
      <.error :for={msg <- @errors}>{msg}</.error>
    </label>
    """
  end

  def input(assigns) do
    ~H"""
    <label class="form-control w-full">
      <div class="label font-medium">
        <span class="label-text">
          {@label}
        </span>
      </div>
      <input
        id={@id}
        name={@name}
        value={@value}
        type={@type}
        class={["input input-bordered w-full", @errors != [] && "input-error"]}
      />
      <.error :for={msg <- @errors}>{msg}</.error>
    </label>
    """
  end

  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="mt-3 flex gap-3 text-sm leading-6 text-rose-600">
      <Icons.page name="circle-alert" class="mt-0.5 h-5 w-5 flex-none" />
      {render_slot(@inner_block)}
    </p>
    """
  end

  defp flash_icon(:success), do: "circle-check"
  defp flash_icon(:info), do: "info"
  defp flash_icon(:warning), do: "circle-alert"
  defp flash_icon(:error), do: "circle-x"

  defp flash_class(:success), do: "alert-success"
  defp flash_class(:info), do: "alert-info"
  defp flash_class(:warning), do: "alert-warning"
  defp flash_class(:error), do: "alert-error"
end
