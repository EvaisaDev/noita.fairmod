perk_list[#perk_list + 1] = {
	id = "SNAIL_RADAR",
	ui_name = "Snail Radar",
	ui_description = "Be alerted when there is a snail nearby.",
	ui_icon = "mods/noita.fairmod/files/content/snail_radar/ui_icon.png",
	perk_icon = "mods/noita.fairmod/files/content/snail_radar/perk_icon.png",
	stackable = false,
	func = function(entity_perk_item, entity_who_picked, item_name)
		GameAddFlagRun("snail_radar")
	end,
	func_remove = function(entity_who_picked)
		GameRemoveFlagRun("snail_radar")
	end,
}
