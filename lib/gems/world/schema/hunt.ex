defmodule GEMS.World.Schema.Hunt do
  use GEMS.Database.Schema, preset: :default

  @required_fields [
    :creature_id
  ]

  @optional_fields [
    :challenge
  ]

  schema "hunts" do
    field :challenge, :integer

    belongs_to :zone, GEMS.World.Schema.Zone
    belongs_to :creature, GEMS.Engine.Schema.Creature
  end

  def changeset(activity, attrs) do
    activity
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:zone)
    |> assoc_constraint(:creature)
  end
end
