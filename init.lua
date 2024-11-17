--stylua: ignore start
local SetContent = ModTextFileSetContent

dofile_once("mods/noita.fairmod/files/content/data_migration/init.lua")
local user_seeds = dofile_once("mods/noita.fairmod/files/content/user_seed/init.lua")

dofile_once("mods/noita.fairmod/files/content/reset_progress/init.lua")
dofile_once("mods/noita.fairmod/files/translations/append.lua")
dofile_once("mods/noita.fairmod/files/lib/DialogSystem/init.lua")("mods/noita.fairmod/files/lib/DialogSystem")

local funny_settings = dofile_once("mods/noita.fairmod/files/content/funny_settings/init.lua")
local fuckedupenemies = dofile_once("mods/noita.fairmod/files/content/fuckedupenemies/fuckedupenemies.lua") --- @type fuckupenemies
local heartattack = dofile_once("mods/noita.fairmod/files/content/heartattack/heartattack.lua")
local nukes = dofile_once("mods/noita.fairmod/files/content/nukes/scripts/nukes.lua")
local tm_trainer = dofile_once("mods/noita.fairmod/files/content/tmtrainer/init.lua")
local crits = dofile_once("mods/noita.fairmod/files/content/crits/init.lua")
local clipboard = dofile_once("mods/noita.fairmod/files/content/clipboard/init.lua")
local gamblecore = dofile_once("mods/noita.fairmod/files/content/gamblecore/init.lua")
local funky_portals = dofile_once("mods/noita.fairmod/files/content/funky_portals/init.lua")
-- local trading_cards = dofile_once("mods/noita.fairmod/files/content/trading_card_game/init.lua")
local evil_nuggets = dofile_once("mods/noita.fairmod/files/content/evil_nuggets/init.lua")
local better_ui = dofile_once("mods/noita.fairmod/files/content/better_ui/better_ui.lua") --- @type better_ui
local loanshark = dofile_once("mods/noita.fairmod/files/content/loan_shark/init.lua")
local achievements = dofile_once("mods/noita.fairmod/files/content/achievements/init.lua") --- @type achievement_ui
local legos = dofile_once("mods/noita.fairmod/files/content/legosfolder/init.lua")
local healthymimic = dofile_once("mods/noita.fairmod/files/content/healthiummimicry/init.lua")
local ping_attack = dofile_once("mods/noita.fairmod/files/content/ping_attack/ping_attack.lua")
local orbs_for_all = dofile_once("mods/noita.fairmod/files/content/orbs_for_all/orbs_for_all.lua")
local surface_bad = dofile_once("mods/noita.fairmod/files/content/surface_bad/init.lua") --- @type surface_bad
local chemical_horror = dofile_once("mods/noita.fairmod/files/content/chemical_horror/init.lua")
local fishing = dofile_once("mods/noita.fairmod/files/content/fishing/init.lua")
local fire = dofile_once("mods/noita.fairmod/files/content/fire/init.lua")
local fakegold = dofile_once("mods/noita.fairmod/files/content/Fakegolds/init.lua")
local candy = dofile_once("mods/noita.fairmod/files/content/candy/init.lua")
local information_kiosk = dofile_once("mods/noita.fairmod/files/content/information_kiosk/init.lua")
local cheats = dofile_once("mods/noita.fairmod/files/content/cheats/init.lua")
local hescoming = dofile_once("mods/noita.fairmod/files/content/hescoming/init.lua")
local smokedogg = dofile_once("mods/noita.fairmod/files/content/smokedogg/init.lua")
local dingus = dofile_once("mods/noita.fairmod/files/content/dingus/init.lua")
local he_watches_you = dofile_once("mods/noita.fairmod/files/content/big_brother/he_watches_you.lua")
local ending_quiz = dofile_once("mods/noita.fairmod/files/content/ending_quiz/init.lua")
local corpses = dofile_once("mods/noita.fairmod/files/content/corpses/init.lua")
local dmca_warning = dofile_once("mods/noita.fairmod/files/content/dmca_warning/init.lua")
local saw = dofile_once("mods/noita.fairmod/files/content/saw/init.lua")
local payphone = dofile_once("mods/noita.fairmod/files/content/payphone/init.lua")
local milk_biome = dofile_once("mods/noita.fairmod/files/content/milk_biome/init.lua")
local secret = dofile_once("mods/noita.fairmod/files/content/secret/init.lua")
local show_user_id = dofile_once("mods/noita.fairmod/files/content/show_user_id/init.lua")
local snail_radar = dofile_once("mods/noita.fairmod/files/content/snail_radar/snail_warning.lua")
local mailbox = dofile_once("mods/noita.fairmod/files/content/mailbox/init.lua")
local popups = dofile_once("mods/noita.fairmod/files/content/popups/init.lua")
local better_world = dofile_once("mods/noita.fairmod/files/content/better_world/init.lua") --planned for NG+
local random_alchemy = dofile_once("mods/noita.fairmod/files/content/random_alchemy/init.lua") --- @type fairmod_random_alchemy
local pixel_scenes = dofile_once("mods/noita.fairmod/files/content/pixelscenes/init.lua") --- @type pixel_scenes

if ModIsEnabled("component-explorer") then dofile("mods/noita.fairmod/files/content/component-explorer/init.lua") end

dofile_once("mods/noita.fairmod/files/content/coveryourselfinoil/coveryourselfinoil.lua")
dofile_once("mods/noita.fairmod/files/content/hm_portal_mimic/init.lua")
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
dofile_once("mods/noita.fairmod/files/content/cauldron/init.lua")
dofile_once("mods/noita.fairmod/files/content/cactus/init.lua")
dofile_once("mods/noita.fairmod/files/content/bad_apple/init.lua")
dofile_once("mods/noita.fairmod/files/content/snowman/init.lua")
dofile_once("mods/noita.fairmod/files/content/runaway_items/init.lua")
dofile_once("mods/noita.fairmod/files/content/scenes_in_pws/init.lua")
dofile_once("mods/noita.fairmod/files/content/shield_generator/init.lua")
dofile_once("mods/noita.fairmod/files/content/permanent_self_damage/init.lua")
dofile_once("mods/noita.fairmod/files/content/mask_box/init.lua")
dofile_once("mods/noita.fairmod/files/content/bananapeel/init.lua")
dofile_once("mods/noita.fairmod/files/content/spooky_skeleton/init.lua")
dofile_once("mods/noita.fairmod/files/content/gold_bananas/init.lua")
dofile_once("mods/noita.fairmod/files/content/rat_wand/init.lua")
dofile_once("mods/noita.fairmod/files/content/entrance_cart/init.lua")
dofile_once("mods/noita.fairmod/files/content/more_aggressive_potions/init.lua")
dofile_once("mods/noita.fairmod/files/content/statue_revenge/init.lua")
dofile_once("mods/noita.fairmod/files/content/new_materium/init.lua")
dofile_once("mods/noita.fairmod/files/content/teleporter_item/init.lua")
dofile_once("mods/noita.fairmod/files/content/new_spells/init.lua")
dofile_once("mods/noita.fairmod/files/content/credits/init.lua")
dofile_once("mods/noita.fairmod/files/content/necopumpkin/init.lua")
dofile_once("mods/noita.fairmod/files/content/stronger_bosses/init.lua")
dofile_once("mods/noita.fairmod/files/content/worse_materials/init.lua")
dofile_once("mods/noita.fairmod/files/content/tnt_thrower/init.lua")
dofile_once("mods/noita.fairmod/files/content/otherworld_shop/init.lua")
dofile_once("mods/noita.fairmod/files/content/mod_compat/init.lua")

ModMaterialsFileAdd("mods/noita.fairmod/files/content/backrooms/materials.xml")
ModMaterialsFileAdd("mods/noita.fairmod/files/content/better_world/materials.xml")


ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita.fairmod/files/content/rework_spells/rework_spells.lua")
ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noita.fairmod/files/content/minus_life/perk.lua")
ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noita.fairmod/files/content/mon_wands/perk.lua")
ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/noita.fairmod/files/content/immortal_snail/gun/scripts/actions.lua" )
ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noita.fairmod/files/content/achievements/hooking/perk.lua")
ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noita.fairmod/files/content/funky_portals/perk.lua")
ModLuaFileAppend( "data/scripts/projectiles/all_spells_stage.lua", "mods/noita.fairmod/files/content/achievements/hooking/all_spells.lua" )


-- Optional imgui dep
imgui = load_imgui and load_imgui({ mod = "noita.fairmod", version = "1.0.0" })

ModMagicNumbersFileAdd("mods/noita.fairmod/files/magic_numbers.xml")

--- I hate doing things without a hook
function OnModPostInit()
	dofile_once("mods/noita.fairmod/files/content/enemy_reworks/reworks.lua")
	dofile_once("mods/noita.fairmod/files/content/water_is_bad/fuck_water.lua")
	dofile_once("mods/noita.fairmod/files/content/fungal_shift/init.lua")
	surface_bad:init()
	random_alchemy:init()
	pixel_scenes:init()
end

--- Seed init
function OnMagicNumbersAndWorldSeedInitialized()
	-- Seed translations changes rng with system time
	local tv = { GameGetDateAndTimeUTC() }
	local seed = tv[6] + tv[5] * 60 + tv[4] * 60 * 60
	math.randomseed(seed)

	dofile_once("mods/noita.fairmod/files/content/langmix/init.lua")
	dofile_once("mods/noita.fairmod/files/content/butts/init.lua")
	dofile_once("mods/noita.fairmod/files/content/translation_shuffle/init.lua")
	--dofile_once("mods/noita.fairmod/files/content/langmix_extras/init.lua") --wretched thing, struggling to make this function with higher min values (different min value seems to break TLs)

	random_alchemy:create()

	dofile_once("mods/noita.fairmod/files/content/backrooms/init.lua")
	tm_trainer.OnMagicNumbersAndWorldSeedInitialized()
	gamblecore.PostWorldState()
	funky_portals.OnMagicNumbersAndWorldSeedInitialized()
	dofile_once("mods/noita.fairmod/files/content/starting_inventory/tweak_inventory.lua")
	dofile_once("mods/noita.fairmod/files/content/kolmi_not_home/init.lua")
	fishing.OnMagicNumbersAndWorldSeedInitialized()
	dofile_once("mods/noita.fairmod/files/content/corrupted_enemies/init.lua")
	fakegold.OnMagicNumbersAndWorldSeedInitialized()
	dofile_once("mods/noita.fairmod/files/content/vanilla_fix/init.lua")

	dofile("mods/noita.fairmod/files/content/file_was_changed/init.lua")

	dofile_once("mods/noita.fairmod/files/content/worse_items/init.lua")
	milk_biome.OnMagicNumbersAndWorldSeedInitialized()
end

function OnPlayerSpawned(player)
	surface_bad:spawn()
	funny_settings.OnPlayerSpawned(player)

	GameRemoveFlagRun("pause_snail_ai")
	GameRemoveFlagRun("draw_evil_mode_text")
	GameRemoveFlagRun("fairmod_dialog_interacting")
	GameRemoveFlagRun("fairmod_scratch_interacting")

	local x, y = EntityGetTransform(player)

	-- move player to a random parallel world.

	SetRandomSeed(x, y)

	local random_pws = { -1, -1, -1, 0, 1, 1, 1 }
	local pw_num = random_pws[Random(1, #random_pws)]

	local map_w = BiomeMapGetSize()
	local offset_x = (map_w * 512 * pw_num)

	local target_x = x + offset_x
	local target_y = y

	EntityApplyTransform(player, target_x, target_y)

	----------------------------------

	if GameHasFlagRun("fairmod_init") then return end
	GameAddFlagRun("fairmod_init")
	-- stuff after here only runs once on initial run start

	dofile_once("mods/noita.fairmod/files/content/rotate/spawn_rats.lua")
	-- you gain the booklet from the information kiosk
	--dofile_once("mods/noita.fairmod/files/content/instruction_booklet/init.lua")

	SetRandomSeed(2152, 12523)

	if Random(1, 100) <= 50 then
		GameAddFlagRun("kolmi_not_home")
		print("Kolmi is not home on this one.")
	end

	tm_trainer.OnPlayerSpawned(player)
	funky_portals.OnPlayerSpawned(player)
	fishing.OnPlayerSpawned(player)
	secret.init()

	local plays = tonumber(ModSettingGet("fairmod.plays")) or 0
	plays = plays + 1
	ModSettingSet("fairmod.plays", plays)

	heartattack.OnPlayerSpawned(player)

	crits.OnPlayerSpawned(player)

	clipboard.OnPlayerSpawned(player)

	evil_nuggets.OnPlayerSpawned(player)

	legos.OnPlayerSpawned(player)

	healthymimic.OnPlayerSpawned(player)

	fire.OnPlayerSpawned(player)

	information_kiosk.OnPlayerSpawned(target_x, target_y, player)

	mailbox.spawn(target_x, target_y)

	ending_quiz.spawn_shape(target_x, target_y)

	dingus.OnPlayerSpawned(player)

	corpses.OnPlayerSpawned(player)

	dmca_warning.OnPlayerSpawned(player)

	saw.OnPlayerSpawned(player)

	user_seeds.OnPlayerSpawned(player)
	
	-- enable physics damage on the player
	local damage_model_comp = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
	if damage_model_comp then ComponentSetValue2(damage_model_comp, "physics_objects_damage", true) end

	EntityAddComponent2(player, "LuaComponent", {
		script_source_file = "mods/noita.fairmod/files/content/piss/player_immersion.lua",
		execute_every_n_frame = 1,
		execute_on_added = true,
	})

	EntityAddComponent2(player, "LuaComponent", {
		script_source_file = "mods/noita.fairmod/files/content/betterthrow/adjust.lua",
		execute_every_n_frame = 1,
	})

	-- debugging
	-- EntityLoad("mods/noita.fairmod/files/content/funky_portals/return_portal.xml", target_x, target_y - 30)
	--EntityLoad("mods/noita.fairmod/files/content/gamblecore/slotmachine.xml", target_x, target_y)
end

ModRegisterAudioEventMappings("mods/noita.fairmod/GUIDs.txt")

function OnWorldPreUpdate()
	ModTextFileSetContent = SetContent

	GameRemoveFlagRun("fairmod_interacted_with_anything_this_frame")

	local frames = GameGetFrameNum()
	if frames % 30 == 0 then
		fuckedupenemies:OnWorldPreUpdate()
		orbs_for_all:update()
		surface_bad:update()
		he_watches_you:update()
		dofile("mods/noita.fairmod/files/content/immortal_snail/scripts/spawn_snail.lua")
	end
	nukes.OnWorldPreUpdate()
	-- trading_cards.update()
	dofile("mods/noita.fairmod/files/content/streamerluck/update.lua")
	dofile("mods/noita.fairmod/files/content/anything_mimics/update.lua")
	better_ui:update()
	loanshark.update()
	achievements:update()
	ping_attack.update()
	cheats.update()
	hescoming.update()
	smokedogg.update()
	payphone.update()
	secret.update()
	snail_radar.update()

	gamblecore.Update()

	if GameHasFlagRun("ending_game_completed") and not GameHasFlagRun("incremented_win_count") then
		GameAddFlagRun("incremented_win_count")
		-- GlobalsSetValue("fairmod_win_count", tostring(tonumber(GlobalsGetValue("fairmod_win_count", "0")) + 1))
		ModSettingSet("fairmod_win_count", (ModSettingGet("fairmod_win_count") or 0) + 1)
	end
end

function OnWorldPostUpdate() end

local time_paused = 0
local last_pause_was_inventory = false
function OnPausePreUpdate()
	show_user_id.OnPausePreUpdate()
	time_paused = time_paused + 1

	if not last_pause_was_inventory and time_paused == 5 then GameAddFlagRun("draw_evil_mode_text") end
	dofile("mods/noita.fairmod/files/content/misc/draw_pause_evil_mode.lua")
end

function OnWorldInitialized()
	popups.OnWorldInitialized()
	user_seeds.OnWorldInitialized()
	--better_world.OnWorldInitialized()
end

function OnPausedChanged(is_paused, is_inventory_pause)
	show_user_id.OnPausedChanged(is_paused, is_inventory_pause)
	last_pause_was_inventory = is_inventory_pause
	if is_paused and not is_inventory_pause then
		-- regular pause screen
		funny_settings.OnPausedChanged()
	elseif is_paused and is_inventory_pause then
		-- inventory pause screen
	elseif not is_paused then
		-- unpaused
		GameRemoveFlagRun("draw_evil_mode_text")
		time_paused = 0
	end
end

function OnPlayerDied(player)
	if not GameHasFlagRun("ending_game_completed") then
		ModSettingSet("fairmod.deaths", (ModSettingGet("fairmod.deaths") or 0) + 1)
	end
	hescoming.OnPlayerDied(player)
	corpses.OnPlayerDied(player)
end

-- Copi was here
-- Dexter is here
-- Moldos was here
-- Nathan was here
-- Eba was here :3
-- Lamia wasn't here
-- Circle was here
-- Hamis will be here
-- Conga wuz here
-- Heinermann was here
-- Seeker was here
-- Horscht may have been here
-- Dunk is bald
-- Scipio was here
-- UserK.

--     ##
--    #o##
--    ###o
--   %#o##
--   % ## %
--  %  %  %
--  %  %  %
--  %  %  %
--  #  #  #

--            ▒▒▒▒▒▒▒▒
--            ▒▒▒▒▒▒▒▒
--        ▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒
--        ▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒
--        ▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓
--        ▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓
--    ░░░░▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒
--    ░░░░▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒
--    ░░░░    ▒▒▒▒▒▒▒▒    ░░░░
--    ░░░░    ▒▒▒▒▒▒▒▒    ░░░░
--░░░░        ░░░░        ░░░░
--░░░░        ░░░░        ░░░░
--░░░░        ░░░░        ░░░░
--░░░░        ░░░░        ░░░░
--░░░░        ░░░░        ▒▒▒▒
--░░░░        ░░░░        ▒▒▒▒
--▒▒▒▒        ▒▒▒▒
--▒▒▒▒        ▒▒▒▒

--▓▒░ nabbed from whoever made the one in noita.fairmod/settings.lua

--[[                                                       
                                                                                                                                            
                                            .....:::::...                                           
                                           .::^^^^^^^^^:..                                          
                                         ..:^~!!!!!!~~~^:..                                         
                                      ..:^~!?JYYJJ?7!~~^:::...                                      
                                    ..::^~7J5PGGP5J7!~^^^^^^::..                                    
                                    .::^~!?YPGBBG5J7!~~~~!!!~~^:.                                   
                                    .:^~~!7?JYYYJ?7!~~!7?JYYJ?!^.                                   
                                    .:^~~~!!!!!!!~~~~~7JYPGGPY?~:                                   
                                   ..:^~~~!!!!!!~~~~~~7J5GBBG5?~:                                   
                                ....:^^~~!7??JJJJ?7!~~!7JY55Y?!^.                                   
                              ...:::^^^~~!?Y5GGGP5J7!~~~!!77!~^:.                                   
                              ..:::^^^^^~!7J5GBBG5J7!~^^^^^^^::..                                   
                              ..::^^:::::^~7?JYYYJ?7!~~^^::..........                               
                              ..:::::..  .:^~!!!7!!!!~~^:..  ...::::..                              
                             ...::::..     .:^^^~~~~~^^:..    .:::::..                              
                         ............      .::^^^^::::..      .:::::..                              
                        ..:::::..         ..::::::...        ..:::::..                              
                       ..::::::..         ..:::::..          ..:::::..                              
                       ..::::::..         ..:::::..          ..:::::..                              
                       ..::::::..         ..:::::..          ..:::::..                              
                       ..::::::..         ..::::::..         ...::::...                             
                       ..::::::..         ..::::::..           .............                        
                       ..::::::..         ..::::::..               ..:::::..                        
                       ...:::::..         ..:::::...               ..::::::..                       
                        ..::::...         ...::::..                ...::::..                        
                       ...:::::..         ..:::::...               ..:::::...                       
                       ..:^^^^::.         .::^^^^:..               .::^^^^:..                       
                       .:^~!!~^:.         .:^~!!~^:.               .:^~!!~^:.                       
                       .^~!77!~^:.       .:^~!77!~^.              .:^~!77!~^.                       
                       .:^~~~~^:.         .:^~~~~^:.               .:^~~~~^:.                       
                        ..::::...         ...::::..                ...::::..                        
                                                                                                    

--nabbed from Immersive Mimics, absolutely wretch of a mod ]]
-- best mod of 202X

-- ↓ anti-nathan wards my beloved
--stylua: ignore end
