dofile_once("data/scripts/director_helpers.lua")

local x, y = EntityGetTransform(GetUpdatedEntityID())


local biome_spawns = {
	hills = {
		total_prob = 0,
		{ prob = 0.9, entity = "data/entities/animals/deer.xml" },
		{ prob = 0.9, entity = "data/entities/animals/duck.xml" },
		{ prob = 0.9, entity = "data/entities/animals/elk.xml" },
		{ prob = 0.9, entity = "data/entities/animals/sheep.xml" },
		{ prob = 0.2, entity = "data/entities/props/physics_stone_01.xml" },
		{ prob = 0.2, entity = "data/entities/props/physics_stone_02.xml" },
		{ prob = 0.2, entity = "data/entities/props/physics_stone_03.xml" },
		{ prob = 0.2, entity = "data/entities/props/physics_stone_04.xml" },
		{ prob = 0.2, entity = "data/entities/props/stonepile.xml" },
		{ prob = 0.2, entity = "data/entities/props/physics_campfire.xml" },
		{ prob = 0.3, entity = "data/entities/props/pumpkin_01.xml" },
		{ prob = 0.3, entity = "data/entities/props/pumpkin_02.xml" },
		{ prob = 0.3, entity = "data/entities/props/pumpkin_03.xml" },
		{ prob = 0.3, entity = "data/entities/props/pumpkin_04.xml" },
		{ prob = 0.3, entity = "data/entities/props/pumpkin_05.xml" },
		{ prob = 0.1, entity = "data/entities/animals/frog.xml" },
		{ prob = 0.1, entity = "data/entities/animals/rat.xml" },
	},
	desert = {
		total_prob = 0,
		{ prob = 2, entity = "data/entities/animals/scorpion.xml" },
		{ prob = 0.1, entity = "data/entities/props/physics_skull_01.xml" },
		{ prob = 0.1, entity = "data/entities/props/physics_skull_02.xml" },
		{ prob = 0.1, entity = "data/entities/props/physics_skull_03.xml" },
		{ prob = 0.2, entity = "data/entities/props/physics_temple_rubble_01.xml" },
		{ prob = 0.2, entity = "data/entities/props/physics_temple_rubble_02.xml" },
		{ prob = 0.2, entity = "data/entities/props/physics_temple_rubble_03.xml" },
		{ prob = 0.2, entity = "data/entities/props/physics_temple_rubble_04.xml" },
		{ prob = 0.2, entity = "data/entities/props/physics_temple_rubble_05.xml" },
		{ prob = 0.2, entity = "data/entities/props/physics_temple_rubble_06.xml" },
	},
	winter = {
		total_prob = 0,
		{ prob = 0.5, entity = "data/entities/animals/wolf.xml" },
		{ prob = 1, entity = "data/entities/props/physics_torch_stand.xml" },
		{ prob = 0.3, entity = "data/entities/props/physics_stone_01.xml" },
		{ prob = 0.3, entity = "data/entities/props/physics_stone_02.xml" },
		{ prob = 0.3, entity = "data/entities/props/physics_stone_03.xml" },
		{ prob = 0.3, entity = "data/entities/props/physics_stone_04.xml" },
		{ prob = 0.3, entity = "data/entities/props/stonepile.xml" },
		{ prob = 0.4, entity = "mods/noita.fairmod/files/content/snowman/snowman.xml" },
	},
	lake = {
		total_prob = 0,
		{ prob = 2, entity = "mods/noita.fairmod/files/content/enemy_reworks/fish/fish.xml" },
	},
}


local function get_biome()
	local biome_x = ((x / 512) + 35) % 70

	if biome_x < 11 then
		return "lake"
	elseif biome_x < 31 then
		return "winter"
	elseif biome_x < 45 then
		return "hills"
	else
		return "desert"
	end
end

-----------------------------------------------------------------
local biome = get_biome()
local biome_choices = biome_spawns[biome]

SetRandomSeed(x, y)
local spawn_entity = random_from_table(biome_choices, x, y)
if spawn_entity ~= nil then
	EntityLoad(tostring(spawn_entity.entity), x, y)
end
