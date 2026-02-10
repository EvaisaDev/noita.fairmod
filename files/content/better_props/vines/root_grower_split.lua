local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)

-- Anti-lag, since these things can multiply a lot we don't want to have too many in one spot
for _, e in ipairs(EntityGetInRadiusWithTag(pos_x, pos_y, 25, "root")) do
	if e ~= entity_id then
		EntityKill(entity_id)
		return
	end
end

local r = ProceduralRandomf(pos_x, pos_y + GameGetFrameNum())
if r < 0.1 then
	-- spawn another big branch (rare)
	-- offset randomly for more efficient initial spread
	pos_x = pos_x + ProceduralRandomf(pos_x - 12, pos_y, -3, 3)
	pos_y = pos_y + ProceduralRandomf(pos_x, pos_y + 54, -3, 3)
	EntityLoad("data/entities/props/root_grower.xml", pos_x, pos_y)
	return
elseif r < 0.8 then
	-- regular small branch
	pos_x = pos_x + ProceduralRandomf(pos_x - 7, pos_y, -3, 3)
	pos_y = pos_y + ProceduralRandomf(pos_x, pos_y, -3, 3)
	EntityLoad("data/entities/props/root_grower_branch.xml", pos_x, pos_y)
	return
end
