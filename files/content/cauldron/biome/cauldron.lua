-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 1
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction(0xffffeedd, "init")

local function spawn_stalactite(x, y)
	SetRandomSeed(x, y)

	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/triggers/generic/stalactite_generic_" .. Random(1, 3) .. ".xml", x, y + 200)

	if Random(1, 100) > 60 then
		local hit, hit_x, hit_y = RaytracePlatforms(x, y, x, y - 200)
		if hit then
			EntityLoad(
				"mods/noita.fairmod/files/content/stalactite/entities/triggers/generic/stalactite_generic_" .. Random(1, 3) .. ".xml",
				hit_x,
				hit_y
			)
		end
	end
end

function init(x, y, w, h)
	LoadPixelScene(
		"mods/noita.fairmod/files/content/cauldron/scenes/altar_materials_2.png",
		"mods/noita.fairmod/files/content/cauldron/scenes/altar_foreground-2.png",
		x,
		y,
		"mods/noita.fairmod/files/content/cauldron/scenes/altar_background-1.png",
		true
	)
	EntityLoad("mods/noita.fairmod/files/content/cauldron/material_checker.xml", x + 262.5, y + 305)

	LoadPixelScene(
		"mods/noita.fairmod/files/content/cauldron/scenes/altar_materials_right.png",
		"",
		x + 512,
		y,
		"mods/noita.fairmod/files/content/cauldron/scenes/altar_background-2.png",
		true
	)

	-- for i = 1, 10 do
	-- 	local spawn_x = x + 512 + (i * 30)
	-- 	local spawn_y = y + 285
	-- 	spawn_stalactite(spawn_x, spawn_y)
	-- end

	LoadPixelScene(
		"mods/noita.fairmod/files/content/cauldron/scenes/altar_materials_bottom.png",
		"",
		x + 512,
		y + 512,
		"mods/noita.fairmod/files/content/cauldron/scenes/altar_background-3.png",
		true
	)
	LoadPixelScene(
		"mods/noita.fairmod/files/content/cauldron/scenes/altar_materials_entry.png",
		"",
		x,
		y + 512,
		"",
		true
	)
end
