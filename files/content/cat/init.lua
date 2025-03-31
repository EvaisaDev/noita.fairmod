dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

---@type nxml
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")
for xml in nxml.edit_file("data/biome/_pixel_scenes.xml") do
	local scenes = xml:first_of("mBufferedPixelScenes")
	if scenes == nil then return end
	for i = -1, 1 do
		scenes:add_child(nxml.new_element("PixelScene", {
			pos_x = tostring(WORLD_WIDTH_HARDCODED * i - 2106),
			pos_y = "490",
			material_filename = "mods/noita.fairmod/files/content/cat/car.png",
			colors_filename = "mods/noita.fairmod/files/content/cat/car.png",
			background_filename = "mods/noita.fairmod/files/content/cat/car.png",
			skip_biome_checks = "1",
			clean_area_before = "1",
			DEBUG_RELOAD_ME = "0",
		}))
	end
end
