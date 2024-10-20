---@type script_damage_about_to_be_received
function damage_about_to_be_received(damage, x, y, entity_thats_responsible, critical_hit_chance)
	local crit_mult = 1
	SetRandomSeed((x * GameGetFrameNum()) % 25781423, y + GameGetFrameNum())
	while Random(1, 20) == 1 do
		--GamePrint("Got Crit!")
		crit_mult = crit_mult * 5
		if crit_mult >= 125 then GameAddFlagRun("giga_critted_lol") end
	end
	return damage * crit_mult, critical_hit_chance
end
