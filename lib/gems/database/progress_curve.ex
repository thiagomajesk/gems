defmodule GEMS.Database.ProgressCurve do
  use Ecto.Schema

  import Ecto.Changeset

  @required_fields [
    :max_value,
    :base_value,
    :extra_value,
    :acceleration,
    :inflation
  ]

  @primary_key false
  embedded_schema do
    field :max_value, :integer, default: 99
    field :base_value, :integer, default: 0
    field :extra_value, :integer, default: 0
    field :acceleration, :integer, default: 0
    field :inflation, :integer, default: 0
  end

  @doc false
  def changeset(exp_curve, attrs) do
    exp_curve
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:max_value, greater_than: 0)
    |> validate_number(:base_value, greater_than: 0)
    |> validate_number(:extra_value, greater_than: 0, less_than: 100)
    |> validate_number(:acceleration, greater_than: 0, less_than: 100)
    |> validate_number(:inflation, greater_than: 0, less_than: 100)
  end
end
