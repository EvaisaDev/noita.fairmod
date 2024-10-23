local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local speed = GetValueNumber("speed", 1)
SetValueNumber("speed", speed * 1.0005)

local player = EntityGetWithTag("player_unit")[1] or EntityGetWithTag("polymorphed_player")[1]
if player then
  local px, py = EntityGetTransform(player)
  local dx, dy = px - x, py - y
  local dir = math.atan2(dy, dx)
  local vx = math.cos(dir) * speed
  local vy = math.sin(dir) * speed
  EntitySetTransform(entity_id, x + vx, y + vy)
  local dist2 = dx * dx + dy * dy
  if dist2 < 100 then
    local game_stats_comp = EntityGetFirstComponentIncludingDisabled(player, "GameStatsComponent")
    if game_stats_comp then
      ComponentSetValue2(game_stats_comp, "extra_death_msg", "He")
    end
    GamePlaySound("mods/noita.fairmob/fairmob.bank", "hescoming/reverbfart", px, py)
    EntityKill(player)
    EntityKill(entity_id)
    EntityLoad("mods/noita.fairmod/files/content/hescoming/gameover.xml", px, py)
  end
end
