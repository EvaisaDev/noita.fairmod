dofile_once( "data/scripts/lib/utilities.lua" )

local last_trigger = -12352

function collision_trigger(colliding_entity_id)
	if(GameGetFrameNum() - last_trigger < 60)then
		return
	end

	last_trigger = GameGetFrameNum()

	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	local collider_x, collider_y = EntityGetTransform( colliding_entity_id )

	SetRandomSeed(x + collider_x, y + collider_y + GameGetFrameNum())

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
	if(EntityHasTag(colliding_entity_id, "player_unit") or EntityHasTag(colliding_entity_id, "polymorphed_player"))then
		GamePrint("triggered")
		if(Random(1, 100) < 40)then
			
			local entity = shoot_projectile( entity_id, projectile, x, y + offset_y + 2 , 0, 300, false )

			EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/misc/poof.xml", x, y)

			local physics_body_component = EntityGetFirstComponent( entity, "PhysicsBodyComponent" )

			if physics_body_component ~= nil then
				local x, y, angle, vel_x, vel_y, angular_vel = PhysicsComponentGetTransform( physics_body_component )
				PhysicsComponentSetTransform( physics_body_component, x, y, angle, 0, 25, angular_vel )
			end

			EntityKill(entity_id)
		end
	end
end