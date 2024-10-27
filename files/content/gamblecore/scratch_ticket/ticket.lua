local ticket_system = dofile_once("mods/noita.fairmod/files/content/gamblecore/scratch_ticket/scratch_ticket.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

tickets = tickets or {}
viewed = viewed or {}

if(not tickets[entity_id])then
	local variable_storage_comps = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent")

	local ticket_data = nil
	if(variable_storage_comps)then
		for i, comp in ipairs(variable_storage_comps)do
			local name = ComponentGetValue2(comp, "name")
			if(name == "ticket_data")then
				ticket_data = ComponentGetValue2(comp, "value_string")
				break
			end
		end
	end

	if(ticket_data)then
		tickets[entity_id] = ticket_system.load(ticket_data, entity_id)
	else
		tickets[entity_id] = ticket_system.new(x, y)
		local ticket_data = tickets[entity_id]:save()
		EntityAddComponent2(entity_id, "VariableStorageComponent", {
			name = "ticket_data",
			value_string = ticket_data
		})
	end
end


local ticket_viewed = viewed[entity_id] or false

if(ticket_viewed)then
	tickets[entity_id]:draw()
end

-- no tag = redeemed
if(not EntityHasTag(entity_id, "scratch_ticket") )then
	tickets[entity_id]:redeem()
	local parent = EntityGetRootEntity(entity_id)
	GameKillInventoryItem(parent, entity_id)
end

local function save_ticket()
	local ticket_data = tickets[entity_id]:save()
	local variable_storage_comps = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent")
	if(variable_storage_comps)then
		for i, comp in ipairs(variable_storage_comps)do
			local name = ComponentGetValue2(comp, "name")
			if(name == "ticket_data")then
				ComponentSetValue2(comp, "value_string", ticket_data)
				break
			end
		end
	end
end

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	GamePrint("interacting")
	viewed[entity_id] = not viewed[entity_id]
	save_ticket()
end

function enabled_changed(entity_id, is_enabled)
	if(not is_enabled)then
		viewed[entity_id] = false
		save_ticket()
	end
end

