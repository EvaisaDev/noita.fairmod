--- Hardcoded world width for scripts that don't have access to BiomeMapGetSize.
WORLD_WIDTH_HARDCODED = 70 * 512

---@vararg table
---@return table
function MergeTables(...)
	local tables = { ... }
	local out = {}
	for _, t in ipairs(tables) do
		for k, v in pairs(t) do
			out[k] = v
		end
	end
	return out
end

---@return table
function GetPlayers()
	return MergeTables(EntityGetWithTag("player_unit") or {}, EntityGetWithTag("polymorphed_player") or {}) or {}
end

---@param x number
---@param y number
---@param radius number
---@return int[]
function GetEnemiesInRadius(x, y, radius)
	local entities = MergeTables(EntityGetInRadiusWithTag(x, y, radius, "enemy"), EntityGetInRadiusWithTag(x, y, radius, "boss"))

	return entities
end

function MaterialsFilter(mats)
	for i = #mats, 1, -1 do
		local mat = mats[i]

		if mat:find("fading") then
			table.remove(mats, i)
			goto continue
		end
		SetRandomSeed(1, 1)
		if
			mat:find("molten")--[[ and Random(1, 100) < 30]]
		then
			table.remove(mats, i)
			goto continue
		end

		local tags = CellFactory_GetTags(CellFactory_GetType(mat)) or {}
		for _, tag in ipairs(tags) do
			if tag == "[box2d]" or tag == "[catastrophic]" or tag == "[NO_FUNGAL_SHIFT]" then
				table.remove(mats, i)
				goto continue
			end
		end
		::continue::
	end

	return mats
end

---@return table<int>
function GetInventoryItems()
	local player_entity = GetPlayers()[1]
	if player_entity ~= nil then return GameGetAllInventoryItems(player_entity) or {} end
	return {}
end

---@param tag string
---@return boolean
function HasInventoryItemTag(tag)
	for _, item in ipairs(GetInventoryItems()) do
		if EntityHasTag(item, tag) then return true end
	end
	return false
end

---@param x number
---@param y number
---@return string|nil
function GetBiomeId(x, y)
	local filename = DebugBiomeMapGetFilename(x, y)
	for name in filename:gmatch("/([%w_ ]+).xml") do
		return name
	end
	return nil
end

---@return string|nil
function GetCurrentBiomeId()
	local plyr = GetPlayers()[1]
	if plyr == nil then return nil end

	local x, y = EntityGetTransform(plyr)
	return GetBiomeId(x, y)
end
