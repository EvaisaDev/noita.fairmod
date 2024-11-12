function portal_teleport_used( entity_that_was_teleported, from_x, from_y, to_x, to_y )
    local return_portal = EntityLoad("mods/noita.fairmod/files/content/funky_portals/return_portal.xml", to_x, to_y)
    EntityAddComponent2(return_portal, "VariableStorageComponent", {
        name = "target_x",
        value_float = from_x,
    })
    EntityAddComponent2(return_portal, "VariableStorageComponent", {
        name = "target_y",
        value_float = from_y,
    })
    local lifetime_comp = EntityGetFirstComponent(return_portal, "LifetimeComponent")
    if lifetime_comp ~= nil then 
        EntityRemoveComponent(return_portal, lifetime_comp)
    end
    EntityRemoveComponent(GetUpdatedEntityID(), GetUpdatedComponentID())
end