local boss = GetUpdatedEntityID()

if not EntityHasTag( boss,"boss_centipede_active" ) and GameHasFlagRun("sampo_picked") then
	EntitySetComponentsWithTagEnabled( boss, "disabled_at_start", true )
	EntitySetComponentsWithTagEnabled( boss, "enabled_at_start", false )
	PhysicsSetStatic( boss, false )
	
	local sampo_spot = EntityGetWithTag( "ending_sampo_spot_underground" )

	if(sampo_spot ~= nil)then
		for k, v in ipairs(sampo_spot)do
			EntityRemoveTag( v, "ending_sampo_spot_underground" )

			EntityAddComponent2( v, "LuaComponent", {
				script_source_file="mods/noita.fairmod/files/content/kolmi_not_home/check_kolmi_death.lua",
				execute_on_added=true,
				execute_every_n_frame=1,
				execute_times=-1,
			})
		end
	end

	if EntityHasTag( boss, "boss_centipede" ) then
		EntityAddTag( boss, "boss_centipede_active" )
		
		local child_entities = EntityGetAllChildren( boss )
		local child_to_remove = 0
		
		if ( child_entities ~= nil ) then
			for i,child_id in ipairs( child_entities ) do
				-- fix
				if EntityHasTag( child_id, "protection" ) then
					child_to_remove = child_id
				end
			end
		end
		
		if ( child_to_remove ~= 0 ) then
			EntityKill( child_to_remove )
		end
	end
end