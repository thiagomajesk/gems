defmodule GEMSWeb.UserRegistrationLive do
  use GEMSWeb, :live_view

  alias GEMS.Accounts
  alias GEMS.Accounts.Schema.User

  def render(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center size-full">
      <div class="card w-96 bg-base-200 shadow">
        <div class="card-body">
          <header class="text-center">
            <h2 class="text-2xl mb-4">Register for an account</h2>
          </header>
          <.form
            for={@form}
            id="registration_form"
            phx-submit="save"
            phx-change="validate"
            phx-trigger-action={@trigger_submit}
            action={~p"/login?_action=registered"}
            method="post"
            class="space-y-4"
          >
            <.input field={@form[:email]} type="email" label="Email" required />
            <.input field={@form[:password]} type="password" label="Password" required />
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

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
