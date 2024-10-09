dofile_once("data/scripts/lib/utilities.lua")

local portal = GetUpdatedEntityID()
local x, y = EntityGetTransform(portal)

SetRandomSeed( x, y + tonumber(StatsGetValue("world_seed")))

local doidoit = Random(1,75)

if doidoit == 2 then
    local comps = EntityGetAllComponents(portal)
    for i,v in ipairs(comps) do
        EntitySetComponentIsEnabled(portal, v, false)
    end
    EntityLoad("data/entities/animals/noita.fairmod_hm_portal_mimic.xml", x, y)
    EntityKill(portal)
end