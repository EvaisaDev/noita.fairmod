perk_list[#perk_list + 1] = {
	id = "LOST_IN_PORTALS",
	ui_name = "Directionally Challenged",
	ui_description = "It was the first portal on the left.. right?",
	ui_icon = "mods/noita.fairmod/files/content/funky_portals/ui_icon.png",
	perk_icon = "mods/noita.fairmod/files/content/funky_portals/perk_icon.png",
	one_off_effect = true,
	do_not_remove = true,
	stackable = false,
	func = function(entity_perk_item, entity_who_picked, item_name)
		GameAddFlagRun("always_lost")
	end,
	func_remove = function(entity_perk_item, entity_who_picked, item_name)
		GameRemoveFlagRun("always_lost")
	end,
}
