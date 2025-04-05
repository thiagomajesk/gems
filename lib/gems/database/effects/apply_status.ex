defmodule GEMS.Database.Effects.ApplyStatus do
  use Ecto.Schema

  import Ecto.Changeset

  @required [:status]
  @optional [:stacks]

  @primary_key false
  embedded_schema do
    field :status, Ecto.Enum, values: [:poisoned]
    field :stacks, :integer, default: 1
  end

  def changeset(effect, params) do
    effect
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
