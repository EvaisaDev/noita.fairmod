ModMaterialsFileAdd("mods/noita.fairmod/files/content/pixelscenes/snail/snail_material.xml")
ModLuaFileAppend(
	"data/scripts/status_effects/status_list.lua",
	"mods/noita.fairmod/files/content/pixelscenes/snail/effect/effect_snail_add.lua"
)

-- Don't question my sanity, it replaces the steel with cursed rock in fungal cavern
local weird_steel = -12500928
local cursed_rock = -12694209
local fungi_cave, w, h = ModImageMakeEditable("data/wang_tiles/fungicave.png", 0, 0)
for x = 0, w do
	for y = 0, h do
		if ModImageGetPixel(fungi_cave, x, y) == weird_steel then ModImageSetPixel(fungi_cave, x, y, cursed_rock) end
	end
end
