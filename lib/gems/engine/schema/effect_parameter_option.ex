defmodule GEMS.Engine.Schema.EffectParameterOption do
  use Ecto.Schema
  import Ecto.Changeset

  @changes [
    :add,
    :remove
  ]

  @parameters [
    :strength,
    :defense,
    :speed,
    :intelligence
  ]

  @required_fields [:change, :parameter]
  @optional_fields [:turns, :chance]

  schema "effects_parameter_options" do
    field :change, Ecto.Enum, values: @changes
    field :parameter, Ecto.Enum, values: @parameters
    field :turns, :integer
    field :chance, :float
  end

  @doc false
  def changeset(parameter_option, attrs) do
    parameter_option
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:turns, greater_than_or_equal_to: 0)
    |> validate_number(:chance, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0)
  end
end
