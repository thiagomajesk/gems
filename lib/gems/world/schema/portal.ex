defmodule GEMS.World.Schema.Portal do
  use GEMS.Database.Schema, preset: :default

  @required_fields [
    :target_id,
    :direction
  ]

  @directions [:north, :east, :south, :west, :up, :down]

  @primary_key false
  schema "portals" do
    field :direction, Ecto.Enum, values: @directions, primary_key: true

    belongs_to :origin, GEMS.World.Schema.Zone, primary_key: true
    belongs_to :target, GEMS.World.Schema.Zone, primary_key: true
  end

  def changeset(exit, attrs) do
    exit
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:origin_id)
  end
end
