# In the future, take a look at the following package for
# for inspiration: https://github.com/kamaroly/ecto_entity

defmodule GEMS.Database.Resource do
  alias __MODULE__

  import Ecto.Query

  defmacro __using__(_opts) do
    quote do
      @doc """
      Returns the #{__MODULE__} with the given id.
      """
      def get!(id, preloads \\ []), do: Resource.get!(__MODULE__, id, preloads)

      @doc """
      Returns a list of all #{__MODULE__}.
      """
      def list(preloads \\ []), do: Resource.list(__MODULE__, preloads)

      @doc """
      Returns a list of options for #{__MODULE__}.
      """
      def options(), do: Resource.options(__MODULE__)

      @doc """
      Creates a new #{__MODULE__}.
      """
      def create(attrs \\ %{}), do: Resource.create(__MODULE__, attrs)

      @doc """
      Updates a #{__MODULE__}.
      """
      def update(entity, attrs), do: Resource.update(__MODULE__, entity, attrs)

      @doc """
      Deletes a #{__MODULE__}.
      """
      def delete(entity), do: Resource.delete(__MODULE__, entity)

      @doc """
      Returns an `%Ecto.Changeset{}` for tracking #{__MODULE__} changes.
      """
      def change(entity \\ nil, attrs \\ %{}),
        do: Resource.change(__MODULE__, entity || struct!(__MODULE__), attrs)
    end
  end

  @doc false
  def get!(module, id, []), do: GEMS.Repo.get!(module, id)

  @doc false
  def get!(module, id, preloads) do
    query = from q in module, where: q.id == ^id
    GEMS.Repo.one!(preload(query, ^preloads))
  end

  @doc false
  def list(module, []), do: GEMS.Repo.all(module)

  @doc false
  def list(module, preloads) do
    module
    |> GEMS.Repo.all()
    |> GEMS.Repo.preload(preloads)
  end

  @doc false
  def options(module) do
    module
    |> list([])
    |> Enum.map(&{&1.name, &1.id})
  end

  @doc false
  def create(module, attrs \\ %{}) do
    module
    |> struct()
    |> module.changeset(attrs)
    |> GEMS.Repo.insert()
  end

  @doc false
  def update(module, %module{} = entity, attrs) do
    entity
    |> module.changeset(attrs)
    |> GEMS.Repo.update()
  end

  @doc false
  def delete(module, %module{} = entity) do
    GEMS.Repo.delete(entity)
  end

  @doc false
  def change(module, %module{} = entity, attrs \\ %{}) do
    module.changeset(entity, attrs)
  end
end
