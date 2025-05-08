--- Hellish creature if killed by player
--- @type script_death
local script_death = function(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
	local x,y = EntityGetTransform(GetUpdatedEntityID())
    EntityLoad("mods/noita.fairmod/files/content/enemy_reworks/hamis_reworked/pandorium_potion.xml", x, y)
end
death = script_death