defmodule GEMS.Engine.Schema.ActivationOption do
  use Ecto.Schema
  import Ecto.Changeset

  @hit_types [:physical_attack, :magical_attack, :certain_hit]

  schema "activation_options" do
    field :hit_type, Ecto.Enum, values: @hit_types
    field :success_rate, :float, default: 1.0
    field :repeats, :integer, default: 1
  end

  @doc false
  def changeset(activation_option, attrs) do
    activation_option
    |> cast(attrs, [:hit_type, :success_rate, :repeats])
    |> validate_required([:hit_type, :repeats])
    |> validate_number(:success_rate, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0)
    |> validate_number(:repeats, greater_than: 0)
  end
end
