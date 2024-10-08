dofile_once( "data/scripts/lib/utilities.lua" )

function collision_trigger(colliding_entity_id)
	print("this should fucking trigger??")
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	SetRandomSeed( x, y )
	
	GamePrint("collision_trigger!")
	GamePrint(tostring(colliding_entity_id))

	if(EntityHasTag(colliding_entity_id, "player_unit") or EntityHasTag(colliding_entity_id, "polymorphed_player"))then
		shoot_projectile( entity_id, "mods/noita.fairmod/files/content/stalactite/stalactite_projectile.xml", x + 7, y + 49 + 5 , 0, 250, false )
		EntityKill(entity_id)
	end
end