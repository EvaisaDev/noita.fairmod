local entity_id = GetUpdatedEntityID()
local x, y, rot, scale = EntityGetTransform(entity_id)
local MODES = {
  LOOKING = 1,
  SUBMERGING = 2,
  PREPARE_ATTACK = 3,
  ATTACK = 4
}

local detection_distance = 30
local size = 4
local damage_radius = 13
local hitbox_offset_x = 6
local hitbox_offset_y = 4

state = state or {}
state[entity_id] = state[entity_id] or {
  mode = MODES.LOOKING,
  frames_no_lava_found = 0
}

local function get_state()
  return state[entity_id]
end

local state = get_state()

local function set_mode(new_mode)
  state.mode = new_mode
end

local function find_top_of_lava()
  -- First shoot a ray up to find maybe a platform, then either from below that platform, or from the endpoint,
  -- shoot a ray down to find where the surface of the lava is
  local start_y = y - 50
  local did_hit, hit_x, hit_y = RaytraceSurfaces(x, y + 20, x, y - 50)
  if did_hit then
    start_y = hit_y + 1
  end
  did_hit, hit_x, hit_y = RaytraceSurfacesAndLiquiform(x, start_y, x, start_y + 100)
  if did_hit then
    return hit_y
  end
end

-- local function is_there_enough_lava_around_us()
--   for x=x-50, x+50, 5 do
--     for y=y, y+50, 5 do
--       local did_hit, hit_x, hit_y = RaytraceSurfacesAndLiquiform(x, y, x, y)
--       local did_hit2, hit_x2, hit_y2 = RaytraceSurfaces(x, y, x, y)
--       if not (did_hit and not did_hit2) then
--         return false
--       end
--     end
--   end
-- end

local function is_on_screen()
  local cx, cy, cw, ch = GameGetCameraBounds()
  return x > cx and y > cy and x < cx + cw and y < cy + ch
end

if state.mode == MODES.LOOKING then
  local top_of_lava_y = find_top_of_lava()
  if is_on_screen() then
    if top_of_lava_y then
      EntitySetTransform(entity_id, x, top_of_lava_y - 5)
      state.original_y = top_of_lava_y - 5
    else
    -- state.frames_no_lava_found = state.frames_no_lava_found + 1
    -- if state.frames_no_lava_found >= 10 then
      EntityKill(entity_id)
    -- end
    end
  end
  -- if not is_there_enough_lava_around_us() then
  --   EntityKill(entity_id)
  -- end
  if GameGetFrameNum() % 60 == 0 then
    EntitySetTransform(entity_id, x, y, 0, -scale)
  end
  local player = EntityGetWithTag("player_unit")[1]
  if player then
    local px, py = EntityGetTransform(player)
    local distance2 = math.pow(x - px, 2) + math.pow(y - py, 2)
    if distance2 < math.pow(detection_distance, 2) then
      set_mode(MODES.SUBMERGING)
    end
  end
end


if state.mode == MODES.SUBMERGING then
  local dist = y - state.original_y
  if dist < 15 then
    EntitySetTransform(entity_id, x, y + 1)
  else
    set_mode(MODES.PREPARE_ATTACK)
    state.prepare_attack_counter = 0
  end
end

if state.mode == MODES.PREPARE_ATTACK then
  state.prepare_attack_counter = state.prepare_attack_counter + 1
  if state.prepare_attack_counter >= 60 then
    set_mode(MODES.ATTACK)
    GamePlaySound("mods/noita.fairmod/fairmod.bank", "lavamonster/blargg", x, y)
    local sprite_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent")
    if sprite_comp then
      ComponentSetValue2(sprite_comp, "rect_animation", "chomp")
    end
    local player = EntityGetWithTag("player_unit")[1]
    if player then
      local px, py = EntityGetTransform(player)
      local direction = px - x
      state.attack_direction = math.abs(direction) / direction
      state.attack_phase = 0
      state.submerged_y = y + (size - 1) * 15  -- 0
      EntitySetTransform(entity_id, x - state.attack_direction * (size - 1) * 30, y, 0, state.attack_direction * size, size)
    else
      EntityKill(entity_id)
    end
  end
end

if state.mode == MODES.ATTACK then
  local move_speed_x = 1.5
  EntitySetTransform(entity_id, x + state.attack_direction * move_speed_x, state.submerged_y - math.sin(state.attack_phase) * 130, 0, state.attack_direction * size)
  state.attack_phase = state.attack_phase + math.rad(3 / 2) -- 180 / 60
  local player = EntityGetWithTag("player_unit")[1]
  if player then
    local px, py = EntityGetTransform(player)
    -- Hitbox is a circle with an offset
    local distance2 = math.pow((x + hitbox_offset_x * (size-1) * state.attack_direction) - px, 2) + math.pow(y + hitbox_offset_y * (size-1) - py, 2)
    if distance2 < math.pow(size * damage_radius, 2) then
      EntityInflictDamage(player, 4, "DAMAGE_BITE", "Get snacked", "NORMAL", 0, 0, entity_id)
    end
  end
  if state.attack_phase >= math.rad(180) then
    EntityKill(entity_id)
  end
  -- Just in case anyone wants to change this and needs to visialize the "hitbox"
  local debug_hitbox = false
  if debug_hitbox then
    for i=1, 100 do
      GameCreateSpriteForXFrames("data/ui_gfx/cross_red.png",
        x + hitbox_offset_x * (size-1) * state.attack_direction + math.cos(i / 100 * math.pi * 2) * size * damage_radius,
        y + hitbox_offset_y * (size-1) + math.sin(i / 100 * math.pi * 2) * size * damage_radius,
        true)
    end
  end
end
