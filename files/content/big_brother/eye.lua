local entity_id = GetUpdatedEntityID()
local root_id = EntityGetParent(entity_id)
local x, y = EntityGetTransform(root_id)

local player = EntityGetWithTag("player_unit")[1]
if not player then return end

local px, py = EntityGetTransform(player)

local angle = math.pi * 2 - math.atan2(py - y, px - x)
EntitySetTransform(entity_id, x + math.cos(angle) * 6, y - math.sin(angle) * 6)
