defmodule GEMSWeb.UserConfirmationInstructionsLive do
  use GEMSWeb, :live_view

  alias GEMS.Accounts

  def render(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center size-full">
      <div class="card w-96 bg-base-200 shadow">
        <div class="card-body">
          <header class="text-center">
            <h2 class="text-2xl mb-4">Reset Password</h2>
          </header>
          <.form for={@form} id="resend_confirmation_form" phx-submit="send_instructions">
            <.input
              label="Registered email"
              field={@form[:email]}
              type="email"
              placeholder="Email"
              required
            />
            <button phx-disable-with="Sending..." class="btn btn-primary w-full">
              Resend confirmation instructions
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

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/confirm/#{&1}")
      )
    end

    info =
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
