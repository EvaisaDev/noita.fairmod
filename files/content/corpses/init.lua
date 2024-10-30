local corpses = {}

function corpses.OnPlayerDied(player)
	local x, y = EntityGetTransform(player)
	local xy_str = tostring(x) .. "," .. tostring(y)

	local deaths = ModSettingGet("fairmod.death_locations") or ""
	ModSettingSet("fairmod.death_locations", deaths .. ";" .. xy_str)
end

function corpses.OnPlayerSpawned(player)
	local deaths = ModSettingGet("fairmod.death_locations") or ""
	for x, y in string.gmatch(deaths, "([%d.-]+),([%d.-]+)") do
		EntityLoad("mods/noita.fairmod/files/content/corpses/corpse_loader.xml", tonumber(x), tonumber(y))
	end
end

return corpses
