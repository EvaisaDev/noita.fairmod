local corpses = {}


---@return string
local function get_stripped_data()
	local max_corpses = ModSettingGet("noita.fairmod.max_corpse_count2") or 0
	local current = ModSettingGet("fairmod.death_locations") or "" --[[@as string]]
	local data = {}
	local i = 1
	for xypair in current:gmatch("([^;]+)") do
		if i > max_corpses then break end
		i = i + 1
		table.insert(data, xypair)
	end

	local data_str = table.concat(data, ";")
	ModSettingSet("fairmod.death_locations", data_str)
	return data_str
end

---If a player dies in a PW the position gets converted to a main world coordinate.
---@param player int
---@return number x position
---@return number y position
local function get_corpse_position(player)
	local x, y = EntityGetTransform(player)

	local width = BiomeMapGetSize() * 512
	local pw = GetParallelWorldPosition(x, y)

	x = x - pw * width
	return x, y
end

---@param player int
function corpses.OnPlayerDied(player)
	local x, y = get_corpse_position(player)
	local xy_str = tostring(x) .. "," .. tostring(y)

	local deaths = ModSettingGet("fairmod.death_locations") or ""
	ModSettingSet("fairmod.death_locations", xy_str .. ";" .. deaths)
end

---@param player int
function corpses.OnPlayerSpawned(player)
	local width = BiomeMapGetSize() * 512

	local deaths = get_stripped_data()
	for x, y in string.gmatch(deaths, "([%d.-]+),([%d.-]+)") do
		for pw=-1,1 do
			EntityLoadCameraBound("mods/noita.fairmod/files/content/corpses/corpse_loader.xml", tonumber(x) + pw * width, tonumber(y))
		end
	end
end


return corpses
