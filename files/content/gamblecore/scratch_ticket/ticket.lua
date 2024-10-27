local ticket_system = dofile_once("mods/noita.fairmod/files/content/gamblecore/scratch_ticket/scratch_ticket.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

ticket = ticket or ticket_system.new(x, y)

ticket_viewed = ticket_viewed or false

if(ticket_viewed)then
	ticket:draw()
end

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	ticket_viewed = not ticket_viewed
end

function enabled_changed(entity_id, is_enabled)
	if(not is_enabled)then
		ticket_viewed = false
	end
end