dofile("data/scripts/lib/utilities.lua")
dofile("data/scripts/gun/procedural/gun_action_utils.lua")
local entity_id = GetUpdatedEntityID()
AddGunActionPermanent(entity_id, "MODIFIER_ONLY_ULTRAFAIR")
AddGunActionPermanent(entity_id, "BULLET_SOMA")
if ModIsEnabled("copis_things") then
	AddGunAction(entity_id, "COPITH_COLD_HEARTED")
end