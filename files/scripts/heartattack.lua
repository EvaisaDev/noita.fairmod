local malice = {
		OnPlayerSpawned = function(player_entity)
		-- synchronize death watches
		local lcs = EntityGetComponentIncludingDisabled(player_entity, "LuaComponent", "glue_NOT") or {}
		for i=1, #lcs do if ComponentGetValue2(lcs[i], "script_source_file") == "mods/noita.fairmod/files/scripts/heartattack2.lua" then return end end
		local comp = EntityAddComponent2(player_entity, "LuaComponent", {
			execute_every_n_frame=1,
			script_source_file = "mods/noita.fairmod/files/scripts/heartattack2.lua"
		})
		ComponentAddTag(comp, "glue_NOT")
	end
}

return malice