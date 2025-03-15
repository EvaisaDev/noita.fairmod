return {
	{
		text = function()
			return HasFlagPersistent("copibuddy_met_before") and "Hello there! Good to see you again. Let's have lots of fun together." or "Well hello there! I don't think we've been properly introduced. \n\nI'm Copi."
		end,
		condition = function()
			local first_time = GameHasFlagRun("copibuddy") and not GameHasFlagRun("copibuddy_intro_done")
			return first_time
		end,
		func = function()
			GameAddFlagRun("copibuddy_intro_done")
			AddFlagPersistent("copibuddy_met_before")
		end
	}
}