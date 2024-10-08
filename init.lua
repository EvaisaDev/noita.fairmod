local fuckedupenemies = dofile("mods/noita.fairmod/files/scripts/fuckedupenemies.lua")
local heartattack = dofile("mods/noita.fairmod/files/scripts/heartattack.lua")



dofile_once("mods/noita.fairmod/files/scripts/coveryourselfinoil.lua")
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita.fairmod/files/scripts/rework_spells.lua")


function OnPlayerSpawned()
	heartattack.OnPlayerSpawned()
end

function OnWorldPreUpdate()
	fuckedupenemies.OnWorldPreUpdate()
end


-- Copi was here