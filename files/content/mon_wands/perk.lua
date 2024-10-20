perk_list[#perk_list + 1] = {
	id = "MONSTER_WANDS",
	ui_name = "Armed Targets",
	ui_description = "Huh",
	ui_icon = "mods/noita.fairmod/files/content/monster_wands/ui_icon.png",
	perk_icon = "mods/noita.fairmod/files/content/monster_wands/perk_icon.png",
	one_off_effect = true,
	do_not_remove = true,
	stackable_is_rare = true,
	stackable = false,
	func = function(entity_perk_item, entity_who_picked, item_name)
		GameAddFlagRun("fairmod_perks_monster_wands")
		local enemies = EntityGetWithTag("enemy")
		for i = 1, #enemies do
			local victim = enemies[i]
			local picker = EntityGetFirstComponentIncludingDisabled(victim, "ItemPickUpperComponent")
			if picker ~= nil then
				local has_wand = false
				local invs = EntityGetAllChildren(victim) or {}
				for j = 1, #invs do
					if EntityGetName(invs[j]) == "inventory_quick" then
						local items = EntityGetAllChildren(invs[j]) or {}
						for k = 1, #items do
							if EntityHasTag(items[k], "wand") then
								has_wand = true
								break
							end
						end
						break
					end
				end

				if not has_wand then
					local x, y = EntityGetTransform(victim)
					local file = table.concat({
						"data/scripts/streaming_integration/entities/wand_level_0",
						tostring(math.random(1, 3)),
						".xml",
					})
					local wand = EntityLoad(file, x, y)
					GamePickUpInventoryItem(victim, wand, false)
					-- Set 50% drop chance
					local drop = false
					if math.random(0, 1) == 1 then drop = true end
					ComponentSetValue2(picker, "drop_items_on_death", drop)
				end
			end
		end
	end,
	func_remove = function(entity_who_picked)
		GameRemoveFlagRun("fairmod_perks_monster_wands")
		local enemies = EntityGetWithTag("enemy")
		for i = 1, #enemies do
			local victim = enemies[i]
			local picker = EntityGetFirstComponentIncludingDisabled(victim, "ItemPickUpperComponent")
			if picker ~= nil then
				local has_wand = false
				local invs = EntityGetAllChildren(victim) or {}
				for j = 1, #invs do
					if EntityGetName(invs[j]) == "inventory_quick" then
						local items = EntityGetAllChildren(invs[j]) or {}
						for k = 1, #items do
							if EntityHasTag(items[k], "wand") then
								EntityKill(items[k])
								break
							end
						end
						break
					end
				end
			end
		end
	end,
}
