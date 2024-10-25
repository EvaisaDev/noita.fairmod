local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local item_pickupper_component = EntityGetFirstComponent(entity_id, "ItemPickUpperComponent")

if item_pickupper_component == nil then return end

local nearby_items = EntityGetInRadius(x, y, 15)

for _, item_id in ipairs(nearby_items) do
	local item_component = EntityGetFirstComponent(item_id, "ItemComponent")
	if item_component and EntityGetRootEntity(item_id) == item_id then
		ComponentSetValue2(item_pickupper_component, "only_pick_this_entity", item_id)
		GameDropAllItems(entity_id)
		break
	end
end
