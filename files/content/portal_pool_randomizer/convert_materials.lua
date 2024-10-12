local water = CellFactory_GetType("water")
local liquids = CellFactory_GetAllLiquids(false, false) or {}

local random_liquid = CellFactory_GetType(liquids[Random(1, #liquids)])

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

ConvertMaterialOnAreaInstantly( x, y, 512, 150, water, random_liquid, false, false )

EntityKill(entity_id)