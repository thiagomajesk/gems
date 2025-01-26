defmodule GEMSWeb.Admin.Database.CollectionLive.Forms.FileComponent do
  use GEMSWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <label class="input input-bordered flex items-center px-2">
        <UI.Media.image width="25" class="rounded" src={GEMS.public_asset_path(@value)} />
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
      </label>
      <.file_picker
        files={@files}
        open={@picker_open}
        directory={@directory}
        target={@myself}
        current={@value}
      />
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, assign(socket, picker_open: false)}
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign_required(assigns, [:id, :field, :label, :directory])
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
    send(self(), {__MODULE__, :validate, %{"icon" => path}})
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
        <header class="text-neutral flex items-center bg-base-200 rounded-btn py-2 px-4 mb-4">
          <UI.Icons.page name="folder-open" />
          <span class="ml-2 select-text">{GEMS.local_asset_path(@directory)}</span>
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
              <UI.Media.image
                width="25"
                class="rounded"
                src={GEMS.public_asset_path([@directory, file.name])}
              />
              <span
                phx-target={@target}
                phx-click="select-file"
                phx-value-path={Path.join([@directory, file.name])}
                data-selected={@current == Path.join([@directory, file.name])}
                class="hover:text-primary cursor-pointer data-[selected]:text-primary"
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

  defp assign_file_picker_state(socket) do
    directory = socket.assigns.directory

    assign_new(socket, :files, fn ->
      directory
      |> list_local_files()
      |> Enum.filter(&File.regular?(&1.path))
    end)
  end

  defp list_local_files(directory) do
    local_path = GEMS.local_asset_path(directory)
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
