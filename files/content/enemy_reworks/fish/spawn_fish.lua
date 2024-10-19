--- @diagnostic disable: lowercase-global
function spawn_fish(x, y)
	local f = GameGetOrbCountAllTime()

	local hm_visits = tonumber(GlobalsGetValue("HOLY_MOUNTAIN_VISITS", "0")) or 0
	SetRandomSeed(x + hm_visits, y + f)

	for _ = 1, f do
		if Random(hm_visits, 50) >= 49 then
			local e = EntityLoad("mods/noita.fairmod/files/content/enemy_reworks/fish/fish.xml", x, y)
			local dmc = EntityGetFirstComponent(e, "DamageModelComponent")
			if not dmc then return end
			local hp = hm_visits / 2 + 0.1
			ComponentSetValue2(dmc, "max_hp", hp)
			ComponentSetValue2(dmc, "hp", hp)
		else
			EntityLoad("data/entities/animals/fish.xml", x, y)
		end
	end
end
