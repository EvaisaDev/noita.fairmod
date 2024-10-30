dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage )
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( GetUpdatedEntityID() )

	edit_component( entity_id, "HitboxComponent", function(comp,vars)
		ComponentSetValue2( comp, "damage_multiplier", 0.0 )
	end)
	
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
	
	if ( Random( 1, 3 ) == 1 ) then
		local p = ""
		if ( comps ~= nil ) then
			for i,v in ipairs( comps ) do
				local n = ComponentGetValue2( v, "name" )
				if ( n == "state" ) then
					state = ComponentGetValue2( v, "value_int" )
					
					state = (state + 1) % 10
					
					ComponentSetValue2( v, "value_int", state )
				elseif ( n == "memory" ) then
					p = ComponentGetValue2( v, "value_string" )
					
					if ( #p == 0 ) then
						p = "data/entities/projectiles/enlightened_laser_darkbeam.xml"
						ComponentSetValue2( v, "value_string", p )
					end
				end
			end
		end
		
		if ( #p > 0 ) then
			local angle = Random( 1, 200 ) * math.pi
			local vel_x = math.cos( angle ) * 100
			local vel_y = 0 - math.cos( angle ) * 100
			
			local wid = shoot_projectile( entity_id, "data/entities/animals/boss_pit/wand.xml", x, y, vel_x, vel_y )
			edit_component( wid, "VariableStorageComponent", function(comp,vars)
				ComponentSetValue2( comp, "value_string", p )
			end)
		end
	end
end