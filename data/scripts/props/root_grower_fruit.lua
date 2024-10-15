local pos_x, pos_y = EntityGetTransform( GetUpdatedEntityID() )

local r = ProceduralRandomf(pos_x, pos_y + GameGetFrameNum())
if r < 0.5 then
	-- don't overlap fruits
	for _,e in ipairs(EntityGetInRadiusWithTag( pos_x, pos_y, 15, "prop" )) do
		if not EntityHasTag(e, "root") then return end
	end

	-- fruit
	local e = EntityLoad( "data/entities/props/root_grower_fruit.xml", pos_x, pos_y)
	EntitySetTransform(e, pos_x, pos_y, ProceduralRandomf(pos_x, pos_y, -math.pi * 0.5, math.pi * 0.5))
elseif r < 0.9 then
	local x = pos_x + ProceduralRandomf(pos_x-7, pos_y, -3, 3)
	local y = pos_y + ProceduralRandomf(pos_x, pos_y, -3, 3)
	EntityLoad( "data/entities/props/root_grower_branch.xml", x, y )
end