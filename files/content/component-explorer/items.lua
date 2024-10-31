local fairmod_items = {
	{
		file = "mods/noita.fairmod/files/content/fishing/files/rod/default_rod.xml",
		item_name = "Old Fishing Rod",
		tags = "fishing_rod,GUN",
	},
	{
		file = "mods/noita.fairmod/files/content/immortal_snail/gun/entities/items/glock.xml",
		item_name = "Käsiase",
		tags = "teleportable_NOT,item,wand",
	},
	{
		file = "mods/noita.fairmod/files/content/instruction_booklet/booklet_entity/booklet.xml",
		item_name = "$fairmod_booklet_name",
		tags = "item_physics,item_pickup",
	},
	{
		file = "mods/noita.fairmod/files/content/payphone/entities/corrupted_wands/wand_level_01.xml",
		tags = "teleportable_NOT,item,wand",
	},
	{
		file = "mods/noita.fairmod/files/content/payphone/entities/corrupted_wands/wand_level_02.xml",
		tags = "teleportable_NOT,item,wand",
	},
	{
		file = "mods/noita.fairmod/files/content/payphone/entities/corrupted_wands/wand_level_03.xml",
		tags = "teleportable_NOT,item,wand",
	},
	{
		file = "mods/noita.fairmod/files/content/payphone/entities/corrupted_wands/wand_level_04.xml",
		tags = "teleportable_NOT,item,wand",
	},
	{
		file = "mods/noita.fairmod/files/content/payphone/entities/corrupted_wands/wand_level_05.xml",
		tags = "teleportable_NOT,item,wand",
	},
	{
		file = "mods/noita.fairmod/files/content/payphone/entities/corrupted_wands/wand_level_06.xml",
		tags = "teleportable_NOT,item,wand",
	},
	{
		file = "mods/noita.fairmod/files/content/rat_wand/rat_wand.xml",
		item_name = "$fairmod_rat_wand",
		tags = "teleportable_NOT,item,wand",
	},
	{
		file = "mods/noita.fairmod/files/content/snowman/snowball_item.xml",
		item_name = "Snowball",
		tags = "hittable,teleportable_NOT,item_physics,item_pickup",
	},
	{
		file = "mods/noita.fairmod/files/content/teleporter_item/item.xml",
		item_name = "Teleporter",
		tags = "item",
	},
}

local items = dofile_once("mods/component-explorer/spawn_data/items.lua")

for _, fi in ipairs(fairmod_items) do
	fi.origin = "noita.fairmod"
	items[#items + 1] = fi
end
