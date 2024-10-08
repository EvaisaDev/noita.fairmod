local fuckedupenemies = dofile("mods/noita.fairmod/files/scripts/fuckedupenemies.lua")
local heartattack = dofile("mods/noita.fairmod/files/scripts/heartattack.lua")
local nukes = dofile("mods/noita.fairmod/files/scripts/nukes/nukes.lua")



dofile_once("mods/noita.fairmod/files/scripts/coveryourselfinoil.lua")
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita.fairmod/files/scripts/rework_spells.lua")


function OnPlayerSpawned(player)
	heartattack.OnPlayerSpawned(player)
end

ModRegisterAudioEventMappings("mods/noita.fairmod/GUIDs.txt")

function OnWorldPreUpdate()
	fuckedupenemies.OnWorldPreUpdate()
	nukes.OnWorldPreUpdate();
end


-- Copi was here