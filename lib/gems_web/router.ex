defmodule GEMSWeb.Router do
  use GEMSWeb, :router

  import GEMSWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GEMSWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GEMSWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", GEMSWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:gems, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GEMSWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", GEMSWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{GEMSWeb.CheckUserHook, :redirect_if_user_is_authenticated}] do
      live "/register", UserRegistrationLive, :new
      live "/login", UserLoginLive, :new
      live "/reset-password", UserForgotPasswordLive, :new
      live "/reset-password/:token", UserResetPasswordLive, :edit
    end

    post "/login", UserSessionController, :create
  end

  scope "/", GEMSWeb do
    pipe_through [:browser, :require_authenticated_user]

    post "/character/:id/select", CharacterSelectionController, :create

    live_session :require_authenticated_user,
      on_mount: [{GEMSWeb.CheckUserHook, :ensure_authenticated}] do
      live "/settings", UserSettingsLive, :edit
      live "/settings/confirm-email/:token", UserSettingsLive, :confirm_email
      live "/accounts/characters", CharacterLive.Index
      live "/accounts/characters/new", CharacterLive.New
    end
  end

  scope "/", GEMSWeb do
    pipe_through [:browser]

    delete "/users/logout", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{GEMSWeb.CheckUserHook, :mount_current_user}] do
      live "/confirm/:token", UserConfirmationLive, :edit
      live "/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  scope "/admin", GEMSWeb.Admin do
    pipe_through [:browser, :require_authenticated_user]

    live_session :admin,
      layout: {GEMSWeb.Layouts, :admin},
      on_mount: [{GEMSWeb.CheckUserHook, :ensure_authenticated}] do
      live "/database", Database.DashboardLive
      live "/database/:collection", Database.CollectionLive.Index
      live "/database/:collection/new", Database.CollectionLive.Show, :new
      live "/database/:collection/:id/edit", Database.CollectionLive.Show, :edit
    end
  end

  scope "/game", GEMSWeb.Game do
    pipe_through [:browser, :require_authenticated_user]

    live_session :selected_character,
      layout: {GEMSWeb.Layouts, :game},
      on_mount: [
        {GEMSWeb.CheckUserHook, :ensure_authenticated},
        {GEMSWeb.CheckCharacterHook, :ensure_selected_character},
        {GEMSWeb.PageHook, :current_path}
      ] do
      live "/home", HomeLive
      live "/character", CharacterLive
      live "/storage", StorageLive
      live "/world", WorldLive
      live "/activities", ActivitiesLive
      live "/hunt", HuntLive

      live "/battles/duel/:id", BattleLive.DuelRoom
    end
  end
end
