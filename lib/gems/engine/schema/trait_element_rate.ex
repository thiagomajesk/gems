defmodule GEMS.Engine.Schema.TraitElementRate do
  use GEMS.Database.Schema, :default

  @required_fields [:element_id]

  @optional_fields [:rate]

  schema "traits_element_rates" do
    field :rate, :float

    belongs_to :element, GEMS.Engine.Schema.Element
    belongs_to :trait, GEMS.Engine.Schema.Trait
  end

  def changeset(trait_element_rate, attrs) do
    trait_element_rate
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:element)
  end
end
