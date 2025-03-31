dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local material_inv_comp = EntityGetFirstComponent(entity_id, "MaterialInventoryComponent")
if not material_inv_comp then return end

local damage_model_comp = EntityGetFirstComponent(entity_id, "DamageModelComponent")
if not damage_model_comp then return end

local current_material = GetMaterialInventoryMainMaterial(entity_id)
if current_material ~= 0 then RemoveMaterialInventoryMaterial(entity_id, CellFactory_GetName(current_material)) end

local x, y = EntityGetTransform(entity_id)

-- SetRandomSeed(x, y)

local materials_all = dofile_once("mods/noita.fairmod/files/content/better_props/oil_barrel/materials.lua")
local picked_materials = pick_random_from_table_weighted({ x = x, y = y }, materials_all)
if not picked_materials then return end

local quantity = picked_materials.quantity
local materials = picked_materials.materials
for _, material in ipairs(materials) do
	AddMaterialInventoryMaterial(entity_id, material, quantity)
end

ComponentSetValue2(damage_model_comp, "blood_material", materials[1])
