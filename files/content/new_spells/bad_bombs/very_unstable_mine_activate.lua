local entity_id = GetUpdatedEntityID()

local sprite_comp = EntityGetFirstComponent(entity_id, "SpriteComponent")
if sprite_comp then ComponentSetValue2(sprite_comp, "rect_animation", "detonate") end

local collision_comp = EntityGetFirstComponent(entity_id, "CollisionTriggerComponent")
if collision_comp then ComponentSetValue2(collision_comp, "mTimer", 10) end
