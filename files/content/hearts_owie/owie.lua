---@diagnostic disable-next-line: undefined-global
local _item_pickup = item_pickup
---@diagnostic disable-next-line: lowercase-global
item_pickup = function(...)
	local heart = ({ ... })[1]
	local prey = ({ ... })[2]
	if EntityHasTag(prey, "player_unit") then
		EntityInflictDamage(prey, 0.2, "DAMAGE_CURSE", "heart mimic", "DISINTEGRATED", 0, -1000, heart)
	end
	_item_pickup(...)
end
