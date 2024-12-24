defmodule GEMSData.DataFile do
  alias __MODULE__

  defstruct [:scope, :path, :entries, :opts]

  def new({scope, path, opts}) do
    contents = File.read!(path)
    decoded = Jason.decode!(contents)
    entries = Enum.map(decoded, &hash_entry/1)

    %DataFile{
      scope: scope,
      path: path,
      entries: entries,
      opts: opts
    }
  end

  defp hash_entry(entry) do
    entry
    |> :erlang.term_to_binary()
    |> then(&:crypto.hash(:md5, &1))
    |> Base.encode16(case: :lower)
    |> then(&Map.put(entry, "__hash__", &1))
  end
end
