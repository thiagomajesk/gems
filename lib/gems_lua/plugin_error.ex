defmodule GEMSLua.PluginError do
  defexception [:message, :original, :path]

  alias __MODULE__

  @impl true
  def exception(%Lua.RuntimeException{} = e) do
    case current_line(e.state) do
      %{file: file, line: line} ->
        %PluginError{message: e.message, original: e.original, path: "#{file}:#{line}"}

      _other ->
        %PluginError{message: e.message, original: e.original}
    end
  end

  @impl true
  def message(%PluginError{} = exception) do
    """
    #{String.trim(exception.message, "\n")}
    #{format_help_text(exception)}
    #{format_file_path(exception)}
    """
  end

  def current_line(state), do: Enum.into(collapse(state), %{})

  defp collapse({:meta, _, _, _, _}), do: []
  defp collapse({:call_frame, _, _, _, _, _, _}), do: []
  defp collapse({:current_line, line, file}), do: %{file: file, line: line}
  defp collapse(arg) when is_tuple(arg), do: collapse(Tuple.to_list(arg))
  defp collapse(arg) when is_map(arg), do: []
  defp collapse(arg) when is_reference(arg), do: []
  defp collapse(arg) when is_list(arg), do: Enum.flat_map(arg, &collapse/1)
  defp collapse(_arg), do: []

  defp format_file_path(%{path: nil}), do: nil
  defp format_file_path(%{path: path}), do: "File: #{path}"

  defp format_help_text(%{original: {:illegal_index, container, field}}) do
    "You are trying to access #{inspect(field)} inside #{inspect(container)} but it does not exist."
  end

  defp format_help_text(_other), do: nil
end
