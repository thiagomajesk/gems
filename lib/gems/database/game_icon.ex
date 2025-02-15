defmodule GEMS.Database.GameIcon do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :name, :string
    field :color, :string
    field :stroke, :string
  end

  def changeset(icon, attrs) do
    icon
    |> cast(attrs, [:name, :color, :stroke])
    |> validate_required([:name])
  end
end
