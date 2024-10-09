function collision_trigger(player_entity)
    
    local ent = GetUpdatedEntityID()
    
    -- Don't activate again for a bit.
    local ct_component = EntityGetFirstComponent(ent, "CollisionTriggerComponent")
    ComponentSetValue2(ct_component, "mTimer", 60*2)
    
    local parent = EntityGetParent(ent)
    local x, y = EntityGetTransform(parent)
    local px, py = EntityGetTransform(player_entity)

    local dist = 10
    local dx, dy = px-x, py-y
    local rx, ry = x + dx * dist, y + dy * dist

    local did_hit, hx, hy = RaytracePlatforms(x, y, rx, ry)

    EntitySetTransform(parent, hx, hy)

    GamePrint("evade"..x.." "..y)
end
