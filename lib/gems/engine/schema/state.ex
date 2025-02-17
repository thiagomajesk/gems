defmodule GEMS.Engine.Schema.State do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:description, :priority, :restriction],
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

  @restrictions [
    :attack_enemy,
    :attack_ally,
    :attack_anyone,
    :cannot_attack
  ]

  schema "states" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :priority, :integer
    field :restriction, Ecto.Enum, values: @restrictions

    embeds_one :icon, GEMS.Database.GameIcon, on_replace: :delete

    has_many :traits, GEMS.Engine.Schema.Trait, on_replace: :delete
  end

  def build_changeset(state, attrs, opts) do
    changeset = super(state, attrs, opts)

    changeset
    |> cast_embed(:icon)
    |> cast_assoc(:traits, sort_param: :traits_sort, drop_param: :traits_drop)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
