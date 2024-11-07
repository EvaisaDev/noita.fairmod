dofile_once("mods/noita.fairmod/files/content/pixelscenes/misc_content.lua")

ModLuaFileAppend("data/scripts/biomes/coalmine.lua", "mods/noita.fairmod/files/content/pixelscenes/biomes/coalmine/coalmine.lua")
ModLuaFileAppend("data/scripts/biomes/coalmine_alt.lua", "mods/noita.fairmod/files/content/pixelscenes/biomes/coalmine/coalmine.lua")
ModLuaFileAppend("data/scripts/biomes/excavationsite.lua", "mods/noita.fairmod/files/content/pixelscenes/biomes/excavationsite/excavationsite.lua")
ModLuaFileAppend("data/scripts/biomes/snowcave.lua", "mods/noita.fairmod/files/content/pixelscenes/biomes/snowcave/snowcave.lua")
ModLuaFileAppend("data/scripts/biomes/snowcastle.lua", "mods/noita.fairmod/files/content/pixelscenes/biomes/snowcastle/snowcastle.lua")
ModLuaFileAppend("data/scripts/biomes/rainforest.lua", "mods/noita.fairmod/files/content/pixelscenes/biomes/rainforest/rainforest.lua")
ModLuaFileAppend("data/scripts/biomes/vault.lua", "mods/noita.fairmod/files/content/pixelscenes/biomes/vault/vault.lua")
ModLuaFileAppend("data/scripts/biomes/crypt.lua", "mods/noita.fairmod/files/content/pixelscenes/biomes/crypt/crypt.lua")


-- Holy Mountain ledge that people stand on to get around Steve
-- Make it slippery
local altar = ModImageMakeEditable("data/biome_impl/temple/altar.png", 512, 282)
local ice_meteor_static_colour = 0xffc81fcf	-- just some slippery material that won't melt
local none_colour = -16777216 -- 0xff000000

for y=43,51 do
	for x=317,322 do
		if ModImageGetPixel(altar, x, y) ~= none_colour then
			ModImageSetPixel(altar, x, y, ice_meteor_static_colour)
		end
	end
end
