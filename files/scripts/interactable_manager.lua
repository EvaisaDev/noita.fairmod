local interactable_manager = {}


local function fix_state(item_entity)
	local parent = EntityGetParent(item_entity)
	
	if parent == 0 then
		EntitySetComponentsWithTagEnabled(item_entity, "enabled_in_hand", false)
		EntitySetComponentsWithTagEnabled(item_entity, "enabled_in_inventory", false)
		EntitySetComponentsWithTagEnabled(item_entity, "enabled_in_world", true)
	else
		local inventory_comp = EntityGetFirstComponentIncludingDisabled(parent, "Inventory2Component")
		if inventory_comp ~= nil then
			local active_item = ComponentGetValue2(inventory_comp, "mActiveItem")
			
			if active_item == item_entity then
				EntitySetComponentsWithTagEnabled(item_entity, "enabled_in_world", false)
				EntitySetComponentsWithTagEnabled(item_entity, "enabled_in_inventory", false)
				EntitySetComponentsWithTagEnabled(item_entity, "enabled_in_hand", true)
			else
				EntitySetComponentsWithTagEnabled(item_entity, "enabled_in_world", false)
				EntitySetComponentsWithTagEnabled(item_entity, "enabled_in_hand", false)
				EntitySetComponentsWithTagEnabled(item_entity, "enabled_in_inventory", true)
			end
		end
	end
end

local function get_should_be_enabled(entity, component)
	local comp_tags = ComponentGetTags(component) or ""
	local has_state_tags = string.find(comp_tags, "enabled_in_world") or string.find(comp_tags, "enabled_in_hand") or string.find(comp_tags, "enabled_in_inventory")
	
	if not has_state_tags then
		return true
	end
	
	if string.find(comp_tags, "enabled_in_world") then
		local parent = EntityGetParent(entity)
		if parent == 0 then
			return true
		end
	end
	
	if string.find(comp_tags, "enabled_in_hand") then
		local parent = EntityGetParent(entity)
		if parent ~= 0 then
			local inventory_comp = EntityGetFirstComponentIncludingDisabled(parent, "Inventory2Component")
			if inventory_comp ~= nil then
				local active_item = ComponentGetValue2(inventory_comp, "mActiveItem")
				if active_item == entity then
					return true
				end
			end
		end
	end
	
	if string.find(comp_tags, "enabled_in_inventory") then
		local parent = EntityGetParent(entity)
		if parent ~= 0 then
			local inventory_comp = EntityGetFirstComponentIncludingDisabled(parent, "Inventory2Component")
			if inventory_comp ~= nil then
				local active_item = ComponentGetValue2(inventory_comp, "mActiveItem")
				if active_item ~= entity then
					return true
				end
			end
		end
	end
	
	return false
end

local function set_interactable_enabled(entity, component, enabled)
	EntitySetComponentIsEnabled(entity, component, enabled)
	if enabled then
		EntityRemoveTag(entity, "fairmod_interactable_disabled")
		ComponentRemoveTag(component, "fairmod_interactable_disabled")
	else
		EntityAddTag(entity, "fairmod_interactable_disabled")
		ComponentAddTag(component, "fairmod_interactable_disabled")
	end
end

function interactable_manager.update()
	local player = EntityGetWithTag("player_unit")[1]
	if not player then return end
	
	local px, py = EntityGetTransform(player)
	local entities_in_range = EntityGetInRadius(px, py, 512)
	
	local interactables_in_range = {}
	local processed_entities = {}
	
	for _, entity in ipairs(entities_in_range) do
		processed_entities[entity] = true
		local interactable_comps = EntityGetComponentIncludingDisabled(entity, "InteractableComponent")
		
		if interactable_comps then
			for _, comp in ipairs(interactable_comps) do
				local comp_tags = ComponentGetTags(comp) or ""
				local has_state_tags = string.find(comp_tags, "enabled_in_hand") or string.find(comp_tags, "enabled_in_world") or string.find(comp_tags, "enabled_in_inventory")
				
				if has_state_tags and not ComponentGetIsEnabled(comp) and not ComponentHasTag(comp, "fairmod_interactable_disabled") then
					goto skip_component
				end
				
				local radius = ComponentGetValue2(comp, "radius")
				local ex, ey = EntityGetTransform(entity)
				local dist = math.sqrt((px - ex)^2 + (py - ey)^2)
				
				if dist <= radius then
					table.insert(interactables_in_range, {
						entity = entity,
						component = comp,
						distance = dist
					})
				end
				
				::skip_component::
			end
		end
	end
	
	if #interactables_in_range > 1 then
		table.sort(interactables_in_range, function(a, b)
			if math.abs(a.distance - b.distance) < 0.01 then
				return a.entity < b.entity
			end
			return a.distance < b.distance
		end)
	end
	
	for i, interactable in ipairs(interactables_in_range) do
		set_interactable_enabled(interactable.entity, interactable.component, i == 1)
	end
	
	local disabled_entities = EntityGetWithTag("fairmod_interactable_disabled")
	for _, entity in ipairs(disabled_entities) do
		if not processed_entities[entity] and EntityGetIsAlive(entity) then
			local comps = EntityGetComponentIncludingDisabled(entity, "InteractableComponent", "fairmod_interactable_disabled")
			if comps then
				for _, comp in ipairs(comps) do
					if get_should_be_enabled(entity, comp) then
						EntitySetComponentIsEnabled(entity, comp, true)
					end
					ComponentRemoveTag(comp, "fairmod_interactable_disabled")
				end
			end
			EntityRemoveTag(entity, "fairmod_interactable_disabled")
		end
	end
end

return interactable_manager


