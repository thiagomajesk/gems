defmodule GEMS.Engine.Schema.TraitAttackSkill do
  use GEMS.Database.Schema, preset: :default

  @required_fields [:skill_id]

  schema "traits_attack_skills" do
    belongs_to :skill, GEMS.Engine.Schema.Skill
    belongs_to :trait, GEMS.Engine.Schema.Trait
  end

  def changeset(trait_attack_skill, attrs) do
    trait_attack_skill
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:skill)
  end
end
