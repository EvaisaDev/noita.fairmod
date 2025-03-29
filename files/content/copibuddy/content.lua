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
		audio = {"mods/noita.fairmod/fairmod.bank", "copibuddy/introduction"},  -- can be either a function or a table, or nil
		anim = "talk", -- can be either a function or a string, or nil
		post_talk_anim = "idle", -- this is the animation that will play after the text is done, can be either a function or a string, or nil
		frames = nil, -- this is the number of frames the event will last. If nil, it will last the default time.
		weight = 1,
		force = true, -- forces event if possible
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
		audio = {"mods/noita.fairmod/fairmod.bank", "copibuddy/reintroduction"},
		anim = "talk",
		weight = 1,
		force = true, -- forces event if possible
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
		audio = {"mods/noita.fairmod/fairmod.bank", "copibuddy/button_surprise"},
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
	{
		text = "copi BLAST!",
		anim = "copi_blast",
		audio = {"mods/noita.fairmod/fairmod.bank", "copibuddy/copi_blast"},
		frames = 135,
		type_delay = 1,
		weight = function(copibuddy)
			-- if you wanna make it guaranteed if a healer is nearby for example you can manipulate the weight here.
			return 0.8
		end,
		condition = function(copibuddy)
			local x, y = GameGetCameraPos()
			local enemies = EntityGetInRadiusWithTag(x, y, 512, "enemy")

			return #enemies > 0
		end,
		func = function(copibuddy) -- this function is called when the event is triggered
			copibuddy.current_target = nil
		end,
		update = function(copibuddy) -- this function is called every frame while event is active

			local this = copibuddy.event
		
			local function ScreenToWorldPos(sx, sy)
				local virt_x = MagicNumbersGetValue("VIRTUAL_RESOLUTION_X")
				local virt_y = MagicNumbersGetValue("VIRTUAL_RESOLUTION_Y")
				local screen_width, screen_height = GuiGetScreenDimensions(copibuddy.gui)
				local scale_x = virt_x / screen_width
				local scale_y = virt_y / screen_height
				local cx, cy = GameGetCameraPos()
				
				-- Reverse the math: subtract the offset and then apply scaling.
				local x = cx + (sx - screen_width / 2 - 1.5) * scale_x
				local y = cy + (sy - screen_height / 2) * scale_y
				
				return x, y
			end

			if(copibuddy.timer == 100)then
				copibuddy.animation = "copi_blast_active"
			end

			local world_x, world_y = ScreenToWorldPos(copibuddy.x + (copibuddy.width / 2), copibuddy.y + (copibuddy.height / 2) + 2)

			if(copibuddy.timer <= 100 and copibuddy.timer > 1 and GameGetFrameNum() % 1 == 0)then
				if(not this.current_target)then
					local x, y = GameGetCameraPos()
					local enemies = EntityGetInRadiusWithTag(x, y, 512, "enemy")
					if(#enemies > 0)then
						this.current_target = EntityGetClosestWithTag(world_x, world_y, "enemy")
					end
				elseif(not EntityGetIsAlive(this.current_target))then
					this.current_target = nil
					copibuddy.timer = 1
				else

					local players = EntityGetWithTag("player_unit")

					local target_x, target_y = EntityGetTransform(this.current_target)

					local distance = math.sqrt((target_x - world_x)^2 + (target_y - world_y)^2)

					-- normalize the direction vector
					local direction_x = (target_x - world_x) / distance
					local direction_y = (target_y - world_y) / distance
					

					local speed = 1000 -- Adjust the speed of the projectile as needed

					local projectile = EntityLoad("mods/noita.fairmod/files/content/copibuddy/sprites/copi_blast_projectile.xml", world_x, world_y)
				
					local velocity_comp = EntityGetFirstComponentIncludingDisabled(projectile, "VelocityComponent")
					if velocity_comp then
						ComponentSetValue2(velocity_comp, "mVelocity", direction_x * speed, direction_y * speed)
					end

					local projectile_comp = EntityGetFirstComponentIncludingDisabled(projectile, "ProjectileComponent")
					if projectile_comp and players and players[1] then
						ComponentSetValue2(projectile_comp, "mWhoShot", players[1])
					end
				
				end
			end
		end,
	},
	{ -- random taunts
		weight = 1,
		text = function(copibuddy)
			-- little bit of seed rigging to sync the audio and text entries
			SetRandomSeed(GameGetFrameNum() + copibuddy.x, GameGetFrameNum() + copibuddy.y)
			local taunts = {
				"Wow you stink.",
				"You know how to play this game right?\nJust go down.",
			}
			return taunts[Random(1, #taunts)]
		end,
		audio = function(copibuddy)
			SetRandomSeed(GameGetFrameNum() + copibuddy.x, GameGetFrameNum() + copibuddy.y)
			local taunts = {
				"copibuddy/taunt_1",
				"copibuddy/taunt_2", -- havent added audio yet
			}
			return {"mods/noita.fairmod/fairmod.bank", taunts[Random(1, #taunts)]}
		end,
	},
	{
		text = function(copibuddy)
			-- little bit of seed rigging to sync the audio and text entries
			SetRandomSeed(GameGetFrameNum() + copibuddy.x, GameGetFrameNum() + copibuddy.y)
			local taunts = {
				"Stop taking damage, idiot.",
				"skill issue.",
				"issue of skill.",
				"Maybe if you installed copith you would stop taking damage.",
			}
			return taunts[Random(1, #taunts)]
		end,
		audio = function(copibuddy)
			SetRandomSeed(GameGetFrameNum() + copibuddy.x, GameGetFrameNum() + copibuddy.y)
			local taunts = {
				"copibuddy/damage_response_1",
				"copibuddy/damage_response_2",
				"copibuddy/damage_response_3",
				"copibuddy/damage_response_4",
			}
			return {"mods/noita.fairmod/fairmod.bank", taunts[Random(1, #taunts)]}
		end,		
		
		anim = "talk", -- can be either a function or a string, or nil
		post_talk_anim = "idle", -- this is the animation that will play after the text is done, can be either a function or a string, or nil
		frames = nil, -- this is the number of frames the event will last. If nil, it will last the default time.
		weight = 1,
		force = true, -- forces event if possible
		condition = function(copibuddy)
			local took_damage = GameHasFlagRun("copibuddy.just_took_damage") and Random(1, 100) <= 20
			GameRemoveFlagRun("copibuddy.just_took_damage")
			GameAddFlagRun("copibuddy.pause_damage_check")
			return took_damage
		end,
		post_func = function(copibuddy) -- this runs after the event ends
			GameRemoveFlagRun("copibuddy.pause_damage_check")
		end,
	},
}