defmodule GEMS.Engine.Schema.TraitParameterChange do
  use GEMS.Database.Schema, :default

  @parameters GEMS.Engine.Constants.stats()

  @required_fields [:parameter]

  @optional_fields [:flat, :rate]

  schema "traits_parameter_change" do
    field :parameter, Ecto.Enum, values: @parameters
    field :flat, :integer
    field :rate, :float

    belongs_to :trait, GEMS.Engine.Schema.Trait
  end

  def changeset(trait_param_bonus, attrs) do
    trait_param_bonus
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
