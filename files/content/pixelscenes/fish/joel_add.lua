local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") ---@type nxml
dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

local scene_y = -473
local scene_x = 680
local entity_x = scene_x + 62
local entity_y = scene_y + 80

local children = {}
for i = -1, 1 do
	if i ~= 0 then
		children[#children + 1] = nxml.new_element("PixelScene", {
			DEBUG_RELOAD_ME = "0",
			background_filename = "mods/noita.fairmod/files/content/pixelscenes/fish/fishbowl_background.png",
			clean_area_before = "0",
			colors_filename = "mods/noita.fairmod/files/content/pixelscenes/fish/fishbowl_visual.png",
			material_filename = "mods/noita.fairmod/files/content/pixelscenes/fish/fishbowl.png",
			pos_y = scene_y,
			pos_x = scene_x + WORLD_WIDTH_HARDCODED * i,
			skip_biome_checks = "1",
			skip_edge_textures = "0",
		})
		children[#children + 1] = nxml.new_element("PixelScene", {
			pos_y = entity_y,
			pos_x = entity_x + WORLD_WIDTH_HARDCODED * i,
			just_load_an_entity = "mods/noita.fairmod/files/content/pixelscenes/fish/entity/joel.xml",
		})
	end
end

for xml in nxml.edit_file("data/biome/_pixel_scenes.xml") do
	local mbuffer = xml:first_of("mBufferedPixelScenes")
	if not mbuffer then return end
	mbuffer:add_children(children)
end
