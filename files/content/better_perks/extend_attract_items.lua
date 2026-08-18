
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local distance_full = tonumber( GlobalsGetValue( "PERK_ATTRACT_ITEMS_RANGE", "72" ) ) * 2
local power = math.min( distance_full / 4, 20 )

local items = EntityGetWithTag("fair_gold")
for _,item_id in ipairs(items) do
	local px, py = EntityGetTransform( item_id )
	local distance_sq = (x - px) ^ 2 + (y - py) ^ 2

	if ( distance_sq < distance_full ) then
		local physicscomponents = EntityGetComponent( item_id, "PhysicsBodyComponent" )

		if ( physicscomponents ~= nil ) then
			local direction = 0 - math.atan2((y - py), (x - px))
			local vel_x = math.cos(direction) * power
			local vel_y = 0 - math.sin(direction) * power

			PhysicsApplyForce(item_id, vel_x, vel_y)
		end
	end
end
