defmodule GEMSWeb.Collections do
  alias GEMSWeb.Admin.Database.CollectionLive.Forms

  @collections %{
    "skills" => %{
      module: GEMS.Engine.Schema.Skill,
      form: Forms.SkillComponent,
      preloads: [:type],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :enum, label: "Code"},
        %{field: :type, type: {:assoc, "skill-types"}, label: "Type"}
      ]
    },
    "skill-types" => %{
      module: GEMS.Engine.Schema.SkillType,
      form: Forms.SkillTypeComponent,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    },
    "biomes" => %{
      module: GEMS.World.Schema.Biome,
      form: Forms.BiomeComponent,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    },
    "blessings" => %{
      module: GEMS.World.Schema.Blessing,
      form: Forms.BlessingComponent,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    },
    "creature-types" => %{
      module: GEMS.Engine.Schema.CreatureType,
      form: Forms.CreatureTypeComponent,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    },
    "creatures" => %{
      module: GEMS.Engine.Schema.Creature,
      form: Forms.CreatureComponent,
      preloads: [:type],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"},
        %{field: :type, type: {:assoc, "creature-types"}, label: "Type"}
      ]
    },
    "equipment-types" => %{
      module: GEMS.Engine.Schema.EquipmentType,
      form: Forms.EquipmentTypeComponent,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    },
    "equipments" => %{
      module: GEMS.Engine.Schema.Equipment,
      form: Forms.EquipmentComponent,
      preloads: [:type],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"},
        %{field: :type, type: {:assoc, "equipment-types"}, label: "Type"}
      ]
    },
    "factions" => %{
      module: GEMS.World.Schema.Faction,
      form: Forms.FactionComponent,
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ],
      preloads: []
    },
    "item-types" => %{
      module: GEMS.Engine.Schema.ItemType,
      form: Forms.ItemTypeComponent,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    },
    "items" => %{
      module: GEMS.Engine.Schema.Item,
      form: Forms.ItemComponent,
      preloads: [:type],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"},
        %{field: :type, type: {:assoc, "item-types"}, label: "Type"}
      ]
    },
    "classes" => %{
      module: GEMS.Engine.Schema.Class,
      form: Forms.ClassComponent,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    },
    "professions" => %{
      module: GEMS.World.Schema.Profession,
      form: Forms.ProfessionComponent,
      preloads: [],
      columns: [
        %{field: :id, type: :id, label: "ID"},
        %{field: :name, type: :text, label: "Name"},
        %{field: :code, type: :text, label: "Code"}
      ]
    }
  }

  def spec(collection) do
    Map.fetch!(@collections, collection)
  end

  def list_entities(collection) do
    spec = spec(collection)
    module = Map.fetch!(spec, :module)
    preloads = Map.fetch!(spec, :preloads)
    apply(module, :list, [preloads])
  end

  def get_entity(collection, id) do
    spec = spec(collection)
    module = Map.fetch!(spec, :module)
    apply(module, :get!, [id])
  end

  def change_entity(collection, entity \\ nil, attrs \\ %{}) do
    spec = spec(collection)
    module = Map.fetch!(spec, :module)
    apply(module, :change, [entity, attrs])
  end

  def create_entity(collection, attrs) do
    spec = spec(collection)
    module = Map.fetch!(spec, :module)
    apply(module, :create, [attrs])
  end

  def update_entity(collection, entity, attrs) do
    spec = spec(collection)
    module = Map.fetch!(spec, :module)
    apply(module, :update, [entity, attrs])
  end
end
