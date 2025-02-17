defmodule GEMS.Engine.Schema.Creature do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [
      :name,
      :code,
      :type_id
    ],
    optional_fields: [
      :description,
      :image,
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
      :max_mana,
      :mana__regen,
      :magic_damage,
      :skill_power
    ],
    default_preloads: [
      traits: [
        :skill_seal,
        :attack_skill,
        :attack_element,
        :attack_state,
        :element_rate,
        :equipment_seal,
        :item_seal,
        :parameter_change,
        :parameter_rate,
        :state_rate
      ]
    ]

  schema "creatures" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :image, :string

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
    field :max_mana, :integer
    field :mana__regen, :integer
    field :magic_damage, :integer
    field :skill_power, :integer

    belongs_to :type, GEMS.Engine.Schema.CreatureType

    has_many :traits, GEMS.Engine.Schema.Trait, on_replace: :delete
    has_many :action_patterns, GEMS.Engine.Schema.CreatureActionPattern, on_replace: :delete
  end

  def build_changeset(creature, attrs, opts) do
    changeset = super(creature, attrs, opts)

    changeset
    |> cast_assoc(:traits, sort_param: :traits_sort, drop_param: :traits_drop)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
