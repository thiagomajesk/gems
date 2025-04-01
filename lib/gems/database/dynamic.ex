defmodule GEMS.Database.Dynamic do
  @moduledoc """
  A dynamic Ecto type that allows handling differently-shaped maps using structured data.
  This module relies on embedded schemas to cast and validate data based on the provided types.
  """
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

  def cast(data, %{types: types}) when is_struct(data) do
    Enum.find_value(types, fn {_type, module} ->
      if module == data.__struct__,
        do: {:ok, to_embed(module, Map.from_struct(data))},
        else: {:error, message: "Invalid type: #{inspect(data)}"}
    end)
  end

  def cast(data, %{types: types}) when is_map(data) do
    case Map.new(data, &cast_key/1) do
      %{"type" => type} -> cast_embed(data, type, types)
      other -> {:error, message: "Missing type on: \n #{inspect(other)}"}
    end
  end

  @impl true
  def load(nil, _, _), do: {:ok, nil}

  def load(data, _loader, %{types: types}) when is_map(data) do
    case Map.new(data, &cast_key/1) do
      %{"type" => type} -> load_embed(types, type, data)
      other -> {:error, message: "Missing type on: \n #{inspect(other)}"}
    end
  end

  def load(_, _, _), do: :error

  @impl true
  def dump(nil, _, _), do: {:ok, nil}

  def dump(data, dumper, opts) when is_struct(data),
    do: dump(Map.from_struct(data), dumper, opts)

  def dump(data, _dumper, _) when is_map(data), do: raise("Not implemented")

  def dump(_, _, _), do: :error

  defp cast_key({key, value}) when is_atom(key), do: {Atom.to_string(key), value}
  defp cast_key({key, value}) when is_binary(key), do: {key, value}

  defp cast_embed(data, type, types) do
    case Map.fetch(types, String.to_existing_atom(type)) do
      {:ok, module} -> to_embed(module, data)
      :error -> {:error, message: "Unknown type: #{type}"}
    end
  end

  defp to_embed(module, data) do
    changeset = module.changeset(struct!(module), data)

    case Ecto.Changeset.apply_action(changeset, :validate) do
      {:ok, embed} -> {:ok, embed}
      {:error, changeset} -> {:error, message: collect_errors(changeset)}
    end
  end

  defp load_embed(types, type, data) do
    case Map.fetch(types, String.to_existing_atom(type)) do
      {:ok, module} -> {:ok, Ecto.embedded_load(module, data, :json)}
      :error -> {:error, message: "Unknown type: #{type}"}
    end
  end
end
