dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

w, h = BiomeMapGetSize()

local teleport_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "TeleportComponent" )

local tele_y_default = 280

local tele_x_default = -677 + (GetParallelWorldPosition( pos_x, pos_y) * (512 * w))

if ( teleport_comp ~= nil ) then
	-- default behaviour + parallel world maintenance.
	ComponentSetValue2( teleport_comp, "target_y", tele_y_default )
	ComponentSetValue2( teleport_comp, "target_x", tele_x_default )
	ComponentSetValue2( teleport_comp, "target_x_is_absolute_position", true )
	ComponentSetValue2( teleport_comp, "target_y_is_absolute_position", false )
end