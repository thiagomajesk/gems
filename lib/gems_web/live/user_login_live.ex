defmodule GEMSWeb.UserLoginLive do
  use GEMSWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center h-full">
      <div class="card w-96 bg-base-200 shadow">
        <div class="card-body">
          <header class="text-center">
            <h2 class="text-2xl mb-4">Log in to account</h2>
          </header>
          <.form for={@form} id="login_form" action={~p"/login"} phx-update="ignore" class="space-y-4">
            <.input field={@form[:email]} type="email" label="Email" required />
            <.input field={@form[:password]} type="password" label="Password" required />
            <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
            <button phx-disable-with="Logging in..." class="btn btn-primary w-full">Log in</button>

            <div class="text-center">
              <.link href={~p"/reset-password"} class="text-sm link link-hover">
                Forgot your password?
              </.link>

              <p class="text-sm">
                Don't have an account yet?
                <.link navigate={~p"/register"} class="link link-primary font-semibold">
                  Sign up
                </.link>
              </p>
            </div>
          </.form>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
