BiomeMapSetSize(70, 35)
BiomeMapLoadImage( 0, 0, "mods/noita.fairmod/files/content/better_world/ngplus_maps/backrooms/backrooms.png" )

SetRandomSeed(69, 420)

local regular = 0xFF14E1D7
local safe_spawn = {x = 0, y = 0}
BiomeMapSetPixel(safe_spawn.x, safe_spawn.y, 0xFF36D517)
print(string.format("safe spawn is at position [%s,%s] at coordinates (%s, %s)", safe_spawn.x, safe_spawn.y, safe_spawn.x * 512, safe_spawn.y * 512))

for index, value in ipairs(EntityGetWithTag("player_unit")) do
    EntitySetTransform(value, (safe_spawn.x * 512) + 448, (safe_spawn.y * 512) + 192)
    print(string.format("Player [%s] teleported to coordinates (%s, %s)", value, (safe_spawn.x * 512) + 448, (safe_spawn.y * 512) + 192))
end


LoadPixelScene("mods/noita.fairmod/files/content/better_world/ngplus_maps/backrooms/start.png", "", safe_spawn.x * 512, safe_spawn.y * 512)
--[[does not work how i wanted lmao
GameAddFlagRun("random_teleport_next")
for index, value in ipairs(EntityGetWithTag("player_unit")) do
    local x,y = EntityGetTransform(value)
    EntityLoad("data/entities/buildings/teleport_lavalake.xml", x, y)
end -- ]]