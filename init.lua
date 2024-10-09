local fuckedupenemies = dofile("mods/noita.fairmod/files/content/fuckedupenemies/fuckedupenemies.lua") ---@type fuckupenemies
local heartattack = dofile("mods/noita.fairmod/files/content/heartattack/heartattack.lua")
local nukes = dofile("mods/noita.fairmod/files/content/nukes/scripts/nukes.lua")
local input_delay = dofile("mods/noita.fairmod/files/content/input_delay/input_delay.lua")
local tm_trainer = dofile("mods/noita.fairmod/files/content/tmtrainer/init.lua")
local crits = dofile("mods/noita.fairmod/files/content/crits/init.lua")

dofile_once("mods/noita.fairmod/files/content/coveryourselfinoil/coveryourselfinoil.lua")
dofile_once("mods/noita.fairmod/files/content/hm_portal_mimic/init.lua")
dofile_once("mods/noita.fairmod/files/content/fungal_shift/fix_nolla_tags.lua")
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita.fairmod/files/content/rework_spells/rework_spells.lua")
ModLuaFileAppend("data/scripts/magic/fungal_shift.lua", "mods/noita.fairmod/files/content/fungal_shift/append.lua")

--- I hate doing things without a hook
function OnModPostInit()
	dofile_once("mods/noita.fairmod/files/content/enemy_reworks/reworks.lua")
	dofile_once("mods/noita.fairmod/files/content/water_is_bad/fuck_water.lua")
end

--- Seed init
function OnMagicNumbersAndWorldSeedInitialized()
	tm_trainer.OnMagicNumbersAndWorldSeedInitialized()
end


ModLuaFileAppend("data/scripts/biomes/mountain/mountain_hall.lua", "mods/noita.fairmod/files/content/stalactite/scripts/mountain_hall_append.lua")


function OnPlayerSpawned(player)
	local x, y = EntityGetTransform(player)

	-- move player to a random parallel world.

	SetRandomSeed(x, y)

	local map_w, map_h = BiomeMapGetSize()
	local offset_x = (map_w * 512 * Random(-3, 3))

	local target_x = x + offset_x
	local target_y = y

	EntityApplyTransform(player, target_x, target_y)

	----------------------------------
	
	if GameHasFlagRun("fairmod_init") then
		return
	end
	GameAddFlagRun("fairmod_init")

	tm_trainer.OnPlayerSpawned(player)

	local plays = tonumber(ModSettingGet("fairmod.plays")) or 0
	plays = plays + 1
	ModSettingSet("fairmod.plays", plays)

	heartattack.OnPlayerSpawned(player)

	local _, snail_x, snail_y = RaytracePlatforms(x - 100, y - 100, x - 100, y + 500)
	EntityLoad("mods/noita.fairmod/files/content/immortal_snail/entities/snail.xml", snail_x, snail_y)
	crits.OnPlayerSpawned(player)


	-- enable physics damage on the player
	local damage_model_comp = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
	if(damage_model_comp)then
		ComponentSetValue2(damage_model_comp, "physics_objects_damage", true)
	end

	EntityLoad("mods/noita.fairmod/files/content/rotate/rotta-cart.xml", 470, -105.100)
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
