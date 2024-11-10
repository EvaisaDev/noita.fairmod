dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local teleport_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "TeleportComponent")

if teleport_comp ~= nil then
	if ComponentGetValue2(teleport_comp, "target_x_is_absolute_position") then
		local pos_x, pos_y = EntityGetTransform(entity_id)
		local target_x, target_y = ComponentGetValue2(teleport_comp, "target")

		local pw_diff = GetParallelWorldPosition(target_x, target_y) - GetParallelWorldPosition(pos_x, pos_y)

		-- Make relative and remove pw difference
		local world_width = BiomeMapGetSize() * 512
		target_x = target_x - pos_x - pw_diff * world_width
		ComponentSetValue2(teleport_comp, "target", target_x, target_y)
		ComponentSetValue2(teleport_comp, "target_x_is_absolute_position", false)
	end
end
