dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity = GetUpdatedEntityID()
	local x, y = EntityGetTransform(entity)

	--[[local whattodrop = {
		"data/entities/items/pickup/spell_refresh.xml",
		"data/entities/items/pickup/heart_fullhp_temple.xml",
		"data/entities/items/wand_unshuffle_06.xml",
		"data/entities/animals/fish.xml",
		"data/entities/items/pickup/goldnugget_1000.xml",
	}

	local whichone = whattodrop[math.random(1,#whattodrop)]
	EntityLoad(whichone, x, y)]]
end