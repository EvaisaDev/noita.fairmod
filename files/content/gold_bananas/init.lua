dofile_once("mods/noita.fairmod/files/utils/utilities.lua")

---@type nxml
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")

ModMaterialsFileAdd("mods/noita.fairmod/files/content/gold_bananas/materials.xml")

local nuggets = {
	{ "data/entities/items/pickup/goldnugget.xml", 0.13 },
	{ "data/entities/items/pickup/goldnugget_10.xml", 0.13 },
	{ "data/entities/items/pickup/goldnugget_50.xml", 0.19 },
	{ "data/entities/items/pickup/goldnugget_200.xml", 0.26 },
	{ "data/entities/items/pickup/goldnugget_1000.xml", 0.43 },
}

local particles = {
	"data/entities/particles/gold_pickup.xml",
	"data/entities/particles/gold_pickup_large.xml",
	"data/entities/particles/gold_pickup_huge.xml",
}

for _, file in ipairs(particles) do
	for content in nxml.edit_file(file) do
		content:first_of("AudioComponent"):set("file", "mods/noita.fairmod/fairmod.bank"):set("event_root", "pickbanana")
	end
end
for _, file in ipairs(nuggets) do
	for content in nxml.edit_file(file[1]) do
		content:add_child(nxml.new_element("SpriteComponent", {
			_tags = "enabled_in_world",
			offset_x = "0",
			offset_y = "0",
			image_file = "mods/noita.fairmod/files/content/gold_bananas/sprites/bananas.xml",
			has_special_scale = "1",
			special_scale_x = tostring(file[2]),
			special_scale_y = tostring(file[2]),
		}))
		content:first_of("PhysicsImageShapeComponent"):set("material", "gold_invisible_box2d")
	end
end


local sprites = {
	"goldnugget_01.png",
	"goldnugget_6px.png",
	"goldnugget_9px.png",
	"goldnugget_12px.png",
	"goldnugget_20px.png",
}

--we set opacity to 1 cuz idk the game crashes if its 0, maybe to do with material shader junk with the normal map
--probably cuz the hitbox is generated from the sprite, so it gets fucky if it creates an invalid hitbox?
for _,sprite in ipairs(sprites) do
	ImageSetOpacity("data/items_gfx/" .. sprite, 1)
end