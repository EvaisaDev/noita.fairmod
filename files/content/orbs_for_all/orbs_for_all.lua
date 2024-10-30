-- Put together by ScipioWright
-- I copied Eba's fuckedupenemies file as a base, so this is me giving credit
-- and then Evaisa rewrote a lot of it, so I'm not entirely sure which parts I did anymore, oh well

local orbsbad = {}

function orbsbad:update()
	local mortals = EntityGetWithTag("mortal")
	for _, entity in ipairs(mortals) do
		if EntityHasTag(entity, "orbsfucked") or EntityHasTag(entity, "player_unit") or EntityHasTag(entity, "polymorphed_player") then
			goto continue
		end
		local dmg_comp = EntityGetFirstComponent(entity, "DamageModelComponent")
		if dmg_comp ~= nil then
			EntityAddComponent2(entity, "VariableStorageComponent", {
				name = "fairmod_orbs",
				value_int = 0
			})
			EntityAddComponent2(entity, "VariableStorageComponent", {
				name = "fairmod_max_hp",
				value_float = ComponentGetValue2(dmg_comp, "max_hp")
			})
			EntityAddComponent2(entity, "LuaComponent", {
				script_source_file = "mods/noita.fairmod/files/content/orbs_for_all/orb_health_tracker.lua",
				execute_every_n_frame = 120,
			})
		end
		EntityAddTag(entity, "orbsfucked")
		::continue::
	end
end

return orbsbad
