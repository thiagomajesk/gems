defmodule GEMSWeb.Admin.Database.CollectionLive.Forms.FileExplorerComponent do
  use GEMSWeb, :live_component

  @impl true
  def render(%{mounted: false} = assigns) do
    ~H"""
    <div class="alert alert-warning">
      <UI.Icons.page name="alert-triangle" size={18} />
      <div class="flex flex-col">
        <strong>Invalid path! Failed to mount the file explorer</strong>
        <p>
          Check if the path exists and that you have the correct permissions to access it: {@local_path}
        </p>
      </div>
    </div>
    """
  end

  @impl true
  def render(%{mounted: true} = assigns) do
    ~H"""
    <fieldset class="fieldset">
      <label class="label">{@label}</label>
      <div class="input w-full flex items-center px-2">
        <.miniature_preview src={GEMS.public_asset_path(@value)} />
        <input
          type="text"
          id={@id}
          name={@name}
          value={@value}
          class="ml-2 text-neutral grow"
          readonly
        />
        <button
          type="button"
          class="btn btn-sm ml-auto"
          phx-target={@myself}
          phx-click="toggle-file-picker"
        >
          <UI.Icons.page name="file-stack" /> Select
        </button>
      </div>
      <.file_picker
        files={@files}
        open={@picker_open}
        directory={@directory}
        target={@myself}
        current={@value}
      />
    </fieldset>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, assign(socket, picker_open: false)}
  end

  @impl true
  def update(assigns, socket) do
    assigns =
      fetch_assigns(assigns, [
        :id,
        :field,
        :label,
        :directory,
        :extensions
      ])

    {:ok,
     socket
     |> assign(assigns)
     |> assign_input_state(assigns.field, force: true)
     |> assign_file_picker_state()}
  end

  @impl true
  def handle_event("toggle-file-picker", _params, socket) do
    open = socket.assigns.picker_open
    {:noreply, assign(socket, picker_open: !open)}
  end

  @impl true
  def handle_event("select-file", %{"path" => path}, socket) do
    send(self(), {__MODULE__, :validate, %{"image" => path}})
    {:noreply, assign(socket, picker_open: false)}
  end

  attr :files, :list, required: true
  attr :directory, :string, required: true
  attr :open, :boolean, required: true
  attr :target, :any, required: true
  attr :current, :string, required: true

  defp file_picker(assigns) do
    ~H"""
    <div class="modal" role="dialog" open={@open}>
      <div class="modal-box max-w-none">
        <header class="text-neutral flex items-center bg-base-200 rounded-box py-2 px-4 mb-4">
          <UI.Icons.page name="folder-open" />
          <span class="ml-2 select-text">{GEMS.local_asset_path!(@directory)}</span>
          <button
            type="button"
            class="btn btn-sm text-sm ml-auto"
            phx-target={@target}
            phx-click="toggle-file-picker"
          >
            <UI.Icons.page name="x" />
          </button>
        </header>
        <ul class="flex flex-col flex-wrap gap-2">
          <li :for={file <- @files} class="flex items-center justify-between">
            <div class="flex items-center gap-2 w-2/3 ">
              <.miniature_preview src={GEMS.public_asset_path([@directory, file.name])} />
              <span
                phx-target={@target}
                phx-click="select-file"
                phx-value-path={Path.join([@directory, file.name])}
                data-selected={@current == Path.join([@directory, file.name])}
                class="hover:text-primary cursor-pointer data-selected:text-primary"
              >
                {file.name}
              </span>
            </div>
            <div class="flex items-center justify-evenly w-1/3">
              <span class="badge badge-ghost">{display_time(file.stat)}</span>
              <span class="badge badge-ghost">{display_size(file.stat)}</span>
              <span class="badge badge-ghost">{display_access(file.stat)}</span>
            </div>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  attr :src, :string, required: true

  defp miniature_preview(assigns) do
    assigns = assign_new(assigns, :mime, &MIME.from_path(to_string(&1.src)))

    ~H"""
    <%= case @mime do %>
      <% "application/octet-stream" -> %>
        <UI.Icons.page name="file-question" size="25" class="text-neutral" />
      <% _ -> %>
        <UI.Media.image class="rounded-sm size-[25px]" src={@src} />
    <% end %>
    """
  end

  defp assign_file_picker_state(socket) do
    directory = socket.assigns.directory
    extensions = socket.assigns.extensions

    case GEMS.local_asset_path(directory) do
      {:ok, local_path} ->
        socket
        |> assign(:mounted, true)
        |> assign(:local_path, local_path)
        |> assign_new(:files, fn ->
          local_path
          |> list_local_files()
          |> filter_valid_files(extensions)
        end)

      {:error, local_path} ->
        socket
        |> assign(:files, [])
        |> assign(:local_path, local_path)
        |> assign(:mounted, false)
    end
  end

  defp list_local_files(local_path) do
    local_files = File.ls!(local_path)

    Enum.map(local_files, fn file_name ->
      file_path = Path.join([local_path, file_name])

      %{
        path: file_path,
        name: Path.basename(file_name),
        stat: File.stat!(file_path, time: :posix)
      }
    end)
  end

  defp filter_valid_files(files, extensions) do
    files
    |> Enum.filter(&File.regular?(&1.path))
    |> Enum.filter(fn %{path: path} ->
      path
      |> Path.extname()
      |> String.trim_leading(".")
      |> then(&Kernel.in(&1, extensions))
    end)
  end

  defp display_access(%{access: access}) do
    access
    |> Atom.to_string()
    |> String.replace("_", " / ")
  end

  defp display_time(%{mtime: posix_time}) do
    posix_time
    |> Timex.from_unix()
    |> Timex.from_now()
  end

  defp display_size(%{size: size}) do
    Sizeable.filesize(size)
  end
end
