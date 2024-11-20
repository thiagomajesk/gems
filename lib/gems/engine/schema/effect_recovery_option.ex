defmodule GEMS.Engine.Schema.EffectRecoveryOption do
  use Ecto.Schema
  import Ecto.Changeset

  @parameters [
    :health,
    :energy
  ]

  @required_fields [:parameter]
  @optional_fields [:percentage, :maximum, :fixed, :variance]

  schema "effects_recovery_options" do
    field :parameter, Ecto.Enum, values: @parameters
    field :percentage, :float
    field :maximum, :integer
    field :fixed, :integer
    field :variance, :float
  end

  @doc false
  def changeset(recovery_option, attrs) do
    recovery_option
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:percentage, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0)
    |> validate_number(:variance, greater_than_or_equal_to: 0.0)
  end
end
