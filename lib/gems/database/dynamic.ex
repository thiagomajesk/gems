defmodule GEMS.Database.Dynamic do
  use Ecto.ParameterizedType

  import GEMS.ErrorHelpers

  @impl true
  def type(_), do: :map

  @impl true
  def init(opts) do
    types = Keyword.fetch!(opts, :types)
    %{types: Enum.into(types, %{})}
  end

  @impl true
  def cast(nil, _), do: {:ok, nil}

  def cast(data, %{types: types}) do
    {module, type, data} = pop_dynamic(data, types)

    module
    |> struct!()
    |> module.changeset(data)
    |> Ecto.Changeset.apply_action(:validate)
    |> case do
      {:ok, schema} ->
        map = Map.from_struct(schema)
        {:ok, Map.put(map, :type, type)}

      {:error, changeset} ->
        {:error, message: collect_errors(changeset)}
    end
  end

  @impl true
  def load(nil, _, _), do: {:ok, nil}

  def load(data, _loader, %{types: types}) do
    {module, _type, data} = pop_dynamic(data, types)
    embed = Ecto.embedded_load(module, data, :json)
    {:ok, embed}
  end

  @impl true
  def dump(nil, _, _), do: {:ok, nil}
  def dump(map, _dumper, _) when is_map(map), do: {:ok, map}
  def dump(_, _, _), do: :error

  defp pop_dynamic(%{"type" => type} = data, types) do
    type = String.to_existing_atom(type)
    embed = Map.fetch!(types, type)
    {embed, type, Map.delete(data, "type")}
  end

  defp pop_dynamic(%{type: type} = data, types) do
    type = String.to_existing_atom(type)
    embed = Map.fetch!(types, type)
    {embed, type, Map.delete(data, "type")}
  end

  defp pop_dynamic(data, _types) do
    raise "Invalid dynamic data, missing type key on: \n #{inspect(data)}"
  end
end
