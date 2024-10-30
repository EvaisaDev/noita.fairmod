local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local radius = 600
local player = EntityGetWithTag( "player_unit" )[1] or nil
if player ~= nil then
    local projectiles = EntityGetInRadiusWithTag( pos_x, pos_y, radius, "projectile" ) or {}
    for i=1, #projectiles do
        local projectile = projectiles[i]

        if ( EntityGetName(projectile) == "squidward_glock" ) then
            EntityAddComponent( projectile, "VariableStorageComponent", 
            { 
            	name = "mult",
            	value_float = 2.5,
            } )
            local luacomp = EntityGetFirstComponentIncludingDisabled(projectile, "LuaComponent")
            EntitySetComponentIsEnabled(projectile, luacomp, true)
        end
    end
end
--Code lightly copy and pasted from Copi