
local target_entity = nil

local old_GamePrintImportant = GamePrintImportant
function GamePrintImportant(title, description, ui_custom_decoration_file)
	if target_entity == nil or not EntityGetIsAlive(target_entity) then return end

	if EntityHasTag(target_entity, "player_unit") or EntityHasTag(target_entity, "polymorphed_player") then
		old_GamePrintImportant(title, description or "", ui_custom_decoration_file or "")
	end
end

local old_item_pickup = item_pickup
function item_pickup(entity_item, entity_who_picked, name)
	target_entity = entity_who_picked
	old_item_pickup(entity_item, entity_who_picked, name)
end
