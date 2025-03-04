defmodule GEMSWeb.CoreComponents do
  use Phoenix.Component
  use Gettext, backend: GEMSWeb.Gettext

  import GEMSWeb.FormHelpers

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

  attr :id, :any
  attr :name, :any
  attr :value, :any
  attr :label, :string, default: nil

  attr :type, :string,
    default: "text",
    values: ~w(checkbox email file number password text select hidden)

  attr :field, Phoenix.HTML.FormField
  attr :errors, :list, default: []
  attr :options, :list, default: []

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  def input(%{field: %{} = field} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_input_state(field)
    |> input()
  end

  def input(%{type: "checkbox"} = assigns) do
    ~H"""
    <fieldset class="fieldset">
      <label class="label">
        <input
          id={@id}
          name={@name}
          value={@value}
          type="checkbox"
          checked="checked"
          class={["checkbox", @errors != [] && "checkbox-error"]}
        />
        {@label}
      </label>
      <.error :for={msg <- @errors}>{msg}</.error>
    </fieldset>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <fieldset class="fieldset">
      <label class="label font-medium">{@label}</label>
      <select id={@id} name={@name} class={["select w-full", @errors != [] && "select-error"]}>
        <option value="">Select an option</option>
        {Phoenix.HTML.Form.options_for_select(@options, @value)}
      </select>
      <.error :for={msg <- @errors}>{msg}</.error>
    </fieldset>
    """
  end

  def input(%{type: "hidden"} = assigns) do
    ~H"""
    <input type="hidden" id={@id} name={@name} value={@value} />
    """
  end

  def input(assigns) do
    ~H"""
    <fieldset class="fieldset">
      <label class="label font-medium">{@label}</label>
      <input
        id={@id}
        name={@name}
        value={@value}
        type={@type}
        class={["input  w-full", @errors != [] && "input-error"]}
      />
      <.error :for={msg <- @errors}>{msg}</.error>
    </fieldset>
    """
  end

  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p :if={@inner_block} class="mt-3 flex items-center gap-2 text-sm leading-6 text-rose-600">
      <Icons.page name="circle-alert" size={16} />
      {render_slot(@inner_block)}
    </p>
    """
  end

  @doc """
  Fetch the keys from the assigns and raise on missing keys.
  """
  def fetch_assigns(socket_or_assigns, keys)

  def fetch_assigns(%Phoenix.Socket{} = socket, keys),
    do: fetch_assigns(socket.assigns, keys)

  def fetch_assigns(assigns, keys) when is_list(keys) do
    Map.new(keys, &{&1, Access.fetch!(assigns, &1)})
  end

  @doc """
  Takes the given assigns and converts them into a props attribute.
  """
  def assign_props(socket_or_assigns, fun_or_props)

  def assign_props(%Phoenix.Socket{} = socket, fun) when is_function(fun, 1),
    do: assign_props(socket, fun.(socket.assigns))

  def assign_props(assigns, fun) when is_function(fun, 1),
    do: assign_props(assigns, fun.(assigns))

  def assign_props(socket_or_assigns, props) when is_map(props),
    do: assign(socket_or_assigns, :props, Jason.encode!(props))

  def assign_props(_assigns, props), do: raise("Expected a map, got #{inspect(props)}")

  defp flash_icon(:success), do: "circle-check"
  defp flash_icon(:info), do: "info"
  defp flash_icon(:warning), do: "circle-alert"
  defp flash_icon(:error), do: "circle-x"

  defp flash_class(:success), do: "alert-success"
  defp flash_class(:info), do: "alert-info"
  defp flash_class(:warning), do: "alert-warning"
  defp flash_class(:error), do: "alert-error"
end
