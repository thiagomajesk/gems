defmodule GEMS.Engine.Schema.EffectStateChange do
  use GEMS.Database.Schema, :default

  @required_fields [:action, :state_id]

  @optional_fields [:chance]

  schema "effects_state_changes" do
    field :action, Ecto.Enum, values: [:add, :remove]
    field :chance, :float

    belongs_to :state, GEMS.Engine.Schema.State
    belongs_to :effect, GEMS.Engine.Schema.Effect
  end

  @doc false
  def changeset(effect_state_change, attrs) do
    effect_state_change
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:state)
  end
end
