local entity_id = GetUpdatedEntityID()
local affected_entity = EntityGetRootEntity(entity_id)
local controls_comp = EntityGetFirstComponentIncludingDisabled(affected_entity, "ControlsComponent")
if controls_comp then
  ComponentSetValue2(controls_comp, "enabled", true)
end
