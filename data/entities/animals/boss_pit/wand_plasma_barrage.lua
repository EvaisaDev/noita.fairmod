dofile_once("data/scripts/lib/utilities.lua")

	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( GetUpdatedEntityID() )

	local player_id = EntityGetClosestWithTag( x, y, "player_unit")
	
	SetRandomSeed( x, y * GameGetFrameNum() )
	
		local p = "data/entities/projectiles/deck/orb_laseremitter.xml"

			local angle = Random( 1, 200 ) * math.pi
			local distance = 200
			if EntityHasTag(player_id,"mortal") then
				local t_x, t_y = EntityGetTransform( player_id )
				local dist_x = t_x - x
				local dist_y = t_y - y
				angle = math.atan2(dist_y, dist_x)
				distance = get_magnitude(dist_x, dist_y) * 1.5
			end
			local vel_x = math.cos( angle ) * distance
			local vel_y = math.sin( angle ) * distance
			local spawn_distance = 25
			local w_x = x + (math.cos( angle ) * spawn_distance)
			local w_y = y + (math.sin( angle ) * spawn_distance)
			
			local wid = shoot_projectile( entity_id, "data/entities/animals/boss_pit/wand.xml", w_x, w_y, vel_x, vel_y )
			EntitySetName( wid, "boss_pit_damage_wand")
			edit_component( wid, "VelocityComponent", function(comp,vars)
				ComponentSetValue2( comp, "air_friction", 1 )
			end)
			edit_component( wid, "VariableStorageComponent", function(comp,vars)
				ComponentSetValue2( comp, "value_string", p )
			end)