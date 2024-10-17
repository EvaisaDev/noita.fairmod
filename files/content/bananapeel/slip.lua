-- Rotates the player and plays the sleep animation after some time, then adds another script for standing up again
dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local x, y, rot = EntityGetTransform(entity_id)
local this_component = GetUpdatedComponentID()
local tick = GetValueInteger("tick", 0)
SetValueInteger("tick", tick + 1)
if tick == 95 then
  GamePlayAnimation(entity_id, "intro_sleep", 2)
  EntitySetTransform(entity_id, x, y, 0)
  SetValueInteger("tick", 0)
  EntityRemoveComponent(entity_id, this_component)
  EntityAddComponent2(entity_id, "LuaComponent", {
    script_source_file="mods/noita.fairmod/files/content/bananapeel/stand_up.lua",
    execute_every_n_frame=1,
    remove_after_executed=true
  })
else
  EntitySetTransform(entity_id, x, y, rot + 0.3)
end
