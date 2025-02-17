defmodule GEMS.Engine.Schema.TraitSkillSeal do
  use GEMS.Database.Schema, preset: :default

  @required_fields [:skill_id]

  schema "traits_skills_seals" do
    belongs_to :skill, GEMS.Engine.Schema.Skill
    belongs_to :trait, GEMS.Engine.Schema.Trait
  end

  def changeset(trait_skill_seal, attrs) do
    trait_skill_seal
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:skill)
  end
end
