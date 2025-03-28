defmodule GEMS.Engine.Schema.Class do
  use GEMS.Database.Schema,
    preset: :collection,
    required_fields: [:name, :code],
    optional_fields: [:description],
    default_preloads: []

  schema "classes" do
    field :name, :string
    field :code, :string
    field :description, :string

    embeds_one :strength_curve, GEMS.Database.ProgressCurve, on_replace: :delete
    embeds_one :dexterity_curve, GEMS.Database.ProgressCurve, on_replace: :delete
    embeds_one :intelligence_curve, GEMS.Database.ProgressCurve, on_replace: :delete
  end

  def build_changeset(avatar, attrs, opts) do
    changeset = super(avatar, attrs, opts)

    changeset
    |> cast_embed(:strength_curve)
    |> cast_embed(:dexterity_curve)
    |> cast_embed(:intelligence_curve)
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end
end
