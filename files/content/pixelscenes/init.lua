---@class pixel_scenes
local pixel_scenes = {}

function pixel_scenes:init()
	ModLuaFileAppend("data/scripts/biomes/coalmine.lua", "mods/noita.fairmod/files/content/pixelscenes/biomes/coalmine/coalmine.lua")
	ModLuaFileAppend("data/scripts/biomes/coalmine_alt.lua", "mods/noita.fairmod/files/content/pixelscenes/biomes/coalmine/coalmine.lua")
	ModLuaFileAppend(
		"data/scripts/biomes/excavationsite.lua",
		"mods/noita.fairmod/files/content/pixelscenes/biomes/excavationsite/excavationsite.lua"
	)
	ModLuaFileAppend("data/scripts/biomes/snowcave.lua", "mods/noita.fairmod/files/content/pixelscenes/biomes/snowcave/snowcave.lua")
	ModLuaFileAppend("data/scripts/biomes/snowcastle.lua", "mods/noita.fairmod/files/content/pixelscenes/biomes/snowcastle/snowcastle.lua")
	ModLuaFileAppend("data/scripts/biomes/rainforest.lua", "mods/noita.fairmod/files/content/pixelscenes/biomes/rainforest/rainforest.lua")
	ModLuaFileAppend("data/scripts/biomes/vault.lua", "mods/noita.fairmod/files/content/pixelscenes/biomes/vault/vault.lua")
	ModLuaFileAppend("data/scripts/biomes/crypt.lua", "mods/noita.fairmod/files/content/pixelscenes/biomes/crypt/crypt.lua")

	dofile_once("mods/noita.fairmod/files/content/pixelscenes/fish/joel_add.lua")
	ModMaterialsFileAdd("mods/noita.fairmod/files/content/pixelscenes/snail/snail_material.xml")
	ModLuaFileAppend("data/scripts/status_effects/status_list.lua", "mods/noita.fairmod/files/content/pixelscenes/snail/effect/effect_snail_add.lua")

	-- Don't question my sanity, it replaces the steel with cursed rock in fungal cavern
	local weird_steel = -12500928
	local cursed_rock = -12694209
	local fungi_cave, w, h = ModImageMakeEditable("data/wang_tiles/fungicave.png", 0, 0)
	for x = 0, w do
		for y = 0, h do
			if ModImageGetPixel(fungi_cave, x, y) == weird_steel then ModImageSetPixel(fungi_cave, x, y, cursed_rock) end
		end
	end

	-- Holy Mountain ledge that people stand on to get around Steve
	-- Make it slippery
	local altar = ModImageMakeEditable("data/biome_impl/temple/altar.png", 512, 282)
	local ice_meteor_static_colour = 0xffc81fcf -- just some slippery material that won't melt
	local none_colour = -16777216 -- 0xff000000

	for y = 43, 51 do
		for x = 317, 322 do
			if ModImageGetPixel(altar, x, y) ~= none_colour then ModImageSetPixel(altar, x, y, ice_meteor_static_colour) end
		end
	end
end

function pixel_scenes:on_player_spawn()
	-- It's weird because tree sometimes overwrites the scene
	EntityLoadCameraBound("mods/noita.fairmod/files/content/pixelscenes/statues/spawner.xml", -1700, -200)
end

return pixel_scenes
