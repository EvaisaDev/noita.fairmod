
local old_EntityLoad = EntityLoad
function EntityLoad(filename, pos_x, pos_y)
	local result = old_EntityLoad(filename, pos_x, pos_y)
	if result ~= nil then
		EntityAddTag(result, "fair_gold")
	end
	return result
end
