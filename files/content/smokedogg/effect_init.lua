local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity(entity_id)

if EntityHasTag(owner, "player_unit") or EntityHasTag(owner, "polymorphed_player") then
  local found = false
  for i, child in ipairs(EntityGetAllChildren(owner) or {}) do
    if EntityGetName(child) == "smoke_dogg_fade_effect_entity" then
      found = true
    end
  end
  if not found then
    local x, y = EntityGetTransform(entity_id)
    local child_entity = EntityLoad("mods/noita.fairmod/files/content/smokedogg/fade_effect_entity.xml", x, y)
    EntityAddChild(owner, child_entity)
  end
end
