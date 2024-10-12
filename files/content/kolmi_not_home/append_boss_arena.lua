local original_spawn_items = spawn_items

function spawn_items( x, y ) 
	
	if(Random(1, 100) <= 20)then
		EntityLoad( "mods/noita.fairmod/files/content/kolmi_not_home/boss_longleg.xml",x - 40, y )
		-- if game is not completed
		if( GameHasFlagRun( "ending_game_completed" ) == false ) then
			local sampo = EntityLoad( "data/entities/animals/boss_centipede/sampo.xml", x, y + 80 )
			
			local lua_components = EntityGetComponent( sampo, "LuaComponent" )
			if( lua_components ~= nil ) then
				for i,component in ipairs(lua_components) do
					local script = ComponentGetValue( component, "script_item_picked_up" )
					if( script == "data/entities/animals/boss_centipede/sampo_pickup.lua" ) then
						ComponentSetValue2( component, "script_item_picked_up", "mods/noita.fairmod/files/content/kolmi_not_home/sampo_pickup.lua" )
					end
				end
			end
		end
		
		EntityLoad( "data/entities/animals/boss_centipede/reference_point.xml", x, y )
	else
		original_spawn_items(x, y)
	end
end
