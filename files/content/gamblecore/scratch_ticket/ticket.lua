local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
local ticket_system = dofile_once("mods/noita.fairmod/files/content/gamblecore/scratch_ticket/scratch_ticket.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

ticket = ticket or nil

if not ticket then
	local variable_storage_comps = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent")

	local ticket_data = nil
	if variable_storage_comps then
		for i, comp in ipairs(variable_storage_comps) do
			local name = ComponentGetValue2(comp, "name")
			if name == "ticket_data" then
				ticket_data = ComponentGetValue2(comp, "value_string")
				break
			end
		end
	end

	if ticket_data then
		ticket = ticket_system.load(ticket_data, entity_id)
	else
		ticket = ticket_system.new(x, y)
		local ticket_data = ticket:save()
		EntityAddComponent2(entity_id, "VariableStorageComponent", {
			name = "ticket_data",
			value_string = ticket_data,
		})
	end
end

local function save_ticket()
	local ticket_data = ticket:save()
	local variable_storage_comps = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent")
	if variable_storage_comps then
		for i, comp in ipairs(variable_storage_comps) do
			local name = ComponentGetValue2(comp, "name")
			if name == "ticket_data" then
				ComponentSetValue2(comp, "value_string", ticket_data)
				break
			end
		end
	end
end

if ticket.scratch_callback == nil then
	ticket.scratch_callback = function()
		if GameGetFrameNum() % 15 == 0 then save_ticket() end
	end
end

local ticket_viewed = EntityHasTag(entity_id, "viewing")

if ticket_viewed then
	ticket:draw()
else
	GuiStartFrame(ticket.gui)
end

-- no tag = redeemed
if not EntityHasTag(entity_id, "scratch_ticket") then
	GamePlaySound("mods/noita.fairmod/fairmod.bank", "scratchoff/redeem", 0, 0)
	ticket:redeem()
	GameRemoveFlagRun("fairmod_scratch_interacting")
	GuiDestroy(ticket.gui)
	local parent = EntityGetRootEntity(entity_id)
	GameKillInventoryItem(parent, entity_id)
end

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	-- If interacting with a dialog system, don't open scratch ticket at the same time
	if dialog_system.is_any_dialog_open() or GameHasFlagRun("fairmod_dialog_interacting") then return end

	if not EntityHasTag(entity_interacted, "viewing") then
		EntityAddTag(entity_interacted, "viewing")
		GameAddFlagRun("fairmod_scratch_interacting")
	else
		EntityRemoveTag(entity_interacted, "viewing")
		GameRemoveFlagRun("fairmod_scratch_interacting")
	end
end

function enabled_changed(entity_id, is_enabled)
	if not is_enabled then
		EntityRemoveTag(entity_id, "viewing")
		GameRemoveFlagRun("fairmod_scratch_interacting")
	end
end
