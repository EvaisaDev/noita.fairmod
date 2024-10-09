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
			EntityInflictDamage(entity_who_picked, 99999, "DAMAGE_CURSE", "Minus Life", "BLOOD_EXPLOSION", 0, 0)
		end,
}
