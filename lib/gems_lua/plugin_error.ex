defmodule GEMSLua.PluginError do
  defexception [:message, :original, :file, :line]

  alias __MODULE__

  @impl true
  def exception(%Lua.RuntimeException{} = e) do
    %{file: file, line: line} = current_line(e.state)
    %PluginError{message: e.message, original: e.original, file: file, line: line}
  end

  @impl true
  def message(%PluginError{} = exception) do
    """
    #{String.trim(exception.message, "\n")}
    #{format_exception_help(exception)}
    File: #{exception.file}:#{exception.line}
    """
  end

  def current_line(state), do: Enum.into(collapse(state), %{})

  defp collapse({:meta, _, _, _, _}), do: dbg() && []
  defp collapse({:call_frame, _, _, _, _, _, _}), do: []
  defp collapse({:current_line, line, file}), do: %{file: file, line: line}
  defp collapse(arg) when is_tuple(arg), do: collapse(Tuple.to_list(arg))
  defp collapse(arg) when is_map(arg), do: []
  defp collapse(arg) when is_reference(arg), do: []
  defp collapse(arg) when is_list(arg), do: Enum.flat_map(arg, &collapse/1)
  defp collapse(_arg), do: []

  defp format_exception_help(%{original: {:illegal_index, container, field}}) do
    "You are trying to access #{inspect(field)} inside #{inspect(container)} but it does not exist."
  end

  defp format_exception_help(_other), do: nil
end
