perk_list[#perk_list+1] = {
		id = "MINUS_LIFE",
		ui_name = "Minus Life",
		ui_description = "Hey what does this do?",
		ui_icon = "mods/noita.fairmod/files/ui_gfx/perk_icons/minus_life.png",
		perk_icon = "mods/noita.fairmod/files/items_gfx/perks/minus_life.png",
		one_off_effect = true,
		do_not_remove = true,
		stackable = STACKABLE_YES,
		stackable_is_rare = true,
		func = function( entity_perk_item, entity_who_picked, item_name )
			add_halo_level(entity_who_picked, -1)

			for _, child in ipairs(EntityGetAllChildren(entity_who_picked) or {}) do
				local game_effect = EntityGetFirstComponent(child, "GameEffectComponent")
				if game_effect and ComponentGetValue2(game_effect, "effect") == "RESPAWN" then
					local counter = ComponentGetValue2(game_effect, "mCounter")
					if counter == 0 then
						-- This counts as spending the extra life and will cause the ui icon to be updated
						ComponentSetValue2(game_effect, "mCounter", counter + 1)
						return
					end
				end
			end

			-- Didn't find a RESPAWN game effect. Time to die
			EntityInflictDamage(entity_who_picked, 99999999, "DAMAGE_CURSE", "Minus Life", "BLOOD_EXPLOSION", 0, 0)

			local damage_model = EntityGetFirstComponent(entity_who_picked, "DamageModelComponent")
			if not damage_model or ComponentGetValue2(damage_model, "hp") > 0 then
				-- EntityInflictDamage didn't work for whatever reason. Could be
				-- due to any number of things (Saving Grace, Ambrosia, Stainless Armour)
				-- Just EntityKill them instead.
				EntityKill(entity_who_picked)
			end
		end,
}
