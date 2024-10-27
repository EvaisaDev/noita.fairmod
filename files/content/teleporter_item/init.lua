local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")

local thunderstone = nxml.parse(ModTextFileGetContent("data/entities/items/pickup/thunderstone.xml"))
thunderstone:add_child(nxml.new_element("MaterialAreaCheckerComponent", {
	_tags = "enabled_in_world",
	update_every_x_frame = "20",
	["area_aabb.min_x"] = "-5",
	["area_aabb.min_y"] = "-5",
	["area_aabb.max_x"] = "5",
	["area_aabb.max_y"] = "5",
	count_min = "3",
	material = "magic_liquid_teleportation",
	material2 = "magic_liquid_unstable_teleportation",
	look_for_failure = "0",
	always_check_fullness = "1",
	kill_after_message = "0",
}))
thunderstone:add_child(nxml.new_element("LuaComponent", {
	_tags = "enabled_in_world",
	script_material_area_checker_success = "mods/noita.fairmod/files/content/teleporter_item/turn_into_teleporter.lua",
}))
ModTextFileSetContent("data/entities/items/pickup/thunderstone.xml", tostring(thunderstone))
