defmodule GEMS.World.Schema.Blessing do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:icon, :description, :duration]

  schema "blessings" do
    field :name, :string
    field :code, :string
    field :icon, :string
    field :description, :string
    field :duration, :integer

    many_to_many :traits, GEMS.Engine.Schema.Trait, join_through: "blessings_traits"
  end
end
