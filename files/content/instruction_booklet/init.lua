local player = EntityGetWithTag("player_unit")[1]
x, y = EntityGetTransform(player)

local entity = EntityLoad("mods/noita.fairmod/files/content/instruction_booklet/booklet_entity/booklet.xml", x, y)

GamePickUpInventoryItem(player, entity, false)
