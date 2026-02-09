dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

--add hamis to tablets
ModTextFileSetContent("data/entities/items/books/base_book.xml", ModTextFileGetContent("data/entities/items/books/base_book.xml")
	:gsub("data/items_gfx/emerald_tablet.png", "mods/noita.fairmod/files/content/data_overrides/hamis_tablet.png")
)


local mountain_hall_bgs = {
	"hall_background.png",
	"hall_background_gamepad.png",
	"hall_background_gamepad_updated.png",
}

local mountain_halls = {
	"hall.png",
	"hall_gamepad.png",
}

for _,bg in ipairs(mountain_hall_bgs) do
	OverlayImage("data/biome_impl/mountain/" .. bg, "mods/noita.fairmod/files/content/data_overrides/hall_bg_overlay.png")
end

for _,bg in ipairs(mountain_halls) do
	OverlayImage("data/biome_impl/mountain/" .. bg, "mods/noita.fairmod/files/content/data_overrides/hall_overlay.png")
end

OverlayImage("data/biome_impl/mountain/floating_island_visual.png", "mods/noita.fairmod/files/content/data_overrides/floating_island_glyph.png", 193, 329)

--for i = 1, 200 do
--	for k = 1, 200 do
--		OverlayImage("data/biome_impl/mountain/floating_island_visual.png", "mods/noita.fairmod/files/content/data_overrides/floating_island_glyph.png", k, i)
--	end
--end
OverlayImage("data/biome_impl/mountain/floating_island_visual.png", "mods/noita.fairmod/files/content/data_overrides/floating_island_glyph.png", 131, 224)