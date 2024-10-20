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

function GetPlayers()
	return MergeTables(EntityGetWithTag("player_unit") or {}, EntityGetWithTag("polymorphed_player") or {}) or {}
end

function GetEnemiesInRadius(x, y, radius)
	local entities =
		MergeTables(EntityGetInRadiusWithTag(x, y, radius, "enemy"), EntityGetInRadiusWithTag(x, y, radius, "boss"))

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
		if mat:find("molten") and Random(1, 100) < 30 then
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
