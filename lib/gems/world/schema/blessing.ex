defmodule GEMS.World.Schema.Blessing do
  use GEMS.Database.Schema,
    preset: :resource,
    required_fields: [:name, :duration],
    optional_fields: [:icon, :description]

  schema "blessings" do
    field :name, :string
    field :icon, :string
    field :description, :string
    field :duration, :integer

    many_to_many :traits, GEMS.Engine.Schema.Trait, join_through: "blessings_traits"
  end
end
