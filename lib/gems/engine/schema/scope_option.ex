defmodule GEMS.Engine.Schema.ScopeOption do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:target_side, :target_status, :target_number]
  @optional_fields [:random_targets]

  @target_side [
    :enemy,
    :ally,
    :any,
    :self
  ]

  @target_status [
    :any,
    :alive,
    :dead
  ]

  @target_number [
    :one,
    :all,
    :random
  ]

  schema "scope_options" do
    field :target_side, Ecto.Enum, values: @target_side
    field :target_status, Ecto.Enum, values: @target_status
    field :target_number, Ecto.Enum, values: @target_number
    field :random_targets, :integer
  end

  def changeset(scope_option, attrs) do
    scope_option
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:random_targets, greater_than_or_equal_to: 0)
  end
end
