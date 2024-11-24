defmodule GEMS.Engine.Schema.EffectRecovery do
  use GEMS.Database.Schema, :default

  @parameters [
    :health,
    :energy
  ]

  @required_fields [:parameter]

  @optional_fields [:flat, :rate, :variance, :maximum]

  schema "effects_recoveries" do
    field :parameter, Ecto.Enum, values: @parameters
    field :flat, :integer
    field :rate, :float
    field :variance, :float
    field :maximum, :integer

    belongs_to :effect, GEMS.Engine.Schema.Effect
  end

  @doc false
  def changeset(effect_recovery, attrs) do
    effect_recovery
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
