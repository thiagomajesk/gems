defmodule GEMS.Engine.Schema.Effect do
  use Ecto.Schema
  import Ecto.Changeset

  schema "effects" do
    belongs_to :scope_option, GEMS.Engine.Schema.ScopeOption
    belongs_to :recovery_option, GEMS.Engine.Schema.EffectRecoveryOption
    belongs_to :state_option, GEMS.Engine.Schema.EffectStateOption
    belongs_to :parameter_option, GEMS.Engine.Schema.EffectParameterOption
  end

  @doc false
  def changeset(effect, attrs) do
    effect
    |> cast(attrs, [
      :scope_option_id,
      :recovery_option_id,
      :state_option_id,
      :parameter_option_id
    ])
    |> assoc_constraint(:scope_option)
    |> assoc_constraint(:recovery_option)
    |> assoc_constraint(:state_option)
    |> assoc_constraint(:parameter_option)
  end
end
