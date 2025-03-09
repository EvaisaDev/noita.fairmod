dofile_once("data/scripts/lib/utilities.lua")

function shot( entity_id )

	if(EntityHasTag(entity_id, "no_fucky_wucky"))then
		return
	end

	edit_component( entity_id, "ProjectileComponent", function(comp,vars)
		ComponentSetValue2( comp, "friendly_fire", true )
		ComponentSetValue2( comp, "collide_with_shooter_frames", 6 )
	end)
	
	if ( EntityHasTag( entity_id, "friendly_fire_enabled" ) == false ) then
		EntityAddTag( entity_id, "friendly_fire_enabled" )
	end
end