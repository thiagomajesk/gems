defmodule GEMS.Engine.Schema.Creature do
  use GEMS.Database.Schema,
    preset: :resource,
    required_fields: [
      :name,
      :code,
      :type_id,
      :biome_id
    ],
    optional_fields: [
      :description,
      :armor_rating,
      :max_health,
      :health_regen,
      :attack_damage,
      :weapon_power,
      :evasion_rating,
      :attack_speed,
      :critical_rating,
      :accuracy_rating,
      :critical_power,
      :magic_resist,
      :max_energy,
      :energy_regen,
      :magic_damage,
      :ability_power
    ]

  schema "creatures" do
    field :name, :string
    field :code, :string
    field :description, :string

    # STR
    field :armor_rating, :integer
    field :max_health, :integer
    field :health_regen, :integer
    field :attack_damage, :integer
    field :weapon_power, :integer

    # DEX
    field :evasion_rating, :integer
    field :attack_speed, :integer
    field :critical_rating, :integer
    field :accuracy_rating, :integer
    field :critical_power, :integer

    # INT
    field :magic_resist, :integer
    field :max_energy, :integer
    field :energy_regen, :integer
    field :magic_damage, :integer
    field :ability_power, :integer

    belongs_to :biome, GEMS.Engine.Schema.Biome
    belongs_to :type, GEMS.Engine.Schema.CreatureType
    has_many :traits, GEMS.Engine.Schema.Trait, on_replace: :delete
    has_many :action_patterns, GEMS.Engine.Schema.CreatureActionPattern
  end

  def build_changeset(creature, attrs, opts) do
    changeset = super(creature, attrs, opts)

    changeset
    |> cast_assoc(:traits, sort_param: :traits_sort, drop_param: :traits_drop)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
