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
	ImageOverlay("data/biome_impl/mountain/" .. bg, "mods/noita.fairmod/files/content/data_overrides/mountain/hall_bg_overlay.png")
end

for _,bg in ipairs(mountain_halls) do
	ImageOverlay("data/biome_impl/mountain/" .. bg, "mods/noita.fairmod/files/content/data_overrides/mountain/hall_overlay.png")
end

ImageOverlay("data/biome_impl/mountain/floating_island_visual.png", "mods/noita.fairmod/files/content/data_overrides/mountain/floating_island_visual.png", 131, 224)

ModTextFileSetContent("data/scripts/buildings/spidernest.lua", "-- blank")

local menu_overrides = {
	"help_keyboardmouse.png",
	"help_gamepad360.png",
	"noita_logo.png",
}

for _,sprite in ipairs(menu_overrides) do
	ImageReplace("data/ui_gfx/pause_menu/" .. sprite, "mods/noita.fairmod/files/content/data_overrides/pause_menu/" .. sprite)
end