local old_spawn_hp = spawn_hp
function spawn_hp(x, y)
	old_spawn_hp(x, y)

	EntityLoad("mods/noita.fairmod/files/content/scene_liquid_randomizer/hm_pools/convert_materials.xml", x + 29, y + 40)
	EntityLoad("mods/noita.fairmod/files/content/scene_liquid_randomizer/hm_pools/convert_materials.xml", x - 95, y + 40)
end
