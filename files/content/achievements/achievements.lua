dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")
dofile_once("mods/noita.fairmod/files/content/fishing/definitions/fish_list.lua")

achievements = {
	{
		name = "Shitted",
		description = "You shitted and farted!!!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/shitted.png",
		flag = "achievement_shitted",
		unlock = function()
			return GlobalsGetValue("TIMES_TOOK_SHIT", "0") ~= "0"
		end,
	},
	{
		name = "Time to take a piss!",
		description = "You emptied your bladder.",
		icon = "mods/noita.fairmod/files/content/achievements/icons/pisser.png",
		flag = "achievement_pissed",
		unlock = function()
			return GlobalsGetValue("TIMES_TOOK_PISS", "0") ~= "0"
		end,
	},
	{
		name = "Poop Ending",
		description = "And thus, the world was turned to shit.",
		icon = "mods/noita.fairmod/files/content/achievements/icons/shitworld.png",
		flag = "achievement_poop_ending",
		unlock = function()
			return GameHasFlagRun("poop_ending")
		end,
	},
	{
		name = "Bankruptcy",
		description = "Collect a debt of 10k gold or more.",
		icon = "mods/noita.fairmod/files/content/achievements/icons/uber_debt.png",
		flag = "achievement_debt_collector",
		unlock = function()
			return tonumber(GlobalsGetValue("loan_shark_debt", "0")) >= 10000
		end,
	},
	{
		name = "Speedrunner",
		description = "Enter the speedrun door.",
		icon = "mods/noita.fairmod/files/content/achievements/icons/speedrun.png",
		flag = "achievement_speedrunner",
		unlock = function()
			return GameHasFlagRun("speedrun_door_used")
		end,
	},
	{
		name = "What have you done",
		description = "What did they do to deserve this?",
		icon = "mods/noita.fairmod/files/content/achievements/icons/hamis_massacre.png",
		flag = "achievement_hamis_killed",
		unlock = function()
			return (tonumber(GlobalsGetValue("FAIRMOD_HAMIS_KILLED")) or 0) > 5
		end,
	},
	{
		name = "Too many acid",
		description = "Did it bothered you?",
		icon = "mods/noita.fairmod/files/content/achievements/icons/giant_shooter.png",
		flag = "achievement_giantshooter_killed",
		unlock = function()
			return GameHasFlagRun("FAIRMOD_GIANTSHOOTER_KILLED")
		end,
	},
	{
		name = "The Things In Question",
		description = "Peak content unlocked! :check:",
		icon = "mods/noita.fairmod/files/content/achievements/icons/copis_things.png",
		flag = "achievement_copis_things",
		unlock = function()
			return ModIsEnabled("copis_things")
		end,
	},
	{
		name = "Sucks to Suck",
		description = "Got giga critted!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/giga_critted.png",
		flag = "achievement_giga_critted",
		unlock = function()
			return GameHasFlagRun("giga_critted_lol")
		end,
	},
	{
		name = "Take to the Skies",
		description = "help how do i get down what im gonna hit the roof ow fuck",
		icon = "mods/noita.fairmod/files/content/achievements/icons/oiled_up.png",
		flag = "achievement_oiled_up",
		unlock = function()
			return GameHasFlagRun("oiled_up")
		end,
	},
	{
		name = "Ow Fuck",
		description = "You had a heart attack!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/heart_attacked.png",
		flag = "achievement_heart_attacked",
		unlock = function()
			return GameHasFlagRun("heart_attacked")
		end,
	},
	{
		name = "Add mana: Balanced",
		description = "Game quality +500%",
		icon = "mods/noita.fairmod/files/content/achievements/icons/hahah_fuck_your_mana.png",
		flag = "achievement_hahah_fuck_your_mana",
		unlock = function()
			return GameHasFlagRun("hahah_fuck_your_mana")
		end,
	},
	{
		name = "Avoided Heart Attack!",
		description = "Epic heart health win!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/fake_heart_attack.png",
		flag = "achievement_fake_heart_attack",
		unlock = function()
			return #(GetPlayers()) >= 1 and Random(1, 108000) == 1
		end,
	},
	{
		name = "Degraded Game Experience",
		description = "Why!?!> Disable nightmare.",
		icon = "mods/noita.fairmod/files/content/achievements/icons/nighmare_mode.png",
		flag = "achievement_nighmare_mode",
		unlock = function()
			return ModIsEnabled("nightmare")
		end,
	},
	{
		name = "Just.. one.. more...",
		description = "99% gamblers quit before big win! Next roll = $5m payout",
		icon = "mods/noita.fairmod/files/content/achievements/icons/gamble_fail.png",
		flag = "achievement_gamble_fail",
		unlock = function()
			return tonumber(GlobalsGetValue("GAMBLECORE_TIMES_LOST_IN_A_ROW", "0")) > 5
		end,
	},
	{
		name = "Gamble God",
		description = "Winnar is you!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/gamble_win.png",
		flag = "achievement_gamble_win",
		unlock = function()
			return tonumber(GlobalsGetValue("GAMBLECORE_TIMES_WON", "0")) >= 1
		end,
	},
	{
		name = "Gambling is Fun!",
		description = "Next might be TWWE! Reroll more!!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/reroll_destiny.png",
		flag = "achievement_reroll_destiny",
		unlock = function()
			return tonumber(GlobalsGetValue("TEMPLE_PERK_REROLL_COUNT", "0")) >= 1
		end,
	},
	{
		name = "Gambling is Fun! II",
		description = "Who knows what might be next?",
		icon = "mods/noita.fairmod/files/content/achievements/icons/reroll_destiny2.png",
		flag = "achievement_reroll_destiny2",
		unlock = function()
			return tonumber(GlobalsGetValue("TEMPLE_PERK_REROLL_COUNT", "0")) >= 3
		end,
	},
	{
		name = "Gambling is Fun! III",
		description = "Next achievement at 100 rerolls!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/reroll_destiny3.png",
		flag = "achievement_reroll_destiny3",
		unlock = function()
			return tonumber(GlobalsGetValue("TEMPLE_PERK_REROLL_COUNT", "0")) >= 5
		end,
	},
	{
		name = "Player",
		description = "You played the game!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/player.png",
		flag = "achievement_player",
		unlock = function()
			return GameGetFrameNum() > 25
		end,
	},
	{
		name = "Perked Up!",
		description = "Perk get!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/perked_up.png",
		flag = "achievement_perked_up",
		unlock = function()
			return GameHasFlagRun("picked_perk_acheev")
		end,
	},
	{
		name = "What have you done!!",
		description = "You've doomed us all!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/holy_shit_danger.png",
		flag = "achievement_holy_shit_danger",
		unlock = function()
			return GameHasFlagRun("holy_shit_danger")
		end,
	},
	{
		name = "Portal Malfunction",
		description = "Be sent to the wrong location by a portal.",
		icon = "mods/noita.fairmod/files/content/achievements/icons/portal_malfunction.png",
		flag = "achievement_portal_malfunction",
		unlock = function()
			return GameHasFlagRun("portal_malfunction")
		end,
	},
	{
		name = "Fishing Novice",
		description = "You caught your first fish!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/fishing_1.png",
		flag = "achievement_fishing_novice",
		unlock = function()
			return GlobalsGetValue("fish_caught", "0") ~= "0"
		end,
	},
	{
		name = "Wrangling Literature",
		description = "You caught a tablet.",
		icon = "mods/noita.fairmod/files/content/achievements/icons/tablet.png",
		flag = "has_tablet",
		unlock = function()
			return HasInventoryItemTag("tablet")
		end,
	},
	{
		name = "Baby Steps",
		description = "You died :(",
		icon = "mods/noita.fairmod/files/content/achievements/icons/dead.png",
		flag = "achievement_dead",
		unlock = function()
			return StatsGetValue("dead") ~= "0"
		end,
	},
	{
		name = "Jeffrey Preston Bezos ",
		description = "Approx Net Worth: $ 2.147B",
		icon = "mods/noita.fairmod/files/content/achievements/icons/infinite_gold.png",
		flag = "achievement_infinite_gold",
		unlock = function()
			return StatsGetValue("gold_infinite") ~= "0"
		end,
	},
	{
		name = "Drip Supreme",
		description = "Unmatched Swagger",
		icon = "mods/noita.fairmod/files/content/achievements/icons/drip_supreme.png",
		flag = "drip_supreme",
		unlock = function()
			return HasFlagPersistent("secret_amulet_gem") and HasFlagPersistent("secret_hat")
		end,
	},
	{
		name = "Smoked a weed",
		description = "You met the godfather of weed and he gave you his blessing",
		icon = "mods/noita.fairmod/files/content/achievements/icons/smoked_weed.png",
		flag = "smoked_a_weed",
		unlock = function()
			return GameHasFlagRun("smoke_dogg_spoke")
		end,
	},
	{
		name = "Play at 3:33am",
		description = "He's coming",
		icon = "mods/noita.fairmod/files/content/achievements/icons/play_at_333am.png",
		flag = "play_at_333am",
		unlock = function()
			local year, month, day, hour, minute, second = GameGetDateAndTimeLocal()
			return hour == 3 and minute == 33
		end,
	},
	{
		name = "Banana Peelionaire",
		description = "Slip on 10 banana peels in one run",
		icon = "mods/noita.fairmod/files/content/achievements/icons/banana_peelionaire.png",
		flag = "banana_peelionaire",
		unlock = function()
			return tonumber(GlobalsGetValue("fairmod_banana_peels_activated", "0")) >= 10
		end,
	},
	{
		name = "YOU BLITHING IDIOT",
		description = "ITS THE RUN'S SEED NOT [YOUR WORLD SEED]",
		icon = "mods/noita.fairmod/files/content/achievements/icons/idiot.png",
		flag = "blithingidiot",
		unlock = function()
			return GameHasFlagRun("YOUBLITHINGIDIOT")
		end,
	},
	{
		name = "Throw a booklet",
		description = "Welcome to fairmod",
		icon = "mods/noita.fairmod/files/content/instruction_booklet/booklet_entity/booklet_inventory.png",
		flag = "throw_a_booklet",
		unlock = function()
			return GameHasFlagRun("fairmod_booklet_died")
		end,
	},
	{
		name = "Snail Eater",
		description = "You monster",
		icon = "mods/noita.fairmod/files/content/pixelscenes/snail/effect/snail_eater_icon.png",
		flag = "snail_eaten",
		unlock = function()
			return GameHasFlagRun("fairmod_snail_eaten")
		end,
	},
	{
		name = "Hämis Believer",
		description = "You have been converted and accepted Lord Hämis",
		icon = "mods/noita.fairmod/files/content/achievements/icons/hamis_believer.png",
		flag = "hamis_believer",
		unlock = function()
			return GameHasFlagRun("fairmod_longest_content")
		end,
	},
	{
		name = "Hämis Heretic",
		description = "Lord Hämis is disappointed",
		icon = "mods/noita.fairmod/files/content/achievements/icons/hamis_heretic.png",
		flag = "hamis_heretic",
		unlock = function()
			return GameHasFlagRun("fairmod_longest_disappointed")
		end,
	},
	{
		name = "Teleporter",
		description = "This can only end well",
		icon = "mods/noita.fairmod/files/content/achievements/icons/teleporter.png",
		flag = "teleporter",
		unlock = function()
			return (tonumber(GlobalsGetValue("TELEPORTER_USES")) or 0) > 0
		end,
	},
	{
		name = "Master of Crashing",
		description = "Got you",
		icon = "mods/noita.fairmod/files/content/achievements/icons/wizard_crash.png",
		flag = "wizard_crash",
		unlock = function()
			return HasFlagPersistent("crashed_by_wizard")
		end,
	},
	{
		name = "Freedom",
		description = "You set him free",
		icon = "mods/noita.fairmod/files/content/achievements/icons/joel_free.png",
		flag = "fish_is_free",
		unlock = function()
			return GameHasFlagRun("fairmod_fish_is_free")
		end,
	},
	{
		name = "Copi Malware!",
		description = "Download Copi's Things!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/copi_malware.png",
		flag = "copi_malware",
		unlock = function()
			return GameHasFlagRun("COPI_IMMERSIVE_MIMICS")
		end,
	},
	{
		name = "PEDRO",
		description = "PEDRO PEDRO PEDRO",
		icon = "mods/noita.fairmod/files/content/new_spells/racoon/icon.png",
		flag = "pedro_found",
		unlock = function()
			return HasFlagPersistent("action_fairmod_pedro")
		end,
	},
	{
		name = "Trick or Treat",
		description = "Successfully go trick or treating!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/trickortreat.png",
		flag = "trt",
		unlock = function()
			return GameHasFlagRun("fairmod_trickortreated")
		end,
	},
	{
		name = "Noitillionare!",
		description = "Be a winning contestant on who wants to be a noitillionare!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/noitillionare.png",
		flag = "quiz_winner",
		unlock = function()
			return HasFlagPersistent("fairmod_noitillionare_winner")
		end,
	},
	{
		name = "Happy Birthday",
		description = "Are you michael?",
		icon = "mods/noita.fairmod/files/content/rat_wand/gfx/rat_bite_ui.png",
		flag = "rat_birthday_dialogue",
		unlock = function()
			return GameHasFlagRun("fairmod_rat_birthday_dialogue")
		end,
	},
	{
		name = "Winter is Coming!",
		description = "Get hit by a snowball.",
		icon = "mods/noita.fairmod/files/content/achievements/icons/snowman.png",
		flag = "hit_by_snowball",
		unlock = function()
			return GameHasFlagRun("fairmod_snowball_hit")
		end,
	},
	{
		name = "Coming for Winter!",
		description = "Catch a snowball.",
		icon = "mods/noita.fairmod/files/content/achievements/icons/snowball_pile.png",
		flag = "has_snowball",
		unlock = function()
			return HasInventoryItemTag("snowball")
		end,
	},
	{
		name = "Loathsome Piss Drinker",
		description = "Drink a gallon of piss.",
		icon = "mods/noita.fairmod/files/content/achievements/icons/piss_drinker.png",
		flag = "loathsome_piss_drinker",
		unlock = function()
			return GameHasFlagRun("fairmod_piss_drinker")
		end,
	},
	{
		name = "Killed the Snail",
		description = "It will return.",
		icon = "mods/noita.fairmod/files/content/achievements/icons/snail_telefrag.png",
		flag = "snail_telefrag",
		unlock = function()
			return tonumber(GlobalsGetValue("FAIRMOD_SNAIL_TELEFRAGS", "0")) > 0
		end,
	},
	{
		name = "Minus Life",
		description = "Does what is says on the tin.",
		icon = "mods/noita.fairmod/files/content/achievements/icons/minus_life.png",
		flag = "minus_life",
		unlock = function()
			return GameHasFlagRun("PERK_PICKED_MINUS_LIFE")
		end,
	},
	{
		name = "Banging Tunes",
		description = "Tune 10 radios",
		icon = "mods/noita.fairmod/files/content/achievements/icons/10_radios.png",
		flag = "achievement_10_radios", --i put achievement_ cuz i didnt know about the automatic fairmod_ prefixer, leaving it as is cuz its harmless and changing achievement ID is a bad idea imo
		unlock = function()
			return GameHasFlagRun("10_radios_tuned")
		end,
	},
	{
		name = "Stop it!!",
		description = "There is no secret radio ending!!!!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/28_radios.png",
		flag = "achievement_28_radios",
		unlock = function()
			return GameHasFlagRun("28_radios_tuned")
		end,
	},
	{
		name = "Appeased the old god",
		description = "His boons are yours",
		icon = "mods/noita.fairmod/files/content/achievements/icons/copi_evil.png",
		flag = "copi_evil",
		unlock = function()
			return HasFlagPersistent("fairmod_copi_evil_letter")
		end,
	},
	{
		name = "THREAT ASSESSED",
		description = "ENABLING T.R.O.L.L. UNITS",
		icon = "mods/noita.fairmod/files/content/achievements/icons/threat_level.png",
		flag = "fair_risk",
		unlock = function()
			return tonumber(GlobalsGetValue("STEVARI_DEATHS", "0")) >= 84
		end,
	},
	{
		name = "Copibuddy! :D",
		description = "Met your best friend!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/copibuddy.png",
		flag = "copibuddy",
		unlock = function()
			return GameHasFlagRun("is_copibuddied")
		end,
	},
	{
		name = "Snail Slayer",
		description = "yoiure french",
		icon = "mods/noita.fairmod/files/content/achievements/icons/snailkill.png",
		flag = "snailkill",
		unlock = function()
			return GameHasFlagRun("snailkill")
		end,
	},
	{
		name = "My Gift unto You",
		description = "You're 1 closer to 100%!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/copibuddy2.png",
		flag = "copibuddy2",
		unlock = function()
			return HasFlagPersistent("copibuddy_acheev")
		end,
	},
	{
		name = "COPROTECTION ANTIVRIUS",
		description = "Protecting users from scam callers since 283 BC!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/copibuddy3.png",
		flag = "copibuddy3",
		unlock = function()
			return GameHasFlagRun("copibuddy.call_rerouted")
		end,
	},
	{
		name = "Infinite Karmic Debt",
		description = "You're a dirty cheater",
		icon = "mods/noita.fairmod/files/content/achievements/icons/karmic_debt.png",
		flag = "karmic_debt",
		unlock = function()
			return GameHasFlagRun("infinite_karmic_debt")
		end,
	},
}

local function romanize(num)
	local result = ""
	for _, value in ipairs({
		{ 1000, "M" },
		{ 900, "CM" },
		{ 500, "D" },
		{ 400, "CD" },
		{ 100, "C" },
		{ 90, "XC" },
		{ 50, "L" },
		{ 40, "XL" },
		{ 10, "X" },
		{ 9, "IX" },
		{ 5, "V" },
		{ 4, "IV" },
		{ 1, "I" },
	}) do
		local count = math.floor(num / value[1])
		num = num % value[1]
		result = result .. string.rep(value[2], count)
	end
	return result
end

-- local ach_len = #achievements
-- for i = 1, 10 do
-- 	achievements[ach_len + i] = {
-- 		name = "Godslayer " .. romanize(i),
-- 		description = (function(chars)
-- 			local sets = { { 97, 122 }, { 65, 90 }, { 48, 57 } } -- a-z, A-Z, 0-9
-- 			local str = { "" }
-- 			for p = 1, chars do
-- 				local charset = sets[math.random(1, #sets)]
-- 				str[#str + 1] = string.char(math.random(charset[1], charset[2]))
-- 			end
-- 			return table.concat(str)
-- 		end)(i * 2),
-- 		icon = table.concat({ "mods/noita.fairmod/files/content/achievements/icons/god_slayer_", i, ".png" }),
-- 		flag = "god_slayer_" .. i,
-- 		unlock = function()
-- 			return tonumber(GlobalsGetValue("STEVARI_DEATHS", "0")) >= i
-- 		end,
-- 	}
-- end

for i = 1, 10 do
	table.insert(achievements, {
		name = "Fire In The Hole " .. romanize(i),
		description = "You shot " .. tostring(2 ^ i) .. " times!",
		icon = table.concat({ "mods/noita.fairmod/files/content/achievements/icons/shot_count_", i, ".png" }),
		flag = "shot_count_" .. i,
		unlock = function()
			return tonumber(StatsGetValue("projectiles_shot")) >= 2 ^ i
		end,
	})
end

for i = 1, 10 do
	table.insert(achievements, {
		name = "Nice Catch! " .. romanize(i),
		description = "Gained 10 fishing power.",
		icon = "mods/noita.fairmod/files/content/achievements/icons/KILL_FISH.png",
		flag = "nice_catch_" .. i,
		unlock = function()
			local got = GameHasFlagRun("killed_boss_fish")
			GameRemoveFlagRun("killed_boss_fish")
			return got
		end,
	})
end

for i = 1, 10 do
	table.insert(achievements, {
		name = "New Kicks " .. romanize(i),
		description = "You kicked " .. tostring(2 ^ i) .. " times!",
		icon = table.concat({ "mods/noita.fairmod/files/content/achievements/icons/kick_count_", i, ".png" }),
		flag = "kick_count_" .. i,
		unlock = function()
			return tonumber(StatsGetValue("kicks")) >= 2 ^ i
		end,
	})
end

for i = 1, 10 do
	table.insert(achievements, {
		name = "Trailblazer " .. romanize(i),
		description = "Current streak:  " .. tostring(2 ^ i),
		icon = table.concat({ "mods/noita.fairmod/files/content/achievements/icons/streak_", i, ".png" }),
		flag = "streak_" .. i,
		unlock = function()
			return tonumber(StatsGetValue("streaks")) >= 2 ^ i
		end,
	})
end

for i = 1, 10 do
	table.insert(achievements, {
		name = "Survivor " .. romanize(i),
		description = "Session Time:  " .. tostring(2 ^ i),
		icon = table.concat({ "mods/noita.fairmod/files/content/achievements/icons/session_time_", i, ".png" }),
		flag = "playtime_" .. i,
		unlock = function()
			return (tonumber(StatsGetValue("playtime")) >= 2 ^ i) and #(GetPlayers()) > 1
		end,
	})
end

for i = 1, 10 do
	table.insert(achievements, {
		name = "Healthy " .. romanize(i),
		description = "That's at least " .. tostring(2 ^ i + 100) .. "max HP!",
		icon = table.concat({ "mods/noita.fairmod/files/content/achievements/icons/max_hp_", i, ".png" }),
		flag = "hp_" .. i,
		unlock = function()
			return tonumber(StatsGetValue("hp")) >= 2 ^ i + 100
		end,
	})
end

for i = 1, 10 do
	table.insert(achievements, {
		name = "Rags to Riches " .. romanize(i),
		description = "Woah $" .. tostring(2 ^ i) .. ", Nice!",
		icon = table.concat({ "mods/noita.fairmod/files/content/achievements/icons/gold_", i, ".png" }),
		flag = "gold_" .. i,
		unlock = function()
			return tonumber(StatsGetValue("gold")) >= 2 ^ i
		end,
	})
end

for i = 1, 10 do
	table.insert(achievements, {
		name = "Brittle Bones Noita " .. romanize(i),
		description = "You've soaked up " .. tostring(2 ^ i * 25) .. " damage!",
		icon = table.concat({ "mods/noita.fairmod/files/content/achievements/icons/damage_taken_", i, ".png" }),
		flag = "damage_taken_" .. i,
		unlock = function()
			return tonumber(StatsGetValue("damage_taken") * 25) >= (2 ^ i) * 25
		end,
	})
end

for i = 1, 10 do
	table.insert(achievements, {
		name = "Monster " .. romanize(i),
		description = tostring(1024 - (2 ^ i)) .. " remain...",
		icon = table.concat({ "mods/noita.fairmod/files/content/achievements/icons/innocent_kills_", i, ".png" }),
		flag = "innocent_kills_" .. i,
		unlock = function()
			return tonumber(GlobalsGetValue("HELPLESS_KILLS", "0")) >= (2 ^ i)
		end,
	})
end

for i = 1, 10 do
	table.insert(achievements, {
		name = "X marks the spot " .. romanize(i),
		description = 2 ^ i .. " digital doubloons yanked from ye pocket",
		icon = table.concat({ "mods/noita.fairmod/files/content/achievements/icons/popups_", i, ".png" }),
		flag = "popups_closed_" .. i,
		unlock = function()
			return tonumber(GlobalsGetValue("POPUPS_CLOSED", "0")) >= (2 ^ i)
		end,
	})
end

achievements[#achievements + 1] = {
	name = "H4X0R",
	description = "3P1C 1337 H4XX B)",
	icon = "mods/noita.fairmod/files/content/achievements/icons/cheater.png",
	flag = "achievement_hax",
	unlock = function()
		return GameHasFlagRun("Epic_leet_hacker")
	end,
}

local biome_achievements = {
	alchemist_secret = {
		name = "Alchemist's Secret Stash",
		description = "Discover the location of the Dark Chest.",
	},
	biome_barren = {
		name = "Skyblock",
		description = "Discover the Barren Temple.",
	},
	biome_boss_sky = {
		name = "Home of The Rock",
		description = "Discover the Kivi Temple.",
	},
	biome_darkness = {
		name = "Sus Sky Island",
		description = "Discover the Ominous Temple.",
	},
	biome_potion_mimics = {
		name = "Castle in the Sky",
		description = "Discover the Henkevä Temple.",
	},
	biome_watchtower = {
		name = "The Tower... It watches",
		description = "Discover the Watchtower.",
	},
	boss_arena = {
		name = "The Typical Boss Room",
		description = "Discover The Laboratory.",
	},
	boss_arena_top = {
		name = "How Do We Furnish It?",
		description = "Discover the empty corner of Temple of the Art.",
	},
	boss_victoryroom = {
		name = "What is this Contraption?",
		description = "Discover The Work.",
	},
	bridge = {
		name = "It's Sturdy I Swear",
		description = "Discover the bridge.",
	},
	clouds = {
		name = "Soft and Fluffy",
		description = "Discover the Cloudscape.",
	},
	coalmine = {
		name = "They Yearn for the Mines",
		description = "Discover the Mines.",
	},
	coalmine_alt = {
		name = "Why is the Coal Slimy?",
		description = "Discover the Collapsed Mines.",
	},
	crypt = {
		name = "They Disbanded the Creative Department",
		description = "Discover the Temple of the Art.",
	},
	desert = {
		name = "Got Sand in my Shoes",
		description = "Discover the Desert.",
	},
	dragoncave = {
		name = "Could be a Massive Omelette",
		description = "Discover the Dragoncave.",
	},
	empty = {
		name = "What's This Gap?",
		description = "Discover the gap above the Frozen Vault.",
	},
	essenceroom = {
		name = "Smells Like Earth",
		description = "Discover the location of the Essence of Earth.",
	},
	essenceroom_air = {
		name = "Smells Like Air",
		description = "Discover the location of the Essence of Air.",
	},
	essenceroom_alc = {
		name = "Smells Like Alcohol",
		description = "Discover the location of the Essence of Spirits.",
	},
	essenceroom_hell = {
		name = "Smells Like Water",
		description = "Discover the location of the Essence of Water.",
	},
	excavationsite = {
		name = "Diggy Diggy Hole",
		description = "Discover the Coal Pits.",
	},
	excavationsite_cube_chamber = {
		name = "I've Become Buddha",
		description = "Discover the Meditation Chamber.",
	},
	friend_1 = {
		name = "Friend Cave 1",
		description = "Discover the first friend cave.",
	},
	friend_2 = {
		name = "Friend Cave 2",
		description = "Discover the second friend cave.",
	},
	friend_3 = {
		name = "Friend Cave 3",
		description = "Discover the third friend cave.",
	},
	friend_4 = {
		name = "Friend Cave 4",
		description = "Discover the fourth friend cave.",
	},
	friend_5 = {
		name = "Friend Cave 5",
		description = "Discover the fifth friend cave.",
	},
	friend_6 = {
		name = "Friend Cave 6",
		description = "Discover the sixth friend cave.",
	},
	fungicave = {
		name = "Smells a Bit Funky",
		description = "Discover the Fungal Caverns.",
	},
	fungiforest = {
		name = "Look At All the Fun Guys!",
		description = "Discover the Overgrown Cavern.",
	},
	funroom = {
		name = "It's Big and it's Funky",
		description = "Discover the giant mushroom.",
	},
	ghost_secret = {
		name = "Forget Anything?",
		description = "Discover the Forgotten Cave.",
	},
	gold = {
		name = "Life is Like a Hurricane...",
		description = "Discover the Gold.",
	},
	gourd_room = {
		name = "Discounted Fruit",
		description = "Discover the gourd room.",
	},
	gun_room = {
		name = "Ammo Included",
		description = "Discover the gun room.",
	},
	hills = {
		name = "Peaceful Scenery",
		description = "Discover the forest.",
	},
	lake = {
		name = "Is This the Ocean?",
		description = "Discover the Lake.",
	},
	lake_deep = {
		name = "Left my Submarine at Home",
		description = "Discover the depths of the Lake.",
	},
	lake_statue = {
		name = "Some Kind of Cult Ritual",
		description = "Discover the Lake island.",
	},
	lava = {
		name = "Hot Lava",
		description = "Discover the Volcanic Lake.",
	},
	lava_90percent = {
		name = "It's HOT Down Here",
		description = "Discover the surface of the Volcanic Lake.",
	},
	lavalake = {
		name = "Great Spot for Fishing",
		description = "Discover the Lava lake.",
	},
	lavalake_pit = {
		name = "ECHO! ECho Echo .. echo...",
		description = "Discover the chasm.",
	},
	lavalake_racing = {
		name = "Zoom Zoom Zoom",
		description = "Discover the Race Track.",
	},
	liquidcave = {
		name = "Oooh Chemistry!",
		description = "Discover the Ancient Laboratory.",
	},
	meat = {
		name = "Tender, Juicy, Savory...",
		description = "Discover the Meat Realm.",
	},
	meatroom = {
		name = "Kolmi But Prepped for Cooking",
		description = "Discover Kolmisilmän Sydän's arena.",
	},
	mestari_secret = {
		name = "The King has Arrived",
		description = "Discover the Throne Room.",
	},
	moon_room = {
		name = "Don't Even Need a Telescope",
		description = "Discover the location of the Moon Radar.",
	},
	mountain_floating_island = {
		name = "Is This Terraria?",
		description = "Discover the Floating Island.",
	},
	mountain_hall = {
		name = "It Begins...",
		description = "Discover the Mountain Hall.",
	},
	mountain_lake = {
		name = "Beautiful Lake",
		description = "Discover the lake in the forest.",
	},
	mountain_left_entrance = {
		name = "Cave of Wonder",
		description = "Discover the Mountain Entrance.",
	},
	mountain_right = {
		name = "On the Other Side",
		description = "Discover the right side of the mountain.",
	},
	mountain_top = {
		name = "It's a... Volcano?",
		description = "Discover the top of the mountain.",
	},
	mountain_tree = {
		name = "Big. Hard. Wood.",
		description = "Discover the Giant Tree.",
	},
	mystery_teleport = {
		name = "Entrance to the Tower",
		description = "Discover the portal to the Tower.",
	},
	null_room = {
		name = "Perks? Reset?",
		description = "Discover the Nullifying Altar.",
	},
	ocarina = {
		name = "Music is my Passion",
		description = "Discover the Huilu altar.",
	},
	orbroom_02 = {
		name = "Orb Room 1",
		description = "Discover the first Orb Room.",
	},
	orbroom_04 = {
		name = "Orb Room 2",
		description = "Discover the second Orb Room.",
	},
	orbroom_05 = {
		name = "Orb Room 3",
		description = "Discover the third Orb Room.",
	},
	orbroom_06 = {
		name = "Orb Room 4",
		description = "Discover the fourth Orb Room.",
	},
	orbroom_07 = {
		name = "ABBC",
		description = "Discover the fifth Orb Room.",
	},
	orbroom_08 = {
		name = "Orb Room 6",
		description = "Discover the sixth Orb Room.",
	},
	orbroom_09 = {
		name = "Orb Room 7",
		description = "Discover the seventh Orb Room.",
	},
	orbroom_10 = {
		name = "Orb Room 8",
		description = "Discover the eighth Orb Room.",
	},
	pyramid = {
		name = "Indiana Jones",
		description = "Discover the interior of the Pyramid.",
	},
	pyramid_entrance = {
		name = "Open Sesame",
		description = "Discover the entrance to the Pyramid.",
	},
	pyramid_hallway = {
		name = "Don't Anger the Mummy",
		description = "Discover the entrance hallway inside the Pyramid.",
	},
	pyramid_left = {
		name = "Stairs to the Sky",
		description = "Discover the left side of the Pyramid.",
	},
	pyramid_right = {
		name = "Bumpy Slide",
		description = "Discover the right side of the Pyramid.",
	},
	pyramid_top = {
		name = "Praise the Sun",
		description = "Discover the top of the Pyramid.",
	},
	rainforest = {
		name = "Welcome to the Jungle",
		description = "Discover the upper Underground Jungle.",
	},
	rainforest_dark = {
		name = "Blenders with Legs",
		description = "Discover the Lukki Lair.",
	},
	rainforest_open = {
		name = "I Hate the Vines",
		description = "Discover the lower Underground Jungle.",
	},
	roadblock = {
		name = "Can You Make it Up There?",
		description = "Discover the Giant Tree branch.",
	},
	robobase = {
		name = "Unlimited Power!",
		description = "Discover the Power Plant.",
	},
	roboroom = {
		name = "The Terminator",
		description = "Discover the Kolmisilmän Silmä's arena.",
	},
	robot_egg = {
		name = "Dr. Robotnik Would be Proud",
		description = "Discover the robotic egg.",
	},
	rock_room = {
		name = "Music to my Hands",
		description = "Discover the location of the Kuulokivi.",
	},
	sandcave = {
		name = "Hiisi are Everywhere",
		description = "Discover the Sandcave.",
	},
	scale = {
		name = "Balanced. As All Things Should Be.",
		description = "Discover the Scale.",
	},
	secret_lab = {
		name = "You When You're Older",
		description = "Discover the Abandoned Alchemy Lab.",
	},
	snowcastle = {
		name = "Casually Invading Their Home...",
		description = "Discover the Hiisi Base.",
	},
	snowcastle_cavern = {
		name = "Side Market",
		description = "Discover the Secret Shop.",
	},
	snowcastle_hourglass_chamber = {
		name = "Time is Relative",
		description = "Discover the Hourglass Chamber.",
	},
	snowcave = {
		name = "Let's Build a Snowman!",
		description = "Discover the Snowy Depths.",
	},
	snowcave_secret_chamber = {
		name = "snowcave_secret_chamber",
		description = "Discover the Buried Eye Room.",
	},
	snowcave_tunnel = {
		name = "Found the Back Entrance",
		description = "Discover the bottom of the chasm.",
	},
	solid_wall = {
		name = "Yep, it's Solid!",
		description = "Discover an extremely dense rock wall.",
	},
	solid_wall_hidden_cavern = {
		name = "Oooh Treasure!",
		description = "Discover the Hidden Gold Cave.",
	},
	solid_wall_temple = {
		name = "Walls of The Work",
		description = "Discover the walls of The Work.",
	},
	solid_wall_tower = {
		name = "The Curse",
		description = "Discover the cursed rock.",
	},
	solid_wall_tower_1 = {
		name = "Mines Again...",
		description = "Discover the Mines in The Tower.",
	},
	solid_wall_tower_10 = {
		name = "Finally Made it to the Top",
		description = "Discover The Tower's treasure.",
	},
	solid_wall_tower_2 = {
		name = "Coal Pits Again...",
		description = "Discover the Coal Pits in The Tower.",
	},
	solid_wall_tower_3 = {
		name = "Snowy Depths Again...",
		description = "Discover the Snowy Depths in The Tower.",
	},
	solid_wall_tower_4 = {
		name = "Hiisi Base Again...",
		description = "Discover the Hiisi Base in The Tower.",
	},
	solid_wall_tower_5 = {
		name = "Fungal Caverns Again...",
		description = "Discover the Fungal Caverns in The Tower.",
	},
	solid_wall_tower_6 = {
		name = "Underground Jungle Again...",
		description = "Discover the Underground Jungle in The Tower.",
	},
	solid_wall_tower_7 = {
		name = "The Vault Again...",
		description = "Discover The Vault in The Tower.",
	},
	solid_wall_tower_8 = {
		name = "Temple of the Art Again...",
		description = "Discover the Temple of the Art in The Tower.",
	},
	solid_wall_tower_9 = {
		name = "Hell... Again?",
		description = "Discover Hell in The Tower.",
	},
	song_room = {
		name = "Blue Chest",
		description = "Discover the location of the Coral Chest.",
	},
	teleroom = {
		name = "Now You're Thinking With Portals",
		description = "Discover the Portal Room.",
	},
	temple_altar = {
		name = "There's a Lot Going on Here",
		description = "Discover the center of a Holy Mountain.",
	},
	temple_altar_left = {
		name = "Ahhh Sanctuary... Or Is It?",
		description = "Discover the Holy Mountain.",
	},
	temple_altar_right = {
		name = "Grab n' Go",
		description = "Discover the right side of a Holy Mountain.",
	},
	temple_wall = {
		name = "That'll Anger Steve",
		description = "Discover the Holy Mountain's Walls.",
	},
	temple_wall_ending = {
		name = "That One Save Room Before the Boss",
		description = "Discover the final Holy Mountain.",
	},
	backrooms = {
		name = "Welcome to the Backrooms",
		description = "Discover the Backrooms.",
	},
	the_sky = {
		name = "Icarus",
		description = "Discover the Sky.",
	},
	vault = {
		name = "Industrial Complex",
		description = "Discover The Vault.",
	},
	vault_frozen = {
		name = "Heat Death",
		description = "Discover the Frozen Vault.",
	},
	wandcave = {
		name = "It's Maaagical!",
		description = "Discover the Magical Temple.",
	},
	water = {
		name = "Blub Blub",
		description = "Discover the Water.",
	},
	watercave = {
		name = "It's Dark and... Who Did This?",
		description = "Discover the dark cave.",
	},
	winter = {
		name = "Wasteland? More like Battlefield.",
		description = "Discover the Snowy Wasteland.",
	},
	winter_caves = {
		name = "It's Still Cold",
		description = "Discover the Snowy Chasm.",
	},
	wizardcave = {
		name = "There Be Wizards",
		description = "Discover the Wizards' Den.",
	},
	wizardcave_entrance = {
		name = "The Illuminati",
		description = "Discover the Gate Guardian.",
	},
	fairmod_cauldron = {
		name = "Don't Forget to Flush",
		description = "Someone solved the cauldron!",
	},
	fairmod_hamis_biome = {
		name = "Hämis Our Beloved",
		description = "Hämis is cool.",
	},
	fairmod_milk_biome = {
		name = "Got Milk?",
		description = "Lactose intolerants' worst nightmare.",
	},
}

for id, info in pairs(biome_achievements) do
	table.insert(achievements, {
		name = info.name,
		description = info.description,
		icon = "mods/noita.fairmod/files/content/achievements/icons/biome_" .. id .. ".png",
		flag = "biome_" .. id,
		unlock = function()
			return GetCurrentBiomeId() == id
		end,
	})
end

for _, fish in ipairs(fish_list) do
	table.insert(achievements, {
		name = "Catch " .. fish.name,
		description = "Fish up a " .. fish.name .. ".",
		icon = "mods/noita.fairmod/files/content/achievements/icons/fish_" .. fish.id .. ".png",
		flag = "achivement_fishing_" .. fish.id,
		unlock = function()
			return GameHasFlagRun("caught_fish_" .. fish.id)
		end,
	})
end

-- setting flag
for _, achievement in ipairs(achievements) do
	achievement.flag = string.lower("fairmod_" .. achievement.flag or ("achievement_" .. achievement.name))
end
