achievements = {
	{
		name = "Shitted",
		description = "You shitted and farted!!!",
		icon = "mods/noita.fairmod/files/content/achievements/icons/shitted.png",
		flag = "achievement_shitted",
		background = "mods/noita.fairmod/files/content/achievements/backgrounds/background_small.png",
		unlock = function()
			return GlobalsGetValue("TIMES_TOOK_SHIT", "0") ~= "0"
		end,
	}
}