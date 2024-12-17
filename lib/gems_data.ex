defmodule GEMSData do
  @moduledoc """
  This contains lookup information relative to the files inside the data directory.
  Its sole purpose is to make the seeding and upgrading process of game data easier.
  """

  alias GEMS.Accounts.Schema.User
  alias GEMS.Engine.Schema.Ability
  alias GEMS.Engine.Schema.AbilityType
  alias GEMS.Engine.Schema.Biome
  alias GEMS.Engine.Schema.Creature
  alias GEMS.Engine.Schema.CreatureType
  alias GEMS.Engine.Schema.Element
  alias GEMS.Engine.Schema.Equipment
  alias GEMS.Engine.Schema.EquipmentType
  alias GEMS.Engine.Schema.Item
  alias GEMS.Engine.Schema.ItemType
  alias GEMS.Engine.Schema.Profession
  alias GEMS.Engine.Schema.State
  alias GEMS.World.Schema.Avatar
  alias GEMS.World.Schema.Faction
  alias GEMSData.Lookup
  alias GEMSData.Seeder

  def seed_admin(password) do
    hash = Bcrypt.hash_pwd_salt(password)
    user = %User{email: "mail@domain.com", hashed_password: hash}
    GEMS.Repo.insert!(user, on_conflict: :replace_all, conflict_target: :email)
  end

  def seed_elements do
    elements = Lookup.list(:elements)
    seed_entities(Element, elements)
  end

  def seed_ability_types do
    ability_types = Lookup.list(:ability_types)
    seed_entities(AbilityType, ability_types)
  end

  def seed_biomes do
    biomes = Lookup.list(:biomes)
    seed_entities(Biome, biomes)
  end

  def seed_abilities do
    abilities = Lookup.list(:abilities)
    seed_entities(Ability, abilities)
  end

  def seed_creatures do
    creatures = Lookup.list(:creatures)
    seed_entities(Creature, creatures)
  end

  def seed_creature_types do
    creature_types = Lookup.list(:creature_types)
    seed_entities(CreatureType, creature_types)
  end

  def seed_equipment_types do
    equipment_types = Lookup.list(:equipment_types)
    seed_entities(EquipmentType, equipment_types)
  end

  def seed_equipments do
    equipments = Lookup.list(:equipments)
    seed_entities(Equipment, equipments)
  end

  def seed_item_types do
    item_types = Lookup.list(:item_types)
    seed_entities(ItemType, item_types)
  end

  def seed_items do
    items = Lookup.list(:items)
    seed_entities(Item, items)
  end

  def seed_professions do
    professions = Lookup.list(:professions)
    seed_entities(Profession, professions)
  end

  def seed_states do
    states = Lookup.list(:states)
    seed_entities(State, states)
  end

  def seed_avatars do
    avatars = Lookup.list(:avatars)
    seed_entities(Avatar, avatars)
  end

  def seed_factions do
    factions = Lookup.list(:factions)
    seed_entities(Faction, factions)
  end

  def seed_entities(_module, nil), do: nil

  def seed_entities(module, entities) do
    Seeder.create_entities(module, entities)
  end
end
