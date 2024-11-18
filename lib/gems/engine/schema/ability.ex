defmodule GEMS.Engine.Schema.Ability do
  use Ecto.Schema
  import Ecto.Changeset

  schema "abilities" do
    field :name, :string
    field :description, :string
    field :icon, :string
    field :health_cost, :integer, default: 0
    field :energy_cost, :integer, default: 0
    field :messages, :map, default: %{}

    belongs_to :type, GEMS.Engine.Schema.AbilityType
    belongs_to :activation_option, GEMS.Engine.Schema.ActivationOption
    belongs_to :damage_option, GEMS.Engine.Schema.DamageOption
    many_to_many :effects, GEMS.Engine.Schema.Effect, join_through: "abilities_effects"
  end

  @doc false
  def changeset(ability, attrs) do
    ability
    |> cast(attrs, [
      :name,
      :description,
      :icon,
      :health_cost,
      :energy_cost,
      :messages,
      :type_id,
      :activation_option_id,
      :damage_option_id
    ])
    |> validate_required([:name, :type_id, :activation_option_id, :damage_option_id])
    |> unique_constraint(:name)
    |> assoc_constraint(:type)
    |> assoc_constraint(:activation_option)
    |> assoc_constraint(:damage_option)
  end
end
