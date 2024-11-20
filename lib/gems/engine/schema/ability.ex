defmodule GEMS.Engine.Schema.Ability do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :type_id, :activation_option_id, :damage_option_id]
  @optional_fields [:description, :icon, :health_cost, :energy_cost, :messages]

  schema "abilities" do
    field :name, :string
    field :description, :string
    field :icon, :string
    field :health_cost, :integer
    field :energy_cost, :integer
    field :messages, :map

    belongs_to :type, GEMS.Engine.Schema.AbilityType
    belongs_to :activation_option, GEMS.Engine.Schema.ActivationOption
    belongs_to :damage_option, GEMS.Engine.Schema.DamageOption
    many_to_many :effects, GEMS.Engine.Schema.Effect, join_through: "abilities_effects"
  end

  @doc false
  def changeset(ability, attrs) do
    ability
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
