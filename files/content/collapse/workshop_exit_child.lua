
local old_GetUpdatedEntityID = GetUpdatedEntityID
GetUpdatedEntityID = function()
	return EntityGetParent(old_GetUpdatedEntityID())
end

dofile("data/scripts/buildings/workshop_exit.lua")
