
function MergeTables(...)
	local tables = {...}
	local out = {}
	for _,t in ipairs(tables) do
		for k,v in pairs(t) do
			out[k] = v
		end
	end
	return out
end

function GetPlayers()
	return MergeTables(EntityGetWithTag("player_unit") or {}, EntityGetWithTag("polymorphed_player") or {}) or {}
end

function GetEnemiesInRadius(x, y, radius)
	local entities = MergeTables(EntityGetInRadiusWithTag(x, y, radius, "enemy"), EntityGetInRadiusWithTag(x, y, radius, "boss"))
	
	return entities
end
