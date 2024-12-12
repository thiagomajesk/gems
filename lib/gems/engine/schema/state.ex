defmodule GEMS.Engine.Schema.State do
  use GEMS.Database.Schema, :resource

  @required_fields [:name, :code]

  @optional_fields [:description, :icon, :priority, :restriction]

  @restrictions [
    :attack_enemy,
    :attack_ally,
    :attack_anyone,
    :cannot_attack
  ]

  schema "states" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string
    field :priority, :integer
    field :restriction, Ecto.Enum, values: @restrictions
    has_many :traits, GEMS.Engine.Schema.Trait, on_replace: :delete
  end

  def changeset(state, attrs) do
    state
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end

  def seed_changeset(state, attrs) do
    build_changeset(
      state,
      attrs,
      required_fields: [:id | @required_fields],
      optional_fields: @optional_fields
    )
  end

  defp build_changeset(state, attrs, opts) do
    required_fields = Keyword.fetch!(opts, :required_fields)
    optional_fields = Keyword.get(opts, :optional_fields, [])

    state
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
  end
end
