dofile_once( "data/scripts/lib/utilities.lua" )

function collision_trigger(colliding_entity_id)
	print("this should fucking trigger??")
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	SetRandomSeed( x, y )
	
	GamePrint("collision_trigger!")
	GamePrint(tostring(colliding_entity_id))

	if(EntityHasTag(colliding_entity_id, "player_unit") or EntityHasTag(colliding_entity_id, "polymorphed_player"))then
		local entity = shoot_projectile( entity_id, "mods/noita.fairmod/files/content/stalactite/stalactite_projectile.xml", x + 3, y + 40 + 2 , 0, 300, false )

		PhysicsApplyForce(entity, 0, 5000)

		EntityKill(entity_id)
	end
end