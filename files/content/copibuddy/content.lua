-- Supported formatting for text is as follows:
-- [color=ffffff]text[/color] - Sets the text color to white
-- [size=1.2]text[/size] - Sets the text size to 1.2
-- [on_click=function]text[/on_click] - Sets the text to be clickable and calls the function when clicked, functions can be defined in entries
-- [on_hover=function]text[/on_hover] - Sets the text to be hoverable and calls the function when hovered, functions can be defined in entries
-- [on_right_click=function]text[/on_right_click] - Sets the text to be right-clickable and calls the function when right-clicked, functions can be defined in entries
dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")
local get_spells = function()
	local items = {}
	local player = EntityGetWithTag("player_unit") or {}
	if(player[1])then
		local player = player[1]
		local inventory_full
		for _, child in ipairs(EntityGetAllChildren(player) or {}) do
			if (EntityGetName(child) == "inventory_full") then
				inventory_full = child
				break
			end
		end

		local inventory_items = EntityGetAllChildren(inventory_full) or {}
		for _, item in ipairs(inventory_items) do
			if EntityHasTag(item, "card_action") then
				table.insert(items, item)
			end
		end
	end
	return items
end

local get_wands = function()
	local players = EntityGetWithTag("player_unit") or {}
	local wands = {}
	if(players[1])then
		local player = players[1]
		local inven = nil

		for _, child in ipairs(EntityGetAllChildren(player) or {}) do
			if EntityGetName(child) == "inventory_quick" then
				inven = child
			end
		end

		if inven ~= nil then
			local items = EntityGetAllChildren(inven)
			for _, child_item in ipairs(items) do
				local item_component = EntityGetFirstComponentIncludingDisabled(child_item, "ItemComponent")

				local slot = ComponentGetValue2(item_component, "inventory_slot")

				if(slot < 5)then
					table.insert(wands, child_item)
				end
			end
		end
	end
    return wands
end

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
		text = "I'm copi, inventor of all things!",
		audio = {"mods/noita.fairmod/fairmod.bank", "copibuddy/inventor_of_things"},
		anim = "talk",
		weight = 0.3,
	},
	{
		text = "Click this [on_click=surprise][color=0000ff]cool button[/color][/on_click] to get a free surprise!",
		audio = {"mods/noita.fairmod/fairmod.bank", "copibuddy/button_surprise"},
		anim = "talk",
		weight = 2.7,
		frames = 400,
		condition = function(copibuddy)
			return true
		end,
		func = function (copibuddy) -- this function is called when the event is triggered
			copibuddy.event.taken_surprise = false	
		end,
		functions = {
			surprise = function(copibuddy)
				if(copibuddy.event.taken_surprise)then 
					local players = EntityGetWithTag("player_unit")
					if(players[1])then
						EntityInflictDamage(players[1], 0.1, "DAMAGE_PHYSICS_BODY_DAMAGED", "Stop being greedy.", "DISINTEGRATED", 0, 0, EntityGetWithTag("player_unit")[1])
					end

					GamePrint("Stop being greedy!")
					
					return
				end

				dofile("data/scripts/streaming_integration/alt_event_utils.lua")
				dofile("data/scripts/streaming_integration/event_list.lua")

				local twitch_event = streaming_events[Random(1, #streaming_events)]

				_streaming_run_event(twitch_event.id)

				copibuddy.event.taken_surprise = true
				
			end,
		},
	},	
	{
		text = nil,
		anim = "fade_out",
		frames = 280,
		weight = 1.3,
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
			-- eba make it scale with enemy density :3 @evaisa hi hi hi 
			return 0.7+(#EntityGetInRadiusWithTag(x, y, 192, "enemy"))*0.05
		end,
		condition = function(copibuddy)
			local x, y = GameGetCameraPos()
			local enemies = EntityGetInRadiusWithTag(x, y, 192, "enemy")
			local count = 0
			for i=1, #enemies do
				if EntityGetName(enemies[i])~="$animal_longleg" then
					count = count + 1
				end
			end
			return count > 0
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
			local world_x, world_y = ScreenToWorldPos(copibuddy.x + (copibuddy.width / 2), copibuddy.y + (copibuddy.height / 2) + 2)
			if(copibuddy.timer == 100)then
				copibuddy.animation = "copi_blast_active"
				
				local enemies = EntityGetInRadiusWithTag( world_x, world_y, 346, "enemy" )
				for i=1, #enemies do
					if EntityGetName(enemies[i])~="$animal_longleg" then
						EntityInflictDamage(enemies[i], math.huge, "DAMAGE_PHYSICS_BODY_DAMAGED", "COPI BLAST", "DISINTEGRATED", 0, 0, EntityGetWithTag("player_unit")[1])
						EntityConvertToMaterial(enemies[i], "fairmod_ash")
						local ex, ey = EntityGetTransform(enemies[i])
						GameCreateParticle("fairmod_ash", ex, ey, 4, 0, 0, false, true)
						GameCreateParticle("smoke", ex, ey, 8, 0, 0, false, true)
					end
				end
				GamePlaySound( "data/audio/Desktop/misc.bank", "misc/beam_from_sky_hit", GameGetCameraPos() )
			end

			if copibuddy.timer <100 then
				local w, h = GuiGetImageDimensions(copibuddy.gui, "mods/noita.fairmod/files/content/copibuddy/copiblast.png", 1)
				local screen_width, screen_height = GuiGetScreenDimensions(copibuddy.gui)
				
				GuiImage(copibuddy.gui, copibuddy.new_id(), 0, 0, "mods/noita.fairmod/files/content/copibuddy/copiblast.png", 1-((135-copibuddy.timer)/100)^3, screen_width/w, screen_height/h)
			end


			--[[
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


				end
			end]]
		end,
	},
	{ -- random taunts
		weight = 1.1,
		text = function(copibuddy)
			-- little bit of seed rigging to sync the audio and text entries
			SetRandomSeed(GameGetFrameNum() + copibuddy.x, GameGetFrameNum() + copibuddy.y)
			local taunts = {
				"Wow you stink.",
				"You know how to play this game right?\nJust go down.",
				"Holy shit you suck.",
				"Do you need me to beat this game for you?",
				"I've simulated 500 future runs and you win in 0 of them.",
			}
			return taunts[Random(1, #taunts)]
		end,
		audio = function(copibuddy)
			SetRandomSeed(GameGetFrameNum() + copibuddy.x, GameGetFrameNum() + copibuddy.y)
			local taunts = {
				"copibuddy/taunt_1",
				"copibuddy/taunt_2",
				"copibuddy/taunt_3",
				"copibuddy/taunt_4",
				"copibuddy/taunt_5",
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
				"Damn you're bald AND bad.",
				"Your failure amuses me."
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
				"copibuddy/damage_response_5",
				"copibuddy/damage_response_6",
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
	{
		text = "Those enemies seem to be in your way, let me turn them into something more friendly.",
		anim = "talk",
		audio = {"mods/noita.fairmod/fairmod.bank", "copibuddy/hamis_time"},
		frames = 300,
		weight = function(copibuddy)
			return 1+(#EntityGetInRadiusWithTag(x, y, 192, "enemy"))*0.05
		end,
		condition = function(copibuddy)
			local x, y = GameGetCameraPos()
			local enemies = EntityGetInRadiusWithTag(x, y, 192, "enemy")

			local count = 0
			for i=1, #enemies do
				if EntityGetName(enemies[i])~="$animal_longleg" then
					count = count + 1
				end
			end
			return count > 0
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
			local world_x, world_y = ScreenToWorldPos(copibuddy.x + (copibuddy.width / 2), copibuddy.y + (copibuddy.height / 2) + 2)
			if(copibuddy.timer == 30)then
				copibuddy.animation = "copi_snap"
			
			end

			if(copibuddy.timer == 20)then
				local enemies = EntityGetInRadiusWithTag( world_x, world_y, 346, "enemy" )
				for i=1, #enemies do
					if EntityGetName(enemies[i])~="$animal_longleg" then
						EntityInflictDamage(enemies[i], math.huge, "DAMAGE_PHYSICS_BODY_DAMAGED", "COPI CONVERSION", "DISINTEGRATED", 0, 0, EntityGetWithTag("player_unit")[1])
						EntityConvertToMaterial(enemies[i], "fairmod_ash")
						local ex, ey = EntityGetTransform(enemies[i])
						GameCreateParticle("smoke", ex, ey, 8, 0, 0, false, true)

						for i = 1, Random(1, 3) do
							EntityLoad("data/entities/animals/longleg.xml", ex, ey)
						end
					end
				end
				GamePlaySound( "mods/noita.fairmod/fairmod.bank", "copibuddy/snap", 0, 0 )
			end

		end,
	},
	{
		text = "There was a lot of gold here, for performance reasons I removed it.",
		anim = "talk",
		audio = {"mods/noita.fairmod/fairmod.bank", "copibuddy/clear_gold"},
		frames = 300,
		weight = function(copibuddy)
			return 1+(#EntityGetInRadiusWithTag(x, y, 346, "gold_nugget"))*0.05
		end,
		condition = function(copibuddy)
			local x, y = GameGetCameraPos()
			local entities = EntityGetInRadiusWithTag(x, y,346, "gold_nugget")
			return #entities > 0
		end,
		update = function(copibuddy) -- this function is called every frame while event is active

			local this = copibuddy.event

			local world_x, world_y = GameGetCameraPos()
			if(copibuddy.timer == 30)then
				copibuddy.animation = "copi_snap"
			end

			if(copibuddy.timer == 20)then
				local entities = EntityGetInRadiusWithTag( world_x, world_y, 346, "gold_nugget" )
				for i=1, #entities do
					local entity = entities[i]
					local ex, ey = EntityGetTransform(entity)

					EntityConvertToMaterial(entity, "fairmod_ash")
					local ex, ey = EntityGetTransform(entity)
					GameCreateParticle("smoke", ex, ey, 8, 0, 0, false, true)

					EntityKill(entity)
				end
				GamePlaySound( "mods/noita.fairmod/fairmod.bank", "copibuddy/snap", 0, 0 )
			end

		end,
	},
	{
		text = "There was a lot of gold here, for performance reasons I removed it.",
		anim = "talk",
		audio = {"mods/noita.fairmod/fairmod.bank", "copibuddy/clear_gold"},
		frames = 300,
		weight = function(copibuddy)
			return 1+(#EntityGetInRadiusWithTag(x, y, 346, "gold_nugget"))*0.05
		end,
		condition = function(copibuddy)
			local x, y = GameGetCameraPos()
			local entities = EntityGetInRadiusWithTag(x, y,346, "gold_nugget")
			return #entities > 0
		end,
		update = function(copibuddy) -- this function is called every frame while event is active

			local this = copibuddy.event

			local world_x, world_y = GameGetCameraPos()
			if(copibuddy.timer == 30)then
				copibuddy.animation = "copi_snap"
			end

			if(copibuddy.timer == 20)then
				local entities = EntityGetInRadiusWithTag( world_x, world_y, 346, "gold_nugget" )
				for i=1, #entities do
					local entity = entities[i]
					local ex, ey = EntityGetTransform(entity)

					EntityConvertToMaterial(entity, "fairmod_ash")
					local ex, ey = EntityGetTransform(entity)
					GameCreateParticle("smoke", ex, ey, 8, 0, 0, false, true)

					EntityKill(entity)
				end
				GamePlaySound( "mods/noita.fairmod/fairmod.bank", "copibuddy/snap", 0, 0 )
			end

		end,
	},
	{
		text = "You seem to be carrying a heavy load, let me help you with that.",
		anim = "talk",
		audio = {"mods/noita.fairmod/fairmod.bank", "copibuddy/drop_inventory"},
		frames = 260,
		weight = function(copibuddy)
			local entities = get_spells()
			return 1 + math.max(0, (#entities - 5) * 0.05)
		end,
		condition = function(copibuddy)
			local entities = get_spells()
			return #entities > 5
		end,
		update = function(copibuddy) -- this function is called every frame while event is active

			if(copibuddy.timer == 30)then
				copibuddy.animation = "copi_snap"
			end

			if(copibuddy.timer == 20)then
				local entities = get_spells()
				for i=1, #entities do
					local player = EntityGetRootEntity(entities[i])
					EntityDropItem(player, entities[i])
					local player_x, player_y = EntityGetTransform(player)

					EntitySetTransform(entities[i], player_x, player_y - 7)

					local velocity_comp = EntityGetFirstComponentIncludingDisabled(entities[i], "VelocityComponent")
					if(velocity_comp)then
						local vel_x = math.random(-300, 300)
						local vel_y = -300
						ComponentSetValue2(velocity_comp, "mVelocity", vel_x, vel_y)
					end
				end


				GamePlaySound( "mods/noita.fairmod/fairmod.bank", "copibuddy/snap", 0, 0 )
			end

		end,
	},
	{
		text = "Your loadout looks inefficient, I will reorganize it.",
		anim = "talk",
		audio = {"mods/noita.fairmod/fairmod.bank", "copibuddy/reorganize"},
		frames = 260,
		weight = 0.4,
		condition = function(copibuddy)
			local entities = get_wands()
			return #entities > 0
		end,
		update = function(copibuddy) -- this function is called every frame while event is active

			if(copibuddy.timer == 30)then
				copibuddy.animation = "copi_snap"
			end

			SetRandomSeed(GameGetFrameNum() + copibuddy.x, GameGetFrameNum() + copibuddy.y)
			
			local available_slots = {0, 1, 2, 3}
			
			if(copibuddy.timer == 20)then
	
				local players = EntityGetWithTag("player_unit")
				if(players[1])then
					copibuddy.event.dropped_items = GameGetAllInventoryItems(players[1]) or {}
					for i=1, #copibuddy.event.dropped_items do
						local item = copibuddy.event.dropped_items[i]
						GameDropAllItems(players[1])
						EntityDropItem(players[1], item)
						local item_component = EntityGetFirstComponentIncludingDisabled(item, "ItemComponent")

						if(item_component)then
							local slot_index = Random(1, #available_slots)
							local slot = available_slots[slot_index]
							table.remove(available_slots, slot_index)

							ComponentSetValue2(item_component, "inventory_slot", slot, 0)

							print("Reorganizing item " .. tostring(item) .. " to slot " .. tostring(slot))
						end
					end
				end

				GamePlaySound( "mods/noita.fairmod/fairmod.bank", "copibuddy/snap", 0, 0 )
			elseif(copibuddy.timer == 19)then

				local players = EntityGetWithTag("player_unit")
				if(players[1])then
					local entities = copibuddy.event.dropped_items or {}
					-- shuffle entities table
					for i = #entities, 2, -1 do
						local j = Random(1, i)
						entities[i], entities[j] = entities[j], entities[i]
					end

					for i = 1, #entities do
						GamePickUpInventoryItem(players[1], entities[i], false)
					end

				
					local player = players[1]
					local inventory2 = EntityGetFirstComponentIncludingDisabled(player, "Inventory2Component")
					if inventory2 then
						ComponentSetValue2(inventory2, "mForceRefresh", true)
						ComponentSetValue2(inventory2, "mActualActiveItem", 0)
					end
				end

			end

		end,
	},
	{ -- 20% chance for copi to save you if your health falls below 20%
		anim = "copi_snap",
		frames = 300,
		force = true,
		condition = function(copibuddy)
			local almost_died = GameHasFlagRun("copibuddy.almost_died_clearly")
			GameRemoveFlagRun("copibuddy.almost_died_clearly")
			
			local players = EntityGetWithTag("player_unit")


			return almost_died and Random(1, 100) <= 20 and players[1] and EntityGetIsAlive(players[1])
		end,
		update = function(copibuddy) -- this function is called when the event is triggered
			if(copibuddy.timer == 289)then
				local players = EntityGetWithTag("player_unit")

				if(players[1])then
					local player = players[1]
					local player_x, player_y = EntityGetTransform(player)
					local start_x = tonumber(MagicNumbersGetValue("DESIGN_PLAYER_START_POS_X"))
					local start_y = tonumber(MagicNumbersGetValue("DESIGN_PLAYER_START_POS_Y"))
					local target_x = GetParallelWorldPosition(player_x, player_y)*BiomeMapGetSize()*512;
					EntityApplyTransform(player,start_x+target_x,start_y)
				end
				GamePlaySound( "mods/noita.fairmod/fairmod.bank", "copibuddy/snap", 0, 0 )
			end

			if(copibuddy.timer == 272)then
				copibuddy.animation = "talk"
				copibuddy.target_text = "You seemed to be in danger, so I got you out of there.\n You're welcome."
				GamePlaySound( "mods/noita.fairmod/fairmod.bank", "copibuddy/saved", 0, 0 )
			end

		end,
	},
	{
		text = "You deserve a makeover!",
		anim = "talk",
		audio = {"mods/noita.fairmod/fairmod.bank", "copibuddy/makeover"},
		frames = 120,
		weight = 0.3,
		update = function(copibuddy) -- this function is called every frame while event is active

			if(copibuddy.timer == 30)then
				copibuddy.animation = "copi_snap"
			end

			SetRandomSeed(GameGetFrameNum() + copibuddy.x, GameGetFrameNum() + copibuddy.y)
			
			if(copibuddy.timer == 20)then
	
				local players = EntityGetWithTag("player_unit")
				if(players[1])then
					LoadGameEffectEntityTo( players[1], "mods/noita.fairmod/files/content/cheats/misc/polymorph_hamis.xml" )
				end

				GamePlaySound( "mods/noita.fairmod/fairmod.bank", "copibuddy/snap", 0, 0 )
			end

		end,
	},
	{
		text = "I have detected a scam caller and routed your call to a safe caller.",
		anim = "talk",
		audio = {"mods/noita.fairmod/fairmod.bank", "copibuddy/scam_caller"},
		force = true,
		condition = function(copibuddy)
			local valid = GameHasFlagRun("copibuddy.call_rerouted")
			GameRemoveFlagRun("copibuddy.call_rerouted")

			return valid
		end,
	}
}