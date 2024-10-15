function material_area_checker_success( pos_x, pos_y )
	local midas_id = EntityLoad( "mods/noita.fairmod/files/content/cauldron/convert_poop.xml", pos_x, pos_y )

	local player_id = EntityGetWithTag( "player_unit" )
			
	if ( #player_id > 0 ) then
		
		local comp_damagemodel = EntityGetFirstComponent( player_id[1], "DamageModelComponent" )
		if( comp_damagemodel ~= nil ) then
			ComponentSetValue( comp_damagemodel, "materials_damage_proportional_to_maxhp", "1" )
		end

		EntityAddChild( player_id[1], midas_id )
	end


	local x, y = pos_x, pos_y

	EntityLoad( "data/entities/animals/boss_centipede/ending/midas_sand.xml", x, y )
	EntityLoad( "data/entities/animals/boss_centipede/ending/midas_chunks.xml", x, y )
	GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/midas_above/create", x, y )

	EntityLoad( "mods/noita.fairmod/files/content/cauldron/player_killer.xml", x, y )
	
	GameAddFlagRun( "ending_game_completed" )

	local world_entity_id = GameGetWorldStateEntity()
	if( world_entity_id ~= nil ) then
		local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )
		if( comp_worldstate ~= nil ) then
			ComponentSetValue( comp_worldstate, "INFINITE_GOLD_HAPPENING", "1" )
		end
	end

end