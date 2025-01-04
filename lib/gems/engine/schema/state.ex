defmodule GEMS.Engine.Schema.State do
  use GEMS.Database.Schema,
    preset: :resource,
    required_fields: [:name, :code],
    optional_fields: [:description, :icon, :priority, :restriction]

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

  def build_changeset(state, attrs, opts) do
    changeset = super(state, attrs, opts)

    changeset
    |> cast_assoc(:traits, sort_param: :traits_sort, drop_param: :traits_drop)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
