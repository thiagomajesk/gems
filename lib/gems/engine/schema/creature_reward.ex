defmodule GEMS.Engine.Schema.CreatureReward do
  use Ecto.Schema
  import Ecto.Changeset

  schema "creatures_rewards" do
    belongs_to :creature, GEMS.Engine.Schema.Creature
    belongs_to :item, GEMS.Engine.Schema.Item
    field :amount, :integer
    field :chance, :float, default: 0.0
  end

  @doc false
  def changeset(creature_reward, attrs) do
    creature_reward
    |> cast(attrs, [:creature_id, :item_id, :amount, :chance])
    |> validate_required([:creature_id, :item_id, :amount])
    |> assoc_constraint(:creature)
    |> assoc_constraint(:item)
  end
end
