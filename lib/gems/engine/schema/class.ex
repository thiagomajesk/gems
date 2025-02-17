defmodule GEMS.Engine.Schema.Class do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:description],
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

  schema "classes" do
    field :name, :string
    field :code, :string
    field :description, :string

    embeds_one :strength_curve, GEMS.Database.ProgressCurve, on_replace: :delete
    embeds_one :dexterity_curve, GEMS.Database.ProgressCurve, on_replace: :delete
    embeds_one :intelligence_curve, GEMS.Database.ProgressCurve, on_replace: :delete

    has_many :traits, GEMS.Engine.Schema.Trait, on_replace: :delete
  end

  def build_changeset(avatar, attrs, opts) do
    changeset = super(avatar, attrs, opts)

    changeset
    |> cast_embed(:strength_curve)
    |> cast_embed(:dexterity_curve)
    |> cast_embed(:intelligence_curve)
    |> cast_assoc(:traits, sort_param: :traits_sort, drop_param: :traits_drop)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
