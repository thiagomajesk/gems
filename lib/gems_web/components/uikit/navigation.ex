defmodule GEMSWeb.UIKIT.Navigation do
  use GEMSWeb, :html

  attr :current_path, :atom, required: true
  attr :current_action, :atom, required: true

  slot :tabs do
    attr :action, :atom, required: true
    attr :label, :string, required: true
  end

  def tabs(assigns) do
    ~H"""
    <section>
      <header class="mb-4">
        <div role="tablist" class="tabs tabs-bordered">
          <.link
            :for={tab <- @tabs}
            patch={@current_path <> "?showing=#{tab.action}"}
            role="tab"
            class={["tab", @current_action == tab.action && "tab-active"]}
          >
            {tab.label}
          </.link>
        </div>
      </header>
      <div :for={tab <- @tabs} :if={@current_action == tab.action} class="flex flex-wrap gap-4">
        {render_slot(tab)}
      </div>
    </section>
    """
  end
end
