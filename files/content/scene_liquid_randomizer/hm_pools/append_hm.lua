dofile_once("mods/noita.fairmod/files/content/scene_liquid_randomizer/material_restrictions.lua")

local function rand_material(x, y)
	SetRandomSeed(x, y + GameGetFrameNum())

	local liquids = HMMaterialsFilter(CellFactory_GetAllLiquids(false, false) or {}, true)
	return liquids[Random(1, #liquids)]
end

function fairmod_spawn_liquid_converter(x, y)
	local material = rand_material(x, y)

	local converter = EntityLoad("mods/noita.fairmod/files/content/scene_liquid_randomizer/hm_pools/convert_materials.xml", x, y + 35)
	EntityAddComponent2(converter, "MagicConvertMaterialComponent", {
		radius = 90,
		steps_per_frame = 100,
		from_material = CellFactory_GetType("water"),
		to_material = CellFactory_GetType(material),
		extinguish_fire = true,
		loop = true,
		kill_when_finished = false,
	})
end

if spawn_fish then
	local old_spawn_fish = spawn_fish
	function spawn_fish(x, y)
		fairmod_spawn_liquid_converter(x, y)
		old_spawn_fish(x, y)
	end
else
	RegisterSpawnFunction( 0xff03deaf, "fairmod_spawn_liquid_converter" )
end
