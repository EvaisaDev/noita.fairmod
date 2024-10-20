---@type nxml
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")
for xml in nxml.edit_file("data/biome/_pixel_scenes.xml") do
	local scenes = xml:first_of("mBufferedPixelScenes")
	if scenes ~= nil then
		scenes:add_child(nxml.new_element("PixelScene", {
			pos_x = "3583", --tostring(3835-252),
			pos_y = "5119", --tostring(5454-335)",
			material_filename = "mods/noita.fairmod/files/content/cauldron/altar_materials.png",
			colors_filename = "mods/noita.fairmod/files/content/cauldron/altar_foreground-2.png",
			background_filename = "mods/noita.fairmod/files/content/cauldron/altar_background-1.png",
			skip_biome_checks = "1",
			clean_area_before = "1",
			DEBUG_RELOAD_ME = "0",
		}))

		scenes:add_child(nxml.new_element("PixelScene", {
			pos_x = "3845.5", --tostring(3835-252),
			pos_y = "5424", --tostring(5454-335)",
			just_load_an_entity = "mods/noita.fairmod/files/content/cauldron/material_checker.xml",
			DEBUG_RELOAD_ME = "0",
		}))
	end
end

ModMaterialsFileAdd("mods/noita.fairmod/files/content/cauldron/materials.xml")
