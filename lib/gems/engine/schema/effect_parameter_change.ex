defmodule GEMS.Engine.Schema.EffectParameterChange do
  use GEMS.Database.Schema, preset: :default

  @parameters GEMS.Engine.Constants.stats()

  @required_fields [:parameter, :type, :action]

  @optional_fields [:turns]

  schema "effects_parameter_changes" do
    field :parameter, Ecto.Enum, values: @parameters
    field :type, Ecto.Enum, values: [:buff, :debuff]
    field :action, Ecto.Enum, values: [:add, :remove]
    field :turns, :integer

    belongs_to :effect, GEMS.Engine.Schema.Effect
  end

  @doc false
  def changeset(effect_parameter_change, attrs) do
    effect_parameter_change
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:turns, greater_than_or_equal_to: 1)
  end
end
