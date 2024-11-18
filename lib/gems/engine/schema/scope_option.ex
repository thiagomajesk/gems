defmodule GEMS.Engine.Schema.ScopeOption do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scope_options" do
    field :target_side, :string
    field :target_status, :string
    field :target_number, :string
    field :random_targets, :integer, default: 0
  end

  @doc false
  def changeset(scope_option, attrs) do
    scope_option
    |> cast(attrs, [:target_side, :target_status, :target_number, :random_targets])
    |> validate_required([:target_side, :target_status, :target_number])
    |> validate_inclusion(:target_side, ["Enemy", "Ally", "Both", "Self"])
    |> validate_inclusion(:target_status, ["Any", "Alive", "Dead"])
    |> validate_inclusion(:target_number, ["One", "All", "Random"])
    |> validate_number(:random_targets, greater_than_or_equal_to: 0)
  end
end
