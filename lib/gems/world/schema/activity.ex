defmodule GEMS.World.Schema.Activity do
  use GEMS.Database.Schema, preset: :default

  @required_fields [
    :action,
    :duration,
    :experience,
    :item_id,
    :profession_id
  ]

  @optional_fields [
    :min_amount,
    :max_amount,
    :required_level
  ]

  schema "activities" do
    field :action, :string
    field :duration, :integer
    field :min_amount, :integer
    field :max_amount, :integer
    field :experience, :integer
    field :required_level, :integer

    belongs_to :zone, GEMS.World.Schema.Zone
    belongs_to :item, GEMS.Engine.Schema.Item
    belongs_to :profession, GEMS.World.Schema.Profession
  end

  def changeset(activity, attrs) do
    activity
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:item)
    |> assoc_constraint(:profession)
  end
end
