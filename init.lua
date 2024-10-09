local fuckedupenemies = dofile("mods/noita.fairmod/files/content/fuckedupenemies/fuckedupenemies.lua") ---@type fuckupenemies
local heartattack = dofile("mods/noita.fairmod/files/content/heartattack/heartattack.lua")
local nukes = dofile("mods/noita.fairmod/files/content/nukes/scripts/nukes.lua")
local input_delay = dofile("mods/noita.fairmod/files/content/input_delay/input_delay.lua")
local tm_trainer = dofile("mods/noita.fairmod/files/content/tmtrainer/init.lua")
local crits = dofile("mods/noita.fairmod/files/content/crits/init.lua")

dofile_once("mods/noita.fairmod/files/scripts/coveryourselfinoil.lua")
dofile_once("mods/noita.fairmod/files/content/hm_portal_mimic/init.lua")
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita.fairmod/files/scripts/rework_spells.lua")


function OnModPostInit()
	dofile_once("mods/noita.fairmod/files/content/hamis_reworked/hamis_reworked.lua")
end

ModLuaFileAppend("data/scripts/biomes/mountain/mountain_hall.lua", "mods/noita.fairmod/files/content/stalactite/mountain_hall_append.lua")

function OnPlayerSpawned(player)
	if GameHasFlagRun("fairmod_init") then
		return
	end
	GameAddFlagRun("fairmod_init")

	tm_trainer.OnPlayerSpawned(player)

	local plays = tonumber(ModSettingGet("fairmod.plays")) or 0
	plays = plays + 1
	ModSettingSet("fairmod.plays", plays)

	heartattack.OnPlayerSpawned(player)
	local x, y = EntityGetTransform(player)
	local _, snail_x, snail_y = RaytracePlatforms(x - 100, y - 100, x - 100, y + 500)
	EntityLoad("mods/noita.fairmod/files/content/immortal_snail/entities/snail.xml", snail_x, snail_y)
	crits.OnPlayerSpawned(player)
end

ModRegisterAudioEventMappings("mods/noita.fairmod/GUIDs.txt")

function OnWorldPreUpdate()
	if GameGetFrameNum() % 30 == 0 then
		fuckedupenemies:OnWorldPreUpdate()
	end
	nukes.OnWorldPreUpdate();
	input_delay.OnWorldPreUpdate()
end

-- Copi was here
-- Moldos was here
