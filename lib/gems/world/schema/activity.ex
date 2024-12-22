defmodule GEMS.World.Schema.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:zone_id, :item_id]
  @optional_fields [:profession_id, :required_level]

  schema "activities" do
    field :action, :string
    field :required_level, :integer

    belongs_to :zone, GEMS.World.Schema.Zone
    belongs_to :item, GEMS.Engine.Schema.Item
    belongs_to :profession, GEMS.World.Schema.Profession
  end

  @doc false
  def changeset(zone_activity, attrs) do
    zone_activity
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
