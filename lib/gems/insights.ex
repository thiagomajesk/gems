defmodule GEMS.Insights do
  alias GEMS.Repo
  alias GEMS.Accounts.Schema.User
  alias GEMS.World.Schema.Character
  alias GEMS.World.Schema.Profession
  alias GEMS.Engine.Schema.Skill
  alias GEMS.Engine.Schema.SkillType
  alias GEMS.World.Schema.Biome
  alias GEMS.Engine.Schema.Creature
  alias GEMS.Engine.Schema.CreatureType
  alias GEMS.Engine.Schema.Equipment
  alias GEMS.Engine.Schema.EquipmentType
  alias GEMS.Engine.Schema.Element
  alias GEMS.Engine.Schema.Item
  alias GEMS.Engine.Schema.ItemType
  alias GEMS.Engine.Schema.State

  def count_active_accounts() do
    Repo.aggregate(User, :count, :id)
  end

  def count_active_characters() do
    Repo.aggregate(Character, :count, :id)
  end

  def count_skills() do
    Repo.aggregate(Skill, :count, :id)
  end

  def count_skill_types() do
    Repo.aggregate(SkillType, :count, :id)
  end

  def count_biomes() do
    Repo.aggregate(Biome, :count, :id)
  end

  def count_creature_types() do
    Repo.aggregate(CreatureType, :count, :id)
  end

  def count_creatures() do
    Repo.aggregate(Creature, :count, :id)
  end

  def count_equipments() do
    Repo.aggregate(Equipment, :count, :id)
  end

  def count_equipment_types() do
    Repo.aggregate(EquipmentType, :count, :id)
  end

  def count_elements() do
    Repo.aggregate(Element, :count, :id)
  end

  def count_items() do
    Repo.aggregate(Item, :count, :id)
  end

  def count_item_types() do
    Repo.aggregate(ItemType, :count, :id)
  end

  def count_professions() do
    Repo.aggregate(Profession, :count, :id)
  end

  def count_states() do
    Repo.aggregate(State, :count, :id)
  end
end
