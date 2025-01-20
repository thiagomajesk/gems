defmodule GEMS.Database.Collection do
  @callback changeset(entity :: struct, attrs :: map) :: Ecto.Changeset.t()

  @callback seed_changeset(entity :: struct, attrs :: map) :: Ecto.Changeset.t()

  @callback build_changeset(entity :: struct, attrs :: map, opts :: keyword) ::
              Ecto.Changeset.t()

  defmacro __using__(opts) do
    required_fields = Keyword.fetch!(opts, :required_fields)
    optional_fields = Keyword.fetch!(opts, :optional_fields)
    default_preloads = Keyword.fetch!(opts, :default_preloads)

    quote location: :keep do
      @behaviour GEMS.Database.Collection

      @required_fields unquote(required_fields)
      @optional_fields unquote(optional_fields)
      @default_preloads unquote(default_preloads)

      def __collection__(:required_fields), do: @required_fields
      def __collection__(:optional_fields), do: @optional_fields
      def __collection__(:default_preloads), do: @default_preloads

      @doc """
      Returns the #{__MODULE__} with the given id.
      """
      def get!(id, preloads \\ nil) do
        __MODULE__
        |> GEMS.Repo.get!(id)
        |> __MODULE__.preload(preloads)
      end

      @doc """
      Returns a list of all #{__MODULE__}.
      """
      def list(preloads \\ nil) do
        __MODULE__
        |> GEMS.Repo.all()
        |> __MODULE__.preload(preloads)
      end

      @doc """
      Returns a list of options for #{__MODULE__}.
      """
      def options() do
        __MODULE__
        |> GEMS.Repo.all()
        |> Enum.map(&{&1.name, &1.id})
      end

      def change(entity \\ nil, attrs \\ %{}) do
        changeset(entity || struct(__MODULE__), attrs)
      end

      @doc """
      Creates a new #{__MODULE__}.
      """
      def create(attrs \\ %{}) do
        __MODULE__
        |> struct()
        |> changeset(attrs)
        |> GEMS.Repo.insert()
      end

      @doc """
      Updates a #{__MODULE__}.
      """
      def update(entity, attrs) do
        entity
        |> changeset(attrs)
        |> GEMS.Repo.update()
      end

      @doc """
      Deletes a #{__MODULE__}.
      """
      def delete(entity) do
        GEMS.Repo.delete(entity)
      end

      @doc false
      def preload(entity_or_entities, preloads \\ nil)

      def preload(entity_or_entities, nil),
        do: GEMS.Repo.preload(entity_or_entities, @default_preloads)

      def preload(entity_or_entities, preloads) when is_list(preloads),
        do: GEMS.Repo.preload(entity_or_entities, preloads)

      @doc false
      def changeset(entity, attrs) do
        build_changeset(entity, attrs,
          required_fields: @required_fields,
          optional_fields: @optional_fields
        )
      end

      @doc false
      def seed_changeset(entity, attrs) do
        build_changeset(
          entity,
          attrs,
          required_fields: [:id | @required_fields],
          optional_fields: @optional_fields
        )
      end

      @doc false
      def build_changeset(entity, attrs, opts) do
        required_fields = Keyword.fetch!(opts, :required_fields)
        optional_fields = Keyword.get(opts, :optional_fields, [])

        entity
        |> cast(attrs, required_fields ++ optional_fields)
        |> validate_required(required_fields)
      end

      defoverridable changeset: 2, seed_changeset: 2, build_changeset: 3
    end
  end
end
