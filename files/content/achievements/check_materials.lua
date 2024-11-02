local player = GetUpdatedEntityID()

local material_inventory_comp = EntityGetFirstComponent(player, "MaterialInventoryComponent")
if material_inventory_comp == nil then return end

local materials = ComponentGetValue2(material_inventory_comp, "count_per_material_type")


local piss = CellFactory_GetType("urine") + 1

local piss_count = materials[piss] or 0

if piss_count >= 100 then
	GameAddFlagRun("fairmod_piss_drinker")
end
