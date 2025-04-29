--- Hellish creature if killed by player
--- @type script_death
local script_death = function(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
	EntityKill(GameGetWorldStateEntity())
end
death = script_death