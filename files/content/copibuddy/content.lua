-- Supported formatting for text is as follows:
-- [color=ffffff]text[/color] - Sets the text color to white
-- [size=1.2]text[/size] - Sets the text size to 1.2
-- [on_click=function]text[/on_click] - Sets the text to be clickable and calls the function when clicked, functions can be defined in entries
-- [on_hover=function]text[/on_hover] - Sets the text to be hoverable and calls the function when hovered, functions can be defined in entries
-- [on_right_click=function]text[/on_right_click] - Sets the text to be right-clickable and calls the function when right-clicked, functions can be defined in entries

return {
	{
		text = function(copibuddy) -- can be either a function or a string
			return "Well hello there! \nI don't think we've been properly introduced. \n\nI'm copi."
		end,
		--audio = {"mods/noita.fairmod/fairmod.bank", "copibuddy/voice_intro"},  -- can be either a function or a table, or nil
		anim = "talk", -- can be either a function or a string, or nil
		post_talk_anim = "idle", -- this is the animation that will play after the text is done, can be either a function or a string, or nil
		frames = nil, -- this is the number of frames the event will last. If nil, it will last the default time.
		weight = 1000000,
		condition = function(copibuddy)
			local first_time = GameHasFlagRun("copibuddy") and not GameHasFlagRun("copibuddy_intro_done") and not HasFlagPersistent("copibuddy_met_before")
			return first_time
		end,
		func = function(copibuddy) -- this function is called when the event is triggered
			GameAddFlagRun("copibuddy_intro_done")
			AddFlagPersistent("copibuddy_met_before")
		end,
		post_func = function(copibuddy) -- this runs after the event ends

		end,
		update = function(copibuddy) -- this function is called every frame while event is active
			
		end,
	},
	{
		text = "Hello there! Good to see you again.\nLet's have lots of fun together.",
		--audio = {"mods/noita.fairmod/fairmod.bank", "copibuddy/voice_intro_met_before"},
		anim = "talk",
		weight = 1000000,
		condition = function(copibuddy)
			local first_time = GameHasFlagRun("copibuddy") and not GameHasFlagRun("copibuddy_intro_done") and HasFlagPersistent("copibuddy_met_before")
			return first_time
		end,
		func = function(copibuddy) 
			GameAddFlagRun("copibuddy_intro_done")
			AddFlagPersistent("copibuddy_met_before")
		end
	},
	{
		text = "Click this [on_click=surprise][color=0000ff]cool button[/color][/on_click] to get a free surprise!",
		anim = "talk",
		weight = 1,
		frames = 400,
		condition = function(copibuddy)
			return true
		end,
		functions = {
			surprise = function(copibuddy)
				GamePrint("Surprise!")
			end,
		},
	},
	{
		text = nil,
		anim = "fade_out",
		frames = 280,
		weight = 1,
		condition = function(copibuddy)
			return true
		end,
		update = function(copibuddy) -- this function is called every frame while event is active
			print("copibuddy timer: " .. tostring(copibuddy.timer))
		
			if(copibuddy.timer == 180)then
				copibuddy.animation = "missing"
			end

			if(copibuddy.timer == 80)then
				local screen_w, screen_h = GuiGetScreenDimensions(copibuddy.gui)
				copibuddy.x = Random(0, screen_w - copibuddy.width)
				copibuddy.y = Random(0, screen_h - copibuddy.height)
				copibuddy.animation = "fade_in"
			end

		end,
	},
	{
		text = nil,
		anim = "spin",
		frames = 135,
		weight = 1,
		condition = function(copibuddy)
			return true
		end,
	},
}