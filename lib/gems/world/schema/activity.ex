defmodule GEMS.World.Schema.Activity do
  use GEMS.Database.Schema,
    preset: :resource,
    required_fields: [
      :action,
      :zone_id,
      :item_id
    ],
    optional_fields: [
      :duration,
      :experience,
      :profession_id,
      :level_required
    ]

  schema "activities" do
    field :action, :string
    field :duration, :integer
    field :experience, :integer
    field :level_required, :integer

    belongs_to :zone, GEMS.World.Schema.Zone
    belongs_to :item, GEMS.Engine.Schema.Item
    belongs_to :profession, GEMS.World.Schema.Profession
  end
end
