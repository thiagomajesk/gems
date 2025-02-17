defmodule GEMS.Engine.Schema.SkillType do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:description]

  schema "skill_types" do
    field :name, :string
    field :code, :string
    field :description, :string
  end

  def build_changeset(skill_type, attrs, opts) do
    changeset = super(skill_type, attrs, opts)

    changeset
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
