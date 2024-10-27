local function has_effect(entity_id, effect_name)
  for i, child in ipairs(EntityGetAllChildren(entity_id) or {}) do
    for i, component_id in ipairs(EntityGetComponent(child, "GameEffectComponent") or {}) do
      if ComponentGetValue2(component_id, "custom_effect_id") =="FAIRMOD_SMOKEDOGG" then
        return true
      end
    end
  end
end

local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity(entity_id)
local max_weed = 1
local velocity = 0.001
local direction = has_effect(owner, "FAIRMOD_SMOKEDOGG") and 1 or -1
local sprite_comp = EntityGetFirstComponent(entity_id, "SpriteComponent")
if sprite_comp then
  alpha = math.min(max_weed, (alpha or 0) + velocity * direction)
  if alpha > 0.8 then
    GameEntityPlaySoundLoop(entity_id, "fx", 0, 0)
  end
  ComponentSetValue2(sprite_comp, "alpha", alpha)
  if alpha <= 0 and direction < 0 then
    EntityKill(entity_id)
  end
end
