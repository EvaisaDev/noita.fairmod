local fuckedupenemies = dofile("mods/noita.fairmod/files/scripts/fuckedupenemies.lua")
local heartattack = dofile("mods/noita.fairmod/files/scripts/heartattack.lua")
local nukes = dofile("mods/noita.fairmod/files/scripts/nukes/nukes.lua")



dofile_once("mods/noita.fairmod/files/scripts/coveryourselfinoil.lua")
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita.fairmod/files/scripts/rework_spells.lua")


function OnPlayerSpawned(player)
	heartattack.OnPlayerSpawned(player)
	local x, y = EntityGetTransform(player)
	local _, snail_x, snail_y = RaytracePlatforms(x - 100, y - 100, x - 100, y + 500)
	EntityLoad("mods/noita.fairmod/files/content/immortal_snail/entities/snail.xml", snail_x, snail_y)
end

ModRegisterAudioEventMappings("mods/noita.fairmod/GUIDs.txt")

function OnWorldPreUpdate()
	fuckedupenemies.OnWorldPreUpdate()
	nukes.OnWorldPreUpdate();
end


-- Copi was here