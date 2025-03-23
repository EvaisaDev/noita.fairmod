local entity_id = GetUpdatedEntityID()

local action_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ItemActionComponent")
if not action_comp then return end

local names = dofile_once("mods/noita.fairmod/files/content/add_space_to_item/get_action_name.lua")
local action_name = names[ComponentGetValue2(action_comp, "action_id")] or "?"

local item_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ItemComponent")
if not item_comp then return end

ComponentSetValue2(item_comp, "always_use_item_name_in_ui", true)

local translated_name = GameTextGetTranslatedOrNot(action_name)
ComponentSetValue2(item_comp, "item_name", translated_name .. string.rep(" ", math.random(1, math.max(1, 150 - #translated_name))))
