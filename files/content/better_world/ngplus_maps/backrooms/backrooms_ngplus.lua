local map_width, map_height = 70, 35

SetRandomSeed(69, 420)

local regular = 0xFF14E1D7
local safe_spawn = {map_x = Random(1, map_width), map_y = Random(1, map_height)}
safe_spawn.x, safe_spawn.y = (safe_spawn.map_x - (map_width * .5)) * 512, (safe_spawn.map_y - 14) * 512

BiomeMapSetSize(map_width, map_height)
BiomeMapLoadImage( 0, 0, "mods/noita.fairmod/files/content/better_world/ngplus_maps/backrooms/backrooms.png" )
BiomeMapSetPixel(safe_spawn.map_x, safe_spawn.map_y, 0xff4603f0a)

print(string.format("safe spawn is at map position [%s,%s] at coordinates (%s, %s)", safe_spawn.map_x, safe_spawn.map_y, safe_spawn.x, safe_spawn.y))

for index, value in ipairs(EntityGetWithTag("player_unit")) do
    print("spawning portal on player [" .. value .. "]...")
    local player_x,player_y = EntityGetTransform(value)
    local portal = EntityLoad("data/entities/buildings/teleport.xml", player_x, player_y)
    local tele_comps = EntityGetComponent(portal, "TeleportComponent")
    if tele_comps == nil then return print("tele_comps ARE NIL???") end
    print(string.format("Generating Portal from [%s,%s] to [%s,%s]", player_x, player_y, safe_spawn.x + 448, safe_spawn.y + 192))
    ComponentSetValue2(tele_comps[1], "target", safe_spawn.x + 448, safe_spawn.y + 192)
    ComponentSetValue2(tele_comps[1], "target_x_is_absolute_position", true)
    ComponentSetValue2(tele_comps[1], "target_y_is_absolute_position", true)
    
end

LoadPixelScene("mods/noita.fairmod/files/content/better_world/ngplus_maps/backrooms/start.png", "", safe_spawn.x, safe_spawn.y)
--[[does not work how i wanted lmao
GameAddFlagRun("random_teleport_next")
for index, value in ipairs(EntityGetWithTag("player_unit")) do
    local x,y = EntityGetTransform(value)
    EntityLoad("data/entities/buildings/teleport_lavalake.xml", x, y)
end -- ]]