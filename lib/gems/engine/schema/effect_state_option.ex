defmodule GEMS.Engine.Schema.EffectStateOption do
  use Ecto.Schema
  import Ecto.Changeset

  @actions [
    :add,
    :remove
  ]

  @required_fields [:action, :state_id]
  @optional_fields [:chance]

  schema "effects_state_options" do
    field :action, Ecto.Enum, values: @actions
    field :chance, :float
    belongs_to :state, GEMS.Engine.Schema.State
  end

  @doc false
  def changeset(state_option, attrs) do
    state_option
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:chance, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0)
    |> assoc_constraint(:state)
  end
end
