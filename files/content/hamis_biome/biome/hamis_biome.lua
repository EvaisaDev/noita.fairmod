-- default biome functions that get called if we can't find a a specific biome that works for us
-- The level of action ids that are spawned from the chests
CHEST_LEVEL = 4
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile_once("data/scripts/biome_scripts.lua")
-- dofile_once("data/scripts/biome_modifiers.lua")

RegisterSpawnFunction(0xffffeedd, "init")
RegisterSpawnFunction(0xff00AC64, "load_pixel_scene4") -- wtf?
RegisterSpawnFunction(0xff80FF5A, "spawn_vines")
RegisterSpawnFunction(0xff0000ff, "spawn_nest")
RegisterSpawnFunction(0xff523160, "spawn_longest")

------------ SMALL ENEMIES ----------------------------------------------------

g_small_enemies = {
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob = 0.5,
		min_count = 0,
		max_count = 0,
		entity = "",
	},
	-- add skullflys after this step
	{
		prob = 0.5,
		min_count = 2,
		max_count = 8,
		entity = "data/entities/animals/longleg.xml",
	},
	{
		prob = 0.2,
		min_count = 1,
		max_count = 1,
		entity = "mods/noita.fairmod/files/content/hamis_biome/entities/lukki/lukki.xml",
	},
}

g_unique_enemy = g_small_enemies
g_unique_enemy2 = g_small_enemies

------------ ITEMS ------------------------------------------------------------

g_items = {
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob = 0,
		min_count = 0,
		max_count = 0,
		entity = "",
	},
	-- add skullflys after this step
	{
		prob = 5,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/items/wand_level_04.xml",
	},
	{
		prob = 3,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/items/wand_level_05.xml",
	},
	{
		prob = 3,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/items/wand_unshuffle_03.xml",
	},
	{
		prob = 3,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/items/wand_unshuffle_04.xml",
	},
	{
		prob = 5,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/items/wand_level_05_better.xml",
	},
}

g_props = {
	total_prob = 0,
	{
		prob = 2,
		min_count = 0,
		max_count = 0,
		entity = "",
	},
	{
		prob = 0.1,
		min_count = 1,
		max_count = 2,
		entity = "data/entities/props/physics_vase_longleg.xml",
	},
	{
		prob = 0.08,
		min_count = 1,
		max_count = 1,
		entity = "mods/noita.fairmod/files/content/hamis_biome/entities/fungus/physics_fungus_small.xml",
	},
	{
		prob = 0.1,
		min_count = 1,
		max_count = 1,
		entity = "mods/noita.fairmod/files/content/hamis_biome/entities/fungus/physics_fungus.xml",
	},
	{
		prob = 0.06,
		min_count = 1,
		max_count = 1,
		entity = "mods/noita.fairmod/files/content/hamis_biome/entities/fungus/physics_fungus_big.xml",
	},
}

g_lamp = {
	total_prob = 0,
	-- add skullflys after this step
	-- {
	-- 	prob = 0.3,
	-- 	min_count = 1,
	-- 	max_count = 1,
	-- 	entity = "",
	-- },
	{
		prob = 0.6,
		min_count = 1,
		max_count = 3,
		entity = "mods/noita.fairmod/files/content/hamis_biome/entities/lamp_hamis/lamp_hamis.xml",
	},
	{
		prob = 1.0,
		min_count = 1,
		max_count = 1,
		entity = "mods/noita.fairmod/files/content/hamis_biome/entities/fungus/physics_fungus_small.xml",
	},
	{
		prob = 0.1,
		min_count = 1,
		max_count = 2,
		entity = "data/entities/props/physics_vase_longleg.xml",
	},
	-- {
	-- 	prob = 1.0,
	-- 	min_count = 1,
	-- 	max_count = 1,
	-- 	entity = "data/entities/props/physics_fungus.xml",
	-- },
	-- {
	-- 	prob = 0.5,
	-- 	min_count = 1,
	-- 	max_count = 1,
	-- 	entity = "data/entities/props/physics_fungus_big.xml",
	-- },
}

g_pixel_scene_01 = {
	total_prob = 0,
	{
		prob = 0.2,
		material_file = "mods/noita.fairmod/files/content/hamis_biome/biome/pixelscenes/v_200_400_hamis.png",
		visual_file = "mods/noita.fairmod/files/content/hamis_biome/biome/pixelscenes/v_200_400_hamis_visual.png",
		background_file = "",
		is_unique = 0,
	},
	{
		prob = 1,
		material_file = "mods/noita.fairmod/files/content/hamis_biome/biome/pixelscenes/v_200_400_longest.png",
		visual_file = "",
		background_file = "",
		is_unique = 1,
	},
}

g_pixel_scene_02 = {
	total_prob = 0,
	-- {
	-- 	prob = 0.5,
	-- 	material_file = "data/biome_impl/rainforest/hut03.png",
	-- 	visual_file = "",
	-- 	background_file = "",
	-- 	is_unique = 0,
	-- },
	{
		prob = 1.2,
		material_file = "mods/noita.fairmod/files/content/hamis_biome/biome/pixelscenes/h_400_200_garden.png",
		visual_file = "",
		background_file = "",
		is_unique = 0,
	},
}

g_ghostlamp = g_lamp
g_candles = g_lamp

g_vines = {
	total_prob = 0,
	{
		prob = 0.5,
		min_count = 1,
		max_count = 1,
		entity = "",
	},
	{
		prob = 0.4,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/verlet_chains/vines/verlet_vine_dark.xml",
	},
	{
		prob = 0.3,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/verlet_chains/vines/verlet_vine_dark_long.xml",
	},
	{
		prob = 0.5,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/verlet_chains/vines/verlet_vine_dark_short.xml",
	},
	{
		prob = 0.5,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/verlet_chains/vines/verlet_vine_dark_shorter.xml",
	},
}

g_nest = {
	total_prob = 0,
	{
		prob = 0.5,
		min_count = 1,
		max_count = 1,
		entity = "mods/noita.fairmod/files/content/hamis_biome/entities/nest_spawner/nest_spawner.xml",
	},
}

-- actual functions that get called from the wang generator

function init(x, y, w, h) end

function spawn_small_enemies(x, y)
	spawn(g_small_enemies, x, y)
	-- spawn_hp_mult(g_small_enemies,x,y,0,0,2,"rainforest")
end

function spawn_unique_enemy(x, y)
	spawn(g_unique_enemy, x, y + 12)
	-- spawn_hp_mult(g_unique_enemy,x,y,0,0,2,"rainforest")
end

function spawn_unique_enemy2(x, y)
	spawn(g_unique_enemy2, x, y)
	-- spawn_hp_mult(g_unique_enemy,x,y,0,0,2,"rainforest")
end

function spawn_items(x, y)
	local r = ProceduralRandom(x - 11.631, y + 10.2257)

	if r > 0.27 then LoadPixelScene("data/biome_impl/wand_altar.png", "data/biome_impl/wand_altar_visual.png", x - 10, y - 17, "", true) end
end

function spawn_props(x, y)
	spawn(g_props, x, y)
end

function spawn_lamp(x, y)
	spawn(g_lamp, x, y - 10)
end

function load_pixel_scene(x, y)
	load_random_pixel_scene(g_pixel_scene_01, x, y)
end

function load_pixel_scene2(x, y)
	load_random_pixel_scene(g_pixel_scene_02, x, y)
end

function load_pixel_scene4(x, y)
	--load_random_pixel_scene( g_pixel_scene_04, x, y )
end

function spawn_nest(x, y)
	spawn(g_nest, x, y + 40)
end

function spawn_vines(x, y)
	spawn(g_vines, x + 5, y + 5)
	-- chance for an extra spawn for denser vineage
	if ProceduralRandomf(x, y) < 0.5 then spawn(g_vines, x, y + 5) end
end

function spawn_longest(x, y)
	if GameHasFlagRun("fairmod_longest_spawned") then return end
	GameAddFlagRun("fairmod_longest_spawned")
	EntityLoad("mods/noita.fairmod/files/content/pixelscenes/longest_leg/longest.xml", x, y)
end
