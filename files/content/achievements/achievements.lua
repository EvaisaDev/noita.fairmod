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
		description = "What did they do",
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
	}
}
