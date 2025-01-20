defmodule GEMS.Engine.Schema.Effect do
  use GEMS.Database.Schema, preset: :default

  @kinds [
    :recovery,
    :state_change,
    :parameter_change
  ]

  @required_fields [:kind]

  schema "effects" do
    field :kind, Ecto.Enum, values: @kinds

    belongs_to :item, GEMS.Engine.Schema.Item
    belongs_to :ability, GEMS.Engine.Schema.Ability

    has_one :recovery, GEMS.Engine.Schema.EffectRecovery, on_replace: :delete
    has_one :state_change, GEMS.Engine.Schema.EffectStateChange, on_replace: :delete
    has_one :parameter_change, GEMS.Engine.Schema.EffectParameterChange, on_replace: :delete
  end

  @doc false
  def changeset(effect, attrs) do
    effect
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:item)
    |> cast_assoc(:recovery)
    |> cast_assoc(:state_change)
    |> cast_assoc(:parameter_change)
  end
end
