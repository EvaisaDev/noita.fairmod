dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/lib/coroutines.lua")

local function get_player_pos()
	local players = EntityGetWithTag( "player_unit" )
	if(players == nil)then return nil end
	return EntityGetTransform( players[1] )
end


async(function ()
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	GamePrintImportant( "$log_beam_stone")
	GameEntityPlaySound( entity_id, "beam_from_sky_start" )

	-- get player nearby
	local players = EntityGetInRadiusWithTag( pos_x, pos_y, 480, "player_unit" )

	if players and #players > 0 then
		local player = players[1]

		LoadGameEffectEntityTo(player, "mods/noita.fairmod/files/content/worse_items/stun_effect.xml")
	end
	
	--[[wait( 60 )

	GameScreenshake( 10 )
	wait( 20 )
	GameScreenshake( 20 )
	wait( 20 )
	GameScreenshake( 30 )
	wait( 20 )
	
	GameScreenshake( 40 )
	wait( 20 )
	GameScreenshake( 60 )
	wait( 20 )
	GameScreenshake( 100 )
	wait( 20 )]]

	local function Lerp( a, b, t )
		return (1 - t) * a + t * b
	end

	local timer = 0
	local curr_x, curr_y = pos_x, pos_y
	local screenshake = 0
	while timer < 180 do
		timer = timer + 1


		local player_x, player_y = get_player_pos()
		if(player_x == nil)then
			break
		end

		-- lerp towards position
		curr_x = Lerp( curr_x, player_x, 0.03 )
		curr_y = Lerp( curr_y, player_y, 0.03 )

		if(timer > 60 and timer % 10 == 0)then
			screenshake = screenshake + 10
			GameScreenshake( screenshake )
		end
		
		EntityApplyTransform( entity_id, curr_x, curr_y )

		wait( 1 )
	end

	pos_x, pos_y = EntityGetTransform( entity_id )

	GameCutThroughWorldVertical( pos_x, -2147483647, pos_y, 40, 40 )
	EntitySetComponentsWithTagEnabled( entity_id, "enabled_in_world", true )
	GamePlaySound( "data/audio/Desktop/misc.bank", "misc/beam_from_sky_hit", pos_x, pos_y )
	GameScreenshake( 200 )
    EntityLoad( "data/entities/particles/poof_green_huge.xml", pos_x, pos_y-5 )
	component_write( EntityGetFirstComponent( entity_id, "ParticleEmitterComponent"), { count_min=21000, count_max=21000, cosmetic_force_create=true } ) 
	
	local area_damage_comp = EntityGetFirstComponent( entity_id, "AreaDamageComponent" )



	-- disable all particle emitters
	local particle_emitters = EntityGetComponent( entity_id, "ParticleEmitterComponent" )
	if(particle_emitters ~= nil)then
		for i,emitter in ipairs(particle_emitters) do
			EntitySetComponentIsEnabled( entity_id, emitter, false )
		end
	end

	wait( 15)

	local players = EntityGetInRadiusWithTag( pos_x, pos_y, 512, "player_unit" ) or {}
	if(#players <= 0)then
		print("no players nearby")
		EntityKill( entity_id )
		return
	end
	
	EntitySetComponentIsEnabled( entity_id, area_damage_comp, false )

	wait( 150 )

	
	local players = EntityGetInRadiusWithTag( pos_x, pos_y, 512, "player_unit" ) or {}
	if(#players <= 0)then
		print("no players nearby")
		EntityKill( entity_id )
		return
	end

	component_write( EntityGetFirstComponent( entity_id, "ParticleEmitterComponent"), { count_min=100, count_max=200 } ) 
	if(particle_emitters ~= nil)then
		for i,emitter in ipairs(particle_emitters) do
			EntitySetComponentIsEnabled( entity_id, emitter, true )
			if(ComponentGetValue2( emitter, "emitted_material_name") ~= "spark_white")then
				ComponentSetValue2( emitter, "x_pos_offset_min", -200)
				ComponentSetValue2( emitter, "x_pos_offset_max", 200)
				-- set color to red
				ComponentSetValue2( emitter, "emitted_material_name", "spark_red")
			end
			ComponentSetValue2( emitter, "y_pos_offset_max", 4048)
		end
	end

	GameScreenshake( 10 )
	wait( 20 )
	GameScreenshake( 20 )
	wait( 20 )
	GameScreenshake( 30 )
	wait( 20 )
	GameScreenshake( 40 )
	wait( 20 )
	GameScreenshake( 60 )
	wait( 20 )
	GameScreenshake( 100 )
	wait( 20 )
	EntitySetComponentIsEnabled( entity_id, area_damage_comp, true )
	--[[
		if(entity.children[i]:get("x_pos_offset_min") == "-40")then
			entity.children[i]:set("x_pos_offset_min", "-200")
		end
		if(entity.children[i]:get("x_pos_offset_max") == "40")then
			entity.children[i]:set("x_pos_offset_max", "200")
		end
		if(entity.children[i]:get("y_pos_offset_max") == "1")then
			entity.children[i]:set("y_pos_offset_max", 512*3)
		end]]

	--[[local charge = entity:first_of("AreaDamageComponent")
	if(charge)then
		charge:set("aabb_min.x", "-200")
		charge:set("aabb_max.x", "200")
		charge:set("aabb_max.y", 512*3)
	end]]

	GameCutThroughWorldVertical( pos_x, -2147483647, 2147483647, 200, 200 )
	EntitySetComponentsWithTagEnabled( entity_id, "enabled_in_world", true )
	GamePlaySound( "data/audio/Desktop/misc.bank", "misc/beam_from_sky_hit", pos_x, pos_y )
	GameScreenshake( 400 )
    EntityLoad( "mods/noita.fairmod/files/content/worse_items/poof_red_huge.xml", pos_x, pos_y-5 )
	component_write( EntityGetFirstComponent( entity_id, "ParticleEmitterComponent"), { x_pos_offset_min=-200, x_pos_offset_max=200, y_pos_offset_max=2048, cosmetic_force_create=true } ) 

	ComponentSetValue2( area_damage_comp, "aabb_min", -200, -2048)
	ComponentSetValue2( area_damage_comp, "aabb_max", 200, 4048)
end)