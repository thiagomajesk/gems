defmodule GEMS.Engine.Schema.Ability do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code, :type_id],
    optional_fields: [
      :description,
      :icon,
      :health_cost,
      :energy_cost,
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
    :physical_attack,
    :magical_attack,
    :certain_hit
  ]

  @damage_types [
    :health_damage,
    :energy_damage,
    :health_recover,
    :energy_recover,
    :health_drain,
    :energy_drain
  ]

  schema "abilities" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :icon, :string
    field :health_cost, :integer
    field :energy_cost, :integer
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

    belongs_to :type, GEMS.Engine.Schema.AbilityType
    belongs_to :damage_element, GEMS.Engine.Schema.Element
    has_many :effects, GEMS.Engine.Schema.Effect, on_replace: :delete
  end

  def build_changeset(ability, attrs, opts) do
    changeset = super(ability, attrs, opts)

    changeset
    |> cast_assoc(:effects, sort_param: :effects_sort, drop_param: :effects_drop)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
