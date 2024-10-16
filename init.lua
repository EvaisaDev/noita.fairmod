dofile_once("mods/noita.fairmod/files/lib/DialogSystem/init.lua")("mods/noita.fairmod/files/lib/DialogSystem")

local fuckedupenemies = dofile_once("mods/noita.fairmod/files/content/fuckedupenemies/fuckedupenemies.lua") --- @type fuckupenemies
local heartattack = dofile_once("mods/noita.fairmod/files/content/heartattack/heartattack.lua")
local nukes = dofile_once("mods/noita.fairmod/files/content/nukes/scripts/nukes.lua")
local input_delay = dofile_once("mods/noita.fairmod/files/content/input_delay/input_delay.lua")
local tm_trainer = dofile_once("mods/noita.fairmod/files/content/tmtrainer/init.lua")
local crits = dofile_once("mods/noita.fairmod/files/content/crits/init.lua")
local clipboard = dofile_once("mods/noita.fairmod/files/content/clipboard/init.lua")
local gamblecore = dofile_once("mods/noita.fairmod/files/content/gamblecore/init.lua")
local funky_portals = dofile_once("mods/noita.fairmod/files/content/funky_portals/init.lua")
local trading_cards = dofile_once("mods/noita.fairmod/files/content/trading_card_game/init.lua")
local evil_nuggets = dofile_once("mods/noita.fairmod/files/content/evil_nuggets/init.lua")

dofile_once("mods/noita.fairmod/files/content/coveryourselfinoil/coveryourselfinoil.lua")
dofile_once("mods/noita.fairmod/files/content/hm_portal_mimic/init.lua")
dofile_once("mods/noita.fairmod/files/content/fungal_shift/fix_nolla_tags.lua")
dofile_once("mods/noita.fairmod/files/content/evasive_items/evasive_items.lua")
dofile_once("mods/noita.fairmod/files/content/wizard_crash/init.lua")
dofile_once("mods/noita.fairmod/files/content/better_props/init.lua")
dofile_once("mods/noita.fairmod/files/content/lasers/init.lua")
dofile_once("mods/noita.fairmod/files/content/worms/init.lua")
dofile_once("mods/noita.fairmod/files/content/stalactite/init.lua")
dofile_once("mods/noita.fairmod/files/content/mon_wands/mon_wands_init.lua")
dofile_once("mods/noita.fairmod/files/content/scene_liquid_randomizer/init.lua")
dofile_once("mods/noita.fairmod/files/content/speedrun_door/init.lua")
dofile_once("mods/noita.fairmod/files/content/collapse/init.lua")
dofile_once("mods/noita.fairmod/files/content/perk_tomfoolery/init.lua")
dofile_once("mods/noita.fairmod/files/content/bonce/init.lua")
dofile_once("mods/noita.fairmod/files/content/hearts_owie/init.lua")
dofile_once("mods/noita.fairmod/files/content/cat/init.lua")
dofile_once("mods/noita.fairmod/files/content/quality_of_life/init.lua")
dofile_once("mods/noita.fairmod/files/content/surface_bad/init.lua")
dofile_once("mods/noita.fairmod/files/content/cauldron/init.lua")
dofile_once("mods/noita.fairmod/files/content/cactus/init.lua")

dofile_once("mods/noita.fairmod/files/content/runaway_items/init.lua")
dofile_once("mods/noita.fairmod/files/content/scenes_in_pws/init.lua")
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita.fairmod/files/content/rework_spells/rework_spells.lua")
ModLuaFileAppend("data/scripts/magic/fungal_shift.lua", "mods/noita.fairmod/files/content/fungal_shift/append.lua")
ModMaterialsFileAdd("mods/noita.fairmod/files/content/gold_bananas/materials.xml")
ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noita.fairmod/files/content/minus_life/perk.lua")
ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noita.fairmod/files/content/mon_wands/perk.lua")
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita.fairmod/files/content/immortal_snail/gun/scripts/actions.lua")

-- Optional imgui dep
imgui = load_imgui and load_imgui { mod = "noita.fairmod", version = "1.0.0" }

ModMagicNumbersFileAdd("mods/noita.fairmod/files/magic_numbers.xml")

--- I hate doing things without a hook
function OnModPostInit()
	dofile_once("mods/noita.fairmod/files/content/enemy_reworks/reworks.lua")
	dofile_once("mods/noita.fairmod/files/content/water_is_bad/fuck_water.lua")
	dofile_once("mods/noita.fairmod/files/content/langmix/init.lua")
end

--- Seed init
function OnMagicNumbersAndWorldSeedInitialized()
	dofile_once("mods/noita.fairmod/files/content/butts/init.lua")
	tm_trainer.OnMagicNumbersAndWorldSeedInitialized()
	gamblecore.PostWorldState()
	funky_portals.OnMagicNumbersAndWorldSeedInitialized()
	dofile_once("mods/noita.fairmod/files/content/starting_inventory/tweak_inventory.lua")
	dofile_once("mods/noita.fairmod/files/content/kolmi_not_home/init.lua")

end

function OnPlayerSpawned(player)

	GameRemoveFlagRun("pause_snail_ai")
	GameRemoveFlagRun("draw_evil_mode_text")

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

	SetRandomSeed(2152, 12523)
	
	if(Random(1, 100) <= 50)then
		GameAddFlagRun("kolmi_not_home")
		print("Kolmi is not home on this one.")
		
	end

	-- stuff after here only runs once on initial run start

	tm_trainer.OnPlayerSpawned(player)
	funky_portals.OnPlayerSpawned(player)

	local plays = tonumber(ModSettingGet("fairmod.plays")) or 0
	plays = plays + 1
	ModSettingSet("fairmod.plays", plays)

	heartattack.OnPlayerSpawned(player)

	crits.OnPlayerSpawned(player)

	clipboard.OnPlayerSpawned(player)

	evil_nuggets.OnPlayerSpawned(player)

	-- enable physics damage on the player
	local damage_model_comp = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
	if damage_model_comp then
		ComponentSetValue2(damage_model_comp, "physics_objects_damage", true)
	end

	EntityLoad("mods/noita.fairmod/files/content/rotate/rotta-cart.xml", 470, -105.100)

	EntityAddComponent2(player, "LuaComponent", {
		script_source_file = "mods/noita.fairmod/files/content/piss/player_immersion.lua",
		execute_every_n_frame = 1,
		execute_on_added = true,
	})
end

ModRegisterAudioEventMappings("mods/noita.fairmod/GUIDs.txt")

function OnWorldPreUpdate()
	if GameGetFrameNum() % 30 == 0 then
		fuckedupenemies:OnWorldPreUpdate()
		dofile("mods/noita.fairmod/files/content/immortal_snail/scripts/spawn_snail.lua")
	end
	nukes.OnWorldPreUpdate()
	input_delay.OnWorldPreUpdate()
	trading_cards.update()
	dofile("mods/noita.fairmod/files/content/streamerluck/update.lua")
	dofile("mods/noita.fairmod/files/content/anything_mimics/update.lua")
end

function OnWorldPostUpdate()

end

local time_paused = 0
local last_pause_was_inventory = false
function OnPausePreUpdate()
	time_paused = time_paused + 1

	if(not last_pause_was_inventory and time_paused == 5)then
		GameAddFlagRun("draw_evil_mode_text")
	end
	dofile("mods/noita.fairmod/files/content/misc/draw_pause_evil_mode.lua")
end

function OnPausedChanged(is_paused, is_inventory_pause)
	last_pause_was_inventory = is_inventory_pause
	if(is_paused and not is_inventory_pause)then
		-- regular pause screen
	elseif(is_paused and is_inventory_pause)then
		-- inventory pause screen
	elseif(not is_paused)then
		-- unpaused
		GameRemoveFlagRun("draw_evil_mode_text")
		time_paused = 0
	end
end

-- Copi was here
-- Dexter is here
-- Moldos was here
-- Nathan was here
-- Eba was here :3
-- Lamia wasn't here
-- Circle was here


-----##
----#o##
----###o
---%#o##
---%-##-%
--%--%--%
--%--%--%
--%--%--%
--#--#--#

