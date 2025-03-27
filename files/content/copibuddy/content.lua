return {
	{
		text = function() -- can be either a function or a string
			return "Well hello there! I don't think we've been properly introduced. \n\nI'm copibuddy."
		end,
		audio = "copibuddybuddy/voice_intro",  -- can be either a function or a string
		
		condition = function()
			local first_time = GameHasFlagRun("copibuddybuddy") and not GameHasFlagRun("copibuddybuddy_intro_done") and not HasFlagPersistent("copibuddybuddy_met_before")
			return first_time
		end,
		func = function()
			GameAddFlagRun("copibuddybuddy_intro_done")
			AddFlagPersistent("copibuddybuddy_met_before")
		end
	},
	{
		text = function() -- can be either a function or a string
			return "Hello there! Good to see you again. Let's have lots of fun together."
		end,
		audio = "copibuddybuddy/voice_intro_met_before",
		condition = function()
			local first_time = GameHasFlagRun("copibuddybuddy") and not GameHasFlagRun("copibuddybuddy_intro_done") and HasFlagPersistent("copibuddybuddy_met_before")
			return first_time
		end,
		func = function() 
			GameAddFlagRun("copibuddybuddy_intro_done")
			AddFlagPersistent("copibuddybuddy_met_before")
		end
	},
}