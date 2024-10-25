
function collision_trigger(colliding_entity_id)
	local x, y = EntityGetTransform(GetUpdatedEntityID())

	EntityLoad("data/entities/props/physics/minecart.xml", x - 210, y - 240)
end
