
local old_damage_received = damage_received
damage_received = function(damage, desc, entity_who_caused, is_fatal)
  old_damage_received(damage, desc, entity_who_caused, is_fatal)

  local entity_id = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

  EntityAddTag(entity_id, "no_hamis_bullet")

  for i=1,30 do
    local e = EntityLoad("mods/noita.fairmod/files/content/better_props/projectile_hamis.xml", pos_x + Random(-10, 10), pos_y + Random(-10, 10))

    local comp = EntityGetFirstComponent(e, "VelocityComponent")
    ComponentSetValue2(comp, "mVelocity", Random(-1000, 1000), Random(-1000, 1000))
  end
end
