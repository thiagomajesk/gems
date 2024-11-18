defmodule GEMS.Engine.Schema.EffectRecoveryOption do
  use Ecto.Schema
  import Ecto.Changeset

  @parameters [
    :health,
    :energy
  ]

  schema "effects_recovery_options" do
    field :parameter, Ecto.Enum, values: @parameters
    field :percentage, :float, default: 0.0
    field :maximum, :integer
    field :fixed, :integer
    field :variance, :float, default: 0.0
  end

  @doc false
  def changeset(recovery_option, attrs) do
    recovery_option
    |> cast(attrs, [:parameter, :percentage, :maximum, :fixed, :variance])
    |> validate_required([:parameter])
    |> validate_number(:percentage, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0)
    |> validate_number(:variance, greater_than_or_equal_to: 0.0)
  end
end
