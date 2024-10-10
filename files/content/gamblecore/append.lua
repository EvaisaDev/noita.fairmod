for k, v in ipairs(perk_list)do
	if(v.id == "PERKS_LOTTERY")then
		local old_func = v.func
		v.func = function(entity_perk_item, entity_who_picked, item_name)
			GamePlaySound("mods/noita.fairmod/fairmod.bank", "gamblecore/letsgogambling", 0, 0)
			old_func(entity_perk_item, entity_who_picked, item_name)
		end
	end
end