local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

SetRandomSeed(x, y)

dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

local distance = 10

local players = EntityGetInRadiusWithTag(x, y, distance, "player_unit") or {}
timer = timer or 0

local reveal_delay = 60 * 2

if players == nil or #players <= 0 then return end

local actual_perk_id = nil
local actual_perk_icon = nil
local actual_perk_name = nil
local actual_perk_desc = nil

local variable_storage_comps = EntityGetComponent(entity_id, "VariableStorageComponent")

if variable_storage_comps ~= nil then
	for i, comp_id in ipairs(variable_storage_comps) do
		local name = ComponentGetValue2(comp_id, "name")
		if name == "actual_perk_id" then
			actual_perk_id = ComponentGetValue2(comp_id, "value_string")
		elseif name == "actual_perk_icon" then
			actual_perk_icon = ComponentGetValue2(comp_id, "value_string")
		elseif name == "actual_perk_name" then
			actual_perk_name = ComponentGetValue2(comp_id, "value_string")
		elseif name == "actual_perk_desc" then
			actual_perk_desc = ComponentGetValue2(comp_id, "value_string")
		end
	end
end

if actual_perk_id == nil or actual_perk_icon == nil or actual_perk_name == nil or actual_perk_desc == nil then
	return
end

local sprite_component = EntityGetFirstComponent(entity_id, "SpriteComponent", "perk_icon")
local ui_info_component = EntityGetFirstComponent(entity_id, "UIInfoComponent")
local item_component = EntityGetFirstComponent(entity_id, "ItemComponent")

if sprite_component == nil or ui_info_component == nil or item_component == nil then return end

if reveal_delay <= timer then
	ComponentSetValue2(sprite_component, "image_file", actual_perk_icon)
	ComponentSetValue2(ui_info_component, "name", actual_perk_name)
	ComponentSetValue2(item_component, "item_name", actual_perk_name)
	ComponentSetValue2(item_component, "ui_description", actual_perk_desc)
end

timer = timer + 1
