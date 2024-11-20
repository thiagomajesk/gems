defmodule GEMS.Engine.Schema.CreatureReward do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:creature_id, :item_id, :amount]
  @optional_fields [:chance]

  @primary_key false
  schema "creatures_rewards" do
    field :amount, :integer
    field :chance, :float

    belongs_to :creature, GEMS.Engine.Schema.Creature, primary_key: true
    belongs_to :item, GEMS.Engine.Schema.Item, primary_key: true
  end

  @doc false
  def changeset(creature_reward, attrs) do
    creature_reward
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:creature)
    |> assoc_constraint(:item)
  end
end
