defmodule GEMSWeb.UserResetPasswordLive do
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
          <.form
            for={@form}
            id="reset_password_form"
            phx-submit="reset_password"
            phx-change="validate"
            class="space-y-4"
          >
            <.input field={@form[:password]} type="password" label="New password" required />
            <.input
              field={@form[:password_confirmation]}
              type="password"
              label="Confirm new password"
              required
            />
            <button phx-disable-with="Creating account..." class="btn btn-primary w-full">
              Create account
            </button>

            <div class="text-center">
              <p class="text-sm">
                Already registered?
                <.link navigate={~p"/login"} class="link link-primary font-semibold">
                  Log in
                </.link>
              </p>
            </div>
          </.form>
        </div>
      </div>
    </div>
    """
  end

  def mount(params, _session, socket) do
    socket = assign_user_and_token(socket, params)

    form_source =
      case socket.assigns do
        %{user: user} ->
          Accounts.change_user_password(user)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset successfully.")
         |> redirect(to: ~p"/login")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_password(socket.assigns.user, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_user_and_token(socket, %{"token" => token}) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token)
    else
      socket
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
    end
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "user"))
  end
end
