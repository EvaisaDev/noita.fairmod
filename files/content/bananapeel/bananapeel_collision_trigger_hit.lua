function collision_trigger(colliding_entity_id)
  local found = false
  for i, comp in ipairs(EntityGetComponentIncludingDisabled(colliding_entity_id, "LuaComponent") or {}) do
    if ComponentGetValue2(comp, "script_source_file") == "mods/noita.fairmod/files/content/bananapeel/slip.lua" then
      found = true
      break
    end
  end
  if not found then
    EntityAddComponent2(colliding_entity_id, "LuaComponent", {
      script_source_file="mods/noita.fairmod/files/content/bananapeel/slip.lua",
      execute_every_n_frame=1,
    })
    LoadGameEffectEntityTo(colliding_entity_id, "mods/noita.fairmod/files/content/bananapeel/stun_effect.xml")
    local x, y = EntityGetTransform(colliding_entity_id)
    GamePlaySound("mods/noita.fairmod/fairmod.bank", "bananapeel/slip_and_fall", x, y)
  end
end
