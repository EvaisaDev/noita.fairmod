local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") ---@type nxml
dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

local children = {}

local fish_scene_y = -473
local fish_scene_x = 680
local fish_entity_x = fish_scene_x + 62
local fish_entity_y = fish_scene_y + 80

for i = -1, 1 do
	if i ~= 0 then
		children[#children + 1] = nxml.new_element("PixelScene", {
			DEBUG_RELOAD_ME = "0",
			background_filename = "mods/noita.fairmod/files/content/pixelscenes/fish/fishbowl_background.png",
			clean_area_before = "0",
			colors_filename = "mods/noita.fairmod/files/content/pixelscenes/fish/fishbowl_visual.png",
			material_filename = "mods/noita.fairmod/files/content/pixelscenes/fish/fishbowl.png",
			pos_y = fish_scene_y,
			pos_x = fish_scene_x + WORLD_WIDTH_HARDCODED * i,
			skip_biome_checks = "1",
			skip_edge_textures = "0",
		})
		children[#children + 1] = nxml.new_element("PixelScene", {
			pos_y = fish_entity_y,
			pos_x = fish_entity_x + WORLD_WIDTH_HARDCODED * i,
			just_load_an_entity = "mods/noita.fairmod/files/content/pixelscenes/fish/entity/joel.xml",
		})
	end
end

for i = -1, 1 do
	children[#children + 1] = nxml.new_element("PixelScene", {
		pos_x = tostring(WORLD_WIDTH_HARDCODED * i - 2106),
		pos_y = "490",
		material_filename = "mods/noita.fairmod/files/content/pixelscenes/cat/car.png",
		colors_filename = "mods/noita.fairmod/files/content/pixelscenes/cat/car.png",
		background_filename = "mods/noita.fairmod/files/content/pixelscenes/cat/car.png",
		skip_biome_checks = "1",
		clean_area_before = "1",
		DEBUG_RELOAD_ME = "0",
	})
end

local scenes_to_change = {
	["data/biome_impl/temple/altar_vault_capsule.png"] = {
		material_filename = "mods/noita.fairmod/files/content/pixelscenes/biomes/vault/altar_vault_capsule.png",
		colors_filename = "mods/noita.fairmod/files/content/pixelscenes/biomes/vault/altar_vault_capsule_visual.png",
	},
}

for xml in nxml.edit_file("data/biome/_pixel_scenes.xml") do
	local mbuffer = xml:first_of("mBufferedPixelScenes")
	if not mbuffer then return end

	for scene in mbuffer:each_of("PixelScene") do
		local material_path = scene:get("material_filename")
		if scenes_to_change[material_path] then
			for k, v in pairs(scenes_to_change[material_path]) do
				scene:set(k, v)
			end
		end
	end

	mbuffer:add_children(children)
end
