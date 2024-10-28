
local player = EntityGetWithTag("player_unit")
for k=1,#player do
    local v = player[k]
    local x,y = EntityGetTransform(v)

    --Do EoE terrain removal
    --Spawn bowling ball & pins ontop of the player
    --They die to crush damage probably
    --lmao

    EntityLoad("mods/noita.fairmod/files/content/payphone/content/bowling/bowling_start.xml",x,y)
end
