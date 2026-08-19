---@param x number
---@param y number
---@return entity_id|nil
local function spawn_random_cart(x, y)
	local rnd = Randomf(1, 100)
	local cart_file = "data/entities/props/physics/minecart.xml"
	if rnd <= 4 then
		cart_file = "data/entities/projectiles/bomb_cart.xml"
	end
	EntityLoad(cart_file, x, y)
end

function collision_trigger(colliding_entity_id)
	local x, y = EntityGetTransform(GetUpdatedEntityID())

	local player_x, player_y = EntityGetTransform(colliding_entity_id)
	SetRandomSeed(player_x + colliding_entity_id, player_y + GameGetFrameNum())

	local spawn_x = math.min(math.max(x - 220, player_x), x + 220)

	local rnd = Randomf(1, 100)
	if rnd <= 2 then
		for _=1,6 do
			spawn_random_cart(spawn_x + Random(-20, 20), player_y - 240 + Random(-20, 40))
		end
	else
		spawn_random_cart(spawn_x, player_y - 240)
	end
end
