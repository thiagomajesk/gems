defmodule GEMS.Engine.Schema.ItemEffect do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items_effects" do
    belongs_to :item, GEMS.Engine.Schema.Item
    belongs_to :effect, GEMS.Engine.Schema.Effect
  end

  @doc false
  def changeset(item_effect, attrs) do
    item_effect
    |> cast(attrs, [:item_id, :effect_id])
    |> validate_required([:item_id, :effect_id])
    |> assoc_constraint(:item)
    |> assoc_constraint(:effect)
  end
end
