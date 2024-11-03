function collision_trigger(colliding_entity_id)
	local x, y = EntityGetTransform(GetUpdatedEntityID())

	local col_x, col_y = EntityGetTransform(colliding_entity_id)
	local rnd = ProceduralRandomi(col_x, col_y + GameGetFrameNum(), 1, 50)

	if rnd == 1 then
		EntityLoad("data/entities/projectiles/bomb_cart.xml", x - 210, y - 240)
	else
		EntityLoad("data/entities/props/physics/minecart.xml", x - 210, y - 240)
	end
end
