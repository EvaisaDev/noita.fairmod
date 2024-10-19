dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")
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
		icon = nil,
		flag = "achievement_pissed",
		unlock = function()
			return GlobalsGetValue("TIMES_TOOK_PISS", "0") ~= "0"
		end,
	},
	{
		name = "Poop Ending",
		description = "And thus, the world was turned to shit.",
		icon = nil,
		flag = "achievement_poop_ending",
		unlock = function()
			return GameHasFlagRun("poop_ending")
		end,
	},
	{
		name = "Bankruptcy",
		description = "Collect a debt of 10k gold or more.",
		icon = nil,
		flag = "achievement_debt_collector",
		unlock = function()
			return tonumber(GlobalsGetValue("loan_shark_debt", "0")) >= 10000
		end,
	},
	{
		name = "Speedrunner",
		description = "Enter the speedrun door.",
		icon = nil,
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
		end
	},
	{
		name = "Too many acid",
		description = "Did it bothered you?",
		icon = "mods/noita.fairmod/files/content/achievements/icons/giant_shooter.png",
		flag = "achievement_giantshooter_killed",
		unlock = function()
			return GameHasFlagRun("FAIRMOD_GIANTSHOOTER_KILLED")
		end
	},
	{
		name = "The Things In Question",
		description = "Peak content unlocked! :check:",
		icon = "mods/noita.fairmod/files/content/achievements/icons/copith.png",
		flag = "achievement_copis_things",
		unlock = function()
			return ModIsEnabled("copis_things")
		end
	},
	{
		name = "Sucks to Suck",
		description = "Got giga critted!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/giga_critted.png",
		flag = "achievement_giga_critted",
		unlock = function()
			return GameHasFlagRun("giga_critted_lol")
		end
	},
	{
		name = "Take to the Skies",
		description = "help how do i get down what im gonna hit the roof ow fuck",
		icon = "mods/noita.fairmod/files/content/achievements/icons/oiled_up.png",
		flag = "achievement_oiled_up",
		unlock = function()
			return GameHasFlagRun("oiled_up")
		end
	},
	{
		name = "Ow Fuck",
		description = "You had a heart attack!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/heart_attacked.png",
		flag = "achievement_heart_attacked",
		unlock = function()
			return GameHasFlagRun("heart_attacked")
		end
	},
	{
		name = "Add mana: Balanced",
		description = "Game quality +500%",
		icon = "mods/noita.fairmod/files/content/achievements/icons/hahah_fuck_your_mana.png",
		flag = "achievement_hahah_fuck_your_mana",
		unlock = function()
			return GameHasFlagRun("hahah_fuck_your_mana")
		end
	},
	{
		name = "Avoided Heart Attack!",
		description = "Epic heart health win!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/fake_heart_attack.png",
		flag = "achievement_fake_heart_attack",
		unlock = function()
			return #(GetPlayers())>=1 and Random(1, 108000) == 1
		end
	},
	{
		name = "Degraded Game Experience",
		description = "Why!?!> Disable nightmare.",
		icon = "mods/noita.fairmod/files/content/achievements/icons/nighmare_mode.png",
		flag = "achievement_nighmare_mode",
		unlock = function()
			return ModIsEnabled("nightmare")
		end
	},
	{
		name = "Just.. one.. more...",
		description = "99% gamblers quit before big win! Next roll = $5m payout",
		icon = "mods/noita.fairmod/files/content/achievements/icons/gamble_fail.png",
		flag = "achievement_gamble_fail",
		unlock = function()
			return tonumber(GlobalsGetValue("GAMBLECORE_TIMES_LOST_IN_A_ROW", "0")) > 5
		end
	},
	{
		name = "Gamble God",
		description = "Winnar is you!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/gamble_win.png",
		flag = "achievement_gamble_win",
		unlock = function()
			return tonumber(GlobalsGetValue("GAMBLECORE_TIMES_WON", "0")) >= 1
		end
	},
	{
		name = "Gambling is Fun!",
		description = "Next might be TWWE! Reroll more!!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/reroll_destiny.png",
		flag = "achievement_reroll_destiny",
		unlock = function()
			return tonumber(GlobalsGetValue("TEMPLE_PERK_REROLL_COUNT", "0")) >= 1
		end
	},
	{
		name = "Gambling is Fun! II",
		description = "Who knows what might be next?",
		icon = "mods/noita.fairmod/files/content/achievements/icons/reroll_destiny2.png",
		flag = "achievement_reroll_destiny2",
		unlock = function()
			return tonumber(GlobalsGetValue("TEMPLE_PERK_REROLL_COUNT", "0")) >= 3
		end
	},
	{
		name = "Gambling is Fun! III",
		description = "Next achievement at 100 rerolls!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/reroll_destiny3.png",
		flag = "achievement_reroll_destiny3",
		unlock = function()
			return tonumber(GlobalsGetValue("TEMPLE_PERK_REROLL_COUNT", "0")) >= 5
		end
	},
	{
		name = "Player",
		description = "You played the game!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/player.png",
		flag = "achievement_player",
		unlock = function()
			return GameGetFrameNum() > 25
		end
	},
	{
		name = "Perked Up!",
		description = "Perk get!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/perked_up.png",
		flag = "achievement_perked_up",
		unlock = function()
			return GameHasFlagRun("picked_perk_acheev")
		end
	},
	{
		name = "What have you done!!",
		description = "You've doomed us all!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/holy_shit_danger.png",
		flag = "achievement_holy_shit_danger",
		unlock = function()
			return GameHasFlagRun("holy_shit_danger")
		end
	},
	{
		name = "Portal Malfunction",
		description = "Be sent to the wrong location by a portal.",
		icon = "mods/noita.fairmod/files/content/achievements/icons/portal_malfunction.png",
		flag = "achievement_portal_malfunction",
		unlock = function()
			return GameHasFlagRun("portal_malfunction")
		end
	},
	{
		name = "Fishing Novice",
		description = "You caught your first fish!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/fishing_1.png",
		flag = "achievement_fishing_novice",
		unlock = function()
			return GlobalsGetValue("fish_caught", "0") ~= "0"
		end
	},
	{
		name = "Baby Steps",
		description = "You died :(",
		icon = "mods/noita.fairmod/files/content/achievements/icons/dead.png",
		flag = "achievement_dead",
		unlock = function()
			return StatsGetValue("dead") ~= "0"
		end
	},
	{
		name = "Jeffrey Preston Bezos ",
		description = "Approx Net Worth: $2.147B",
		icon = "mods/noita.fairmod/files/content/achievements/icons/infinite_gold.png",
		flag = "achievement_infinite_gold",
		unlock = function()
			return StatsGetValue("gold_infinite") ~= "0"
		end
	}
}


local function romanize(num)
    local result = ""
    for _, value in ipairs({{1000, "M"}, {900, "CM"}, {500, "D"}, {400, "CD"}, {100, "C"}, {90, "XC"}, {50, "L"}, {40, "XL"}, {10, "X"}, {9, "IX"}, {5, "V"}, {4, "IV"}, {1, "I"} }) do
        local count = math.floor(num / value[1])
        num = num % value[1]
        result = result .. string.rep(value[2], count)
    end
    return result
end

local ach_len = #achievements
for i=1, 10 do
	achievements[ach_len+i] = {
		name = "Godslayer " .. romanize(i),
		description = (function (chars)
			local sets = {{97, 122}, {65, 90}, {48, 57}} -- a-z, A-Z, 0-9
			local str = {""}
			for p = 1, chars do
				local charset = sets[ math.random(1, #sets) ]
				str[#str+1] = string.char(math.random(charset[1], charset[2]))
			end
			return table.concat(str)
		end)(i*2),
		icon = table.concat{"mods/noita.fairmod/files/content/achievements/icons/god_slayer_", i, ".png"},
		flag = "god_slayer_" .. i,
		unlock = function()
			return tonumber(GlobalsGetValue("STEVARI_DEATHS", "0")) >= i
		end
	}
end

ach_len = #achievements
for i=1, 10 do
	achievements[ach_len+i] = {
		name = "Fire In The Hole " .. romanize(i),
		description = "You shot " .. tostring(2^i) .. " times!",
		icon = table.concat{"mods/noita.fairmod/files/content/achievements/icons/shot_count_", i, ".png"},
		flag = "shot_count_" .. i,
		unlock = function()
			return tonumber(StatsGetValue("projectiles_shot")) >= 2^i
		end
	}
end

ach_len = #achievements
for i=1, 10 do
	achievements[ach_len+i] = {
		name = "New Kicks " .. romanize(i),
		description = "You kicked " .. tostring(2^i) .. " times!",
		icon = table.concat{"mods/noita.fairmod/files/content/achievements/icons/kick_count_", i, ".png"},
		flag = "kick_count_" .. i,
		unlock = function()
			return tonumber(StatsGetValue("kicks")) >= 2^i
		end
	}
end

ach_len = #achievements
for i=1, 10 do
	achievements[ach_len+i] = {
		name = "Trailblazer " .. romanize(i),
		description = "Current streak:  " .. tostring(2^i),
		icon = table.concat{"mods/noita.fairmod/files/content/achievements/icons/streak_", i, ".png"},
		flag = "streak_" .. i,
		unlock = function()
			return tonumber(StatsGetValue("streaks")) >= 2^i
		end
	}
end

ach_len = #achievements
for i=1, 10 do
	achievements[ach_len+i] = {
		name = "Survivor " .. romanize(i),
		description = "Session Time:  " .. tostring(2^i),
		icon = table.concat{"mods/noita.fairmod/files/content/achievements/icons/session_time_", i, ".png"},
		flag = "playtime_" .. i,
		unlock = function()
			return (tonumber(StatsGetValue("playtime")) >= 2^i) and #(GetPlayers())>1
		end
	}
end

ach_len = #achievements
for i=1, 10 do
	achievements[ach_len+i] = {
		name = "Healthy " .. romanize(i),
		description = "That's at least " .. tostring(2^i + 100) .. "max HP!",
		icon = table.concat{"mods/noita.fairmod/files/content/achievements/icons/max_hp_", i, ".png"},
		flag = "hp_" .. i,
		unlock = function()
			return tonumber(StatsGetValue("hp")) >= 2^i + 100
		end
	}
end

ach_len = #achievements
for i=1, 10 do
	achievements[ach_len+i] = {
		name = "Rags to Riches " .. romanize(i),
		description = "dollar sign" .. tostring(2^i) .. ", Nice!",
		icon = table.concat{"mods/noita.fairmod/files/content/achievements/icons/gold_", i, ".png"},
		flag = "gold_" .. i,
		unlock = function()
			return tonumber(StatsGetValue("gold")) >= 2^i
		end
	}
end

ach_len = #achievements
for i=1, 10 do
	achievements[ach_len+i] = {
		name = "Brittle Bones Noita " .. romanize(i),
		description = "You've soaked up " .. tostring(2^i * 25) .. " damage!",
		icon = table.concat{"mods/noita.fairmod/files/content/achievements/icons/damage_taken_", i, ".png"},
		flag = "damage_taken_" .. i,
		unlock = function()
			return tonumber(StatsGetValue("damage_taken") * 25) >= 2^i
		end
	}
end