dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, message, entity_thats_responsible )
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( GetUpdatedEntityID() )

	edit_component( entity_id, "HitboxComponent", function(comp,vars)
		ComponentSetValue2( comp, "damage_multiplier", 0.0 )
	end)

	local children = EntityGetAllChildren( entity_id ) or {}
	for a,b in ipairs( children ) do
		local effectname = EntityGetName( b )

		if ( effectname == "boss_pit_invincible" ) then
			local effectcomp = EntityGetFirstComponentIncludingDisabled( b, "GameEffectComponent")
			EntitySetComponentIsEnabled( entity_id, effectcomp, true)
			break
		end
	end
	
	EntitySetComponentsWithTagEnabled( entity_id, "invincible", true )

	SetRandomSeed( x, y * GameGetFrameNum() )

	local dmgcomp = EntityGetFirstComponentIncludingDisabled(entity_id,"DamageModelComponent")
	local max_health = ComponentGetValue2( dmgcomp, "max_hp")
	local health = ComponentGetValue2( dmgcomp, "hp")

	local phase = 0
	local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
	if ( comps ~= nil ) then
		for i,v in ipairs( comps ) do
			local n = ComponentGetValue2( v, "name" )
			if ( n == "state" ) then
				phase = tonumber(ComponentGetValue2( v, "value_string" )) or 0
			end
		end
	end

	if phase == 0 and ((max_health * 0.5) >= health) then
		local storages = EntityGetComponentIncludingDisabled( entity_id, "VariableStorageComponent" )[1]
		ComponentSetValue2( storages, "value_string", "1")

		local cid = EntityLoad( "data/entities/animals/boss_pit/gun_barrage_super_setup.xml", x, y )
		EntityAddChild( entity_id, cid )
		GamePlaySound("mods/noita.fairmod/fairmod.bank", "squiwart/americano_super", x, y)
	end

	if EntityHasTag(entity_thats_responsible,"projectile") then
		entity_thats_responsible = EntityGetClosestWithTag( x, y, "player_unit")
	end
	
	if ( Random( 1, 3 ) == 1 ) then
		local p = ""
		local cheesy = false
		if ( comps ~= nil ) then
			for i,v in ipairs( comps ) do
				local n = ComponentGetValue2( v, "name" )
				if ( n == "state" ) then
					state = ComponentGetValue2( v, "value_int" )
					
					state = (state + 1) % 10
					
					ComponentSetValue2( v, "value_int", state )
				elseif ( n == "memory" ) then
					p = ComponentGetValue2( v, "value_string" )
					cheesy = ComponentGetValue2( v, "value_bool" )
					
					if ( #p == 0 ) then
						p = "data/entities/projectiles/enlightened_laser_darkbeam.xml"
						ComponentSetValue2( v, "value_string", p )
					end 
					if cheesy then
						--Insult to injury :)
						if EntityGetWithTag("player_unit") ~= nil then
							entity_thats_responsible = EntityGetClosestWithTag( x, y, "player_unit")
							local amount = Random(4,7)
							EntityAddComponent(entity_id, "LuaComponent", {
								script_source_file="data/entities/animals/boss_pit/wand_plasma_barrage.lua",
								execute_every_n_frame=10,
								execute_times=amount
							}) 
						end
					end
				end
			end
		end
		
		if ( #p > 0 ) then
			local angle = Random( 1, 200 ) * math.pi
			local distance = 200
			if EntityHasTag(entity_thats_responsible,"mortal") then
				local t_x, t_y = EntityGetTransform( entity_thats_responsible )
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
		end
	end
end