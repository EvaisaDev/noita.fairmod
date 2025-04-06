
local function spawn_random_cart(x, y)
	local rnd = Randomf(1, 100)
	if rnd <= 2 then
		EntityLoad("data/entities/projectiles/bomb_cart.xml", x, y)
	else
		EntityLoad("data/entities/props/physics/minecart.xml", x, y)
	end
end

function collision_trigger(colliding_entity_id)
	local x, y = EntityGetTransform(GetUpdatedEntityID())

	local col_x, col_y = EntityGetTransform(colliding_entity_id)
	SetRandomSeed(col_x + colliding_entity_id, col_y + GameGetFrameNum())

	local rnd = Randomf(1, 100)
	if rnd <= 1.1 then
		for _=1,6 do
			spawn_random_cart(x - 210 + Random(0, 20), y - 240 + Random(-20, 40))
		end
	else
		spawn_random_cart(x - 210, y - 240)
	end

	AddFlagPersistent("fairmod_touched_minecart_trigger")
end
