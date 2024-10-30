local corpses = {}

local function get_stripped_data()
	local max_corpses = (ModSettingGet("noita.fairmod.max_corpse_count") or 0) - 1
	local current = ModSettingGet("fairmod.death_locations") or "" --[[@as string]]
	local data = ""
	local i = 1
	for x, y in current:gmatch("([%d.-]+),([%d.-]+)") do
		if i > max_corpses then break end
		i = i + 1
		data = data .. x .. "," .. y .. ";"
	end
	ModSettingSet("fairmod.death_locations", data)
	return data
end

function corpses.OnPlayerDied(player)
	local x, y = EntityGetTransform(player)
	local xy_str = tostring(x) .. "," .. tostring(y)

	local deaths = ModSettingGet("fairmod.death_locations") or ""
	ModSettingSet("fairmod.death_locations", xy_str .. ";" .. deaths)
end

function corpses.OnPlayerSpawned(player)
	local deaths = get_stripped_data()
	for x, y in string.gmatch(deaths, "([%d.-]+),([%d.-]+)") do
		EntityLoad("mods/noita.fairmod/files/content/corpses/corpse_loader.xml", tonumber(x), tonumber(y))
	end
end

return corpses
