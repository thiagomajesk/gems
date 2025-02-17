defmodule GEMS.Engine.Schema.Skill do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code, :type_id],
    optional_fields: [
      :description,
      :health_cost,
      :mana_cost,
      :target_side,
      :target_status,
      :target_number,
      :random_targets,
      :hit_type,
      :success_rate,
      :repeats,
      :damage_type,
      :damage_formula,
      :damage_variance,
      :critical_hits,
      :messages,
      :damage_element_id
    ],
    default_preloads: [
      effects: [
        :recovery,
        :state_change,
        :parameter_change
      ]
    ]

  @target_sides [
    :self,
    :ally,
    :enemy,
    :ally_or_enemy
  ]

  @hit_types [
    :ranged,
    :magical,
    :melee,
    :certain
  ]

  @damage_types [
    :health_damage,
    :mana_damage,
    :health_recover,
    :mana_recover,
    :health_drain,
    :mana_drain
  ]

  schema "skills" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :health_cost, :integer
    field :mana_cost, :integer
    field :messages, :map

    field :target_side, Ecto.Enum, values: @target_sides
    field :target_status, Ecto.Enum, values: [:alive, :dead]
    field :target_number, :integer
    field :random_targets, :integer

    field :hit_type, Ecto.Enum, values: @hit_types
    field :success_rate, :float
    field :repeats, :integer

    field :damage_type, Ecto.Enum, values: @damage_types
    field :damage_formula, :string
    field :damage_variance, :float
    field :critical_hits, :boolean

    embeds_one :icon, GEMS.Database.GameIcon, on_replace: :delete

    belongs_to :type, GEMS.Engine.Schema.SkillType
    belongs_to :damage_element, GEMS.Engine.Schema.Element

    has_many :effects, GEMS.Engine.Schema.Effect, on_replace: :delete
  end

  def build_changeset(skill, attrs, opts) do
    changeset = super(skill, attrs, opts)

    dbg(attrs)

    changeset
    |> cast_embed(:icon)
    |> cast_assoc(:effects, sort_param: :effects_sort, drop_param: :effects_drop)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
