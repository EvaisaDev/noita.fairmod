SetRandomSeed(GameGetFrameNum(), GameGetFrameNum() * 1337)

local materials = CellFactory_GetAllSands()

local cheese_solids = {}
local cheese_powders = {}

for _, mat in ipairs(materials) do
	local mat_id = CellFactory_GetType(mat)
	if CellFactory_HasTag(mat_id, "[cheese]") then
		if CellFactory_HasTag(mat_id, "[static]") then
			table.insert(cheese_solids, mat)
		else
			table.insert(cheese_powders, mat)
		end
	end
end

ConvertEverythingToGold(cheese_powders[Random(1, #cheese_powders)], cheese_solids[Random(1, #cheese_solids)])
