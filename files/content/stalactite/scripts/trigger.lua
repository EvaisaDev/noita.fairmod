dofile_once( "data/scripts/lib/utilities.lua" )

function collision_trigger(colliding_entity_id)
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	local variable_storage_comps = EntityGetComponent( entity_id, "VariableStorageComponent" )

	local offset_x = 0
	local offset_y = 0
	local projectile = ""

	if ( variable_storage_comps ~= nil ) then
		for key,comp_id in pairs( variable_storage_comps ) do 
			local name = ComponentGetValue2( comp_id, "name" )
			if( name == "offset_x" ) then
				offset_x = ComponentGetValue2( comp_id, "value_int" )
			elseif( name == "offset_y" ) then
				offset_y = ComponentGetValue2( comp_id, "value_int" )
			elseif( name == "projectile" ) then
				projectile = ComponentGetValue2( comp_id, "value_string" )
			end
		end
	end

	SetRandomSeed( x, y )

	if(EntityHasTag(colliding_entity_id, "player_unit") or EntityHasTag(colliding_entity_id, "polymorphed_player"))then
		local entity = shoot_projectile( entity_id, projectile, x, y + offset_y + 2 , 0, 300, false )

		EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/misc/poof.xml", x, y)

		PhysicsApplyForce(entity, 0, 3000)

		EntityKill(entity_id)
	end
end