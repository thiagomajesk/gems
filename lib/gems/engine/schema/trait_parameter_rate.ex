defmodule GEMS.Engine.Schema.TraitParameterRate do
  use GEMS.Database.Schema, :default

  @parameters GEMS.Engine.Constants.stats()

  @required_fields [:parameter, :type]

  @optional_fields [:rate]

  schema "traits_parameter_rates" do
    field :parameter, Ecto.Enum, values: @parameters
    field :type, Ecto.Enum, values: [:buff, :debuff]
    field :rate, :float

    belongs_to :trait, GEMS.Engine.Schema.Trait
  end

  def changeset(trait_parameter_rate, attrs) do
    trait_parameter_rate
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
