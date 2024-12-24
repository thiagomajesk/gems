defmodule GEMS.World.Schema.Activity do
  use GEMS.Database.Schema, :default

  @required_fields [:action, :zone_id, :item_id]
  @optional_fields [:duration, :experience, :profession_id, :required_level]

  schema "activities" do
    field :action, :string
    field :duration, :integer
    field :experience, :integer
    field :required_level, :integer

    belongs_to :zone, GEMS.World.Schema.Zone
    belongs_to :item, GEMS.Engine.Schema.Item
    belongs_to :profession, GEMS.World.Schema.Profession
  end

  @doc false
  def changeset(zone_activity, attrs) do
    build_changeset(zone_activity, attrs,
      required_fields: @required_fields,
      optional_fields: @optional_fields
    )
  end

  @doc false
  def seed_changeset(zone_activity, attrs) do
    build_changeset(zone_activity, attrs,
      required_fields: @required_fields,
      optional_fields: @optional_fields
    )
  end

  defp build_changeset(zone_activity, attrs, opts) do
    required_fields = Keyword.fetch!(opts, :required_fields)
    optional_fields = Keyword.get(opts, :optional_fields, [])

    zone_activity
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
  end
end
