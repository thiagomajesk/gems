defmodule GEMS.World.Schema.Activity do
  use GEMS.Database.Schema, preset: :default

  @required_fields [
    :action,
    :amount,
    :duration,
    :experience,
    :required_level,
    :item_id,
    :profession_id
  ]

  schema "activities" do
    field :action, :string
    field :amount, :integer
    field :duration, :integer
    field :experience, :integer
    field :required_level, :integer

    belongs_to :zone, GEMS.World.Schema.Zone
    belongs_to :item, GEMS.Engine.Schema.Item
    belongs_to :profession, GEMS.World.Schema.Profession
  end

  def changeset(activity, attrs) do
    activity
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:item)
    |> assoc_constraint(:profession)
  end
end
