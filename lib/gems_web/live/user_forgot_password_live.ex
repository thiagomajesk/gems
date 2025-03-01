defmodule GEMSWeb.UserForgotPasswordLive do
  use GEMSWeb, :live_view

  alias GEMS.Accounts

  def render(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center size-full">
      <div class="card w-96 bg-base-200 shadow-sm">
        <div class="card-body">
          <header class="text-center">
            <h2 class="text-2xl mb-4">Reset Password</h2>
          </header>
          <.form for={@form} id="reset_password_form" phx-submit="send_email" class="space-y-4">
            <.input
              label="Registered email"
              field={@form[:email]}
              type="email"
              placeholder="Email"
              required
            />
            <button phx-disable-with="Sending..." class="btn btn-primary w-full">
              Send reset instructions
            </button>
          </.form>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/reset-password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
