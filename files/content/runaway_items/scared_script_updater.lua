local RADIUS_SQ = 40*40

local player_entity = EntityGetWithTag("player_unit")[1]
if player_entity ~= nil then
  local entity_id = GetUpdatedEntityID()

  local player_x, player_y = EntityGetTransform(player_entity)
  local x, y = EntityGetTransform(entity_id)

  local dx = x - player_x
  local dy = y - player_y

  local dist_sq = dx*dx + dy*dy

  if dist_sq < RADIUS_SQ then
    local urgency = (RADIUS_SQ - dist_sq)/5
    PhysicsApplyForce(entity_id, dx / math.abs(dx) * urgency, dy / math.abs(dy) * urgency)
  end
end