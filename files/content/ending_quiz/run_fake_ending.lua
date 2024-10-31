local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 9999
dialog_system.dialog_box_height = 100
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
SetRandomSeed(x + GameGetFrameNum(), y)
local quiz_timer = tonumber(GlobalsGetValue( "fairmod_endquiz_timer", "-1" ))
if quiz_timer > 0 then
	quiz_timer = quiz_timer - 1
	if quiz_timer == 0 then
		local plyrs = EntityGetWithTag("player_unit")
		for l=1,#plyrs do
			EntityInflictDamage( plyrs[l], 999999, "DAMAGE_CURSE", "time's up", "NONE", 0, 0, plyrs[l] )
			EntityKill(plyrs[l])
		end
		GamePlaySound( "mods/noita.fairmod/fairmod.bank", "ending_quiz/millionare_music_stop", x, y )
		dialog.close()
	end
	GlobalsSetValue( "fairmod_endquiz_timer", tostring(quiz_timer) )
end

local sampo_check = EntityGetInRadiusWithTag(x,y,20,"this_is_sampo") or {}
local uicomp = EntityGetFirstComponentIncludingDisabled(entity_id,"InteractableComponent")
if #sampo_check > 0 then
    ComponentSetValue2(uicomp,"ui_text","$hint_endingmcguffin_use")
else
    ComponentSetValue2(uicomp,"ui_text"," ")
end

run_real_ending = function(x,y)

	if y < 0 then 
		-- Mountain Altar Ending
		EntityLoad("data/entities/animals/boss_centipede/ending/ending_sampo_spot_mountain.xml",x,y)
	else
		-- The Work ending
		EntityLoad("data/entities/animals/boss_centipede/ending/ending_sampo_spot_underground.xml",x,y)
	end

	GamePlaySound( "mods/noita.fairmod/fairmod.bank", "ending_quiz/cheer", x, y )
	GamePlaySound( "mods/noita.fairmod/fairmod.bank", "ending_quiz/mario_course_clear", x, y )

    EntityLoad("mods/noita.fairmod/files/content/ending_quiz/confetti.xml",x,y)
    EntityLoad("mods/noita.fairmod/files/content/ending_quiz/confetti.xml",x+50,y)
    EntityLoad("mods/noita.fairmod/files/content/ending_quiz/confetti.xml",x-50,y)
    EntityLoad("mods/noita.fairmod/files/content/ending_quiz/confetti.xml",x+100,y)
    EntityLoad("mods/noita.fairmod/files/content/ending_quiz/confetti.xml",x-100,y)
    
	dofile( "data/entities/animals/boss_centipede/ending/sampo_start_ending_sequence.lua")
end

function wrong_answer()
	GlobalsSetValue( "fairmod_endquiz_timer", "-1" ) --Pause the timer now that they've answered, it would be awesome to have this show in the ui
	GamePlaySound( "mods/noita.fairmod/fairmod.bank", "ending_quiz/millionare_ask", x, y )
	GamePlaySound( "mods/noita.fairmod/fairmod.bank", "ending_quiz/millionare_music_stop", x, y )
	dialog.show({
		text = "...",
		options = {
			{
				text = "...?",
				func = function(dialog)
					GameTriggerMusicFadeOutAndDequeueAll(1)
					dialog.show({
						text = "I'm sorry, that was not the correct answer. Goodbye.",
						options = {
							{
								text = "Wait...",
								func = function(dialog)
									local plyrs = EntityGetWithTag("player_unit")
									for l=1,#plyrs do
										EntityInflictDamage( plyrs[l], 999999, "DAMAGE_CURSE", "bad answer", "NONE", 0, 0, player_id )
										EntityKill(plyrs[l])
										dialog.close()
									end
								end,
							},
						},
					})
				end,
			},
		},
	})
end

function right_answer()
	GlobalsSetValue( "fairmod_endquiz_timer", "-1" ) --Pause the timer now that they've answered, it would be awesome to have this show in the ui
	GamePlaySound( "mods/noita.fairmod/fairmod.bank", "ending_quiz/millionare_ask", x, y )
	GamePlaySound( "mods/noita.fairmod/fairmod.bank", "ending_quiz/millionare_music_stop", x, y )
	dialog.show({
		text = "...",
		options = {
			{
				text = "...?",
				func = function(dialog)
					GamePlaySound( "mods/noita.fairmod/fairmod.bank", "ending_quiz/millionare_music_stop", x, y )
					dialog.show({
						text = "That is the correct answer!!!\nCongratulations lucky contestant!\nYou've just beaten the game!!",
						options = {
							{
								text = "YES!!!",
								func = function(dialog)
									AddFlagPersistent("fairmod_noitillionare_winner")
									set_controls_enabled(true)
									run_real_ending(x,y)
									dialog.close()
									EntityKill(building_id)
								end,
							},
						},
					})
				end,
			},
		},
	})
end

function generate_quiz_table()
	local opts = {"circle","square","triangle","diamond","rectangle","pentagon","star"}
	local choices = {}
	local answer = GlobalsGetValue("fairmod_ending_quiz_shape","square")
	for k=1,#opts do
		if opts[k] == answer then
			table.remove(opts,k)
			break
		end
	end
	for k=1,4 do
		local rng = Random(1,#opts)
		print(opts[rng])
		table.insert(choices,{opts[rng],false})
		table.remove(opts,rng)
	end
	table.insert(choices,Random(1,4),{answer,true})

	local dialogue_table = {}
	for k=1,#choices do
		table.insert(dialogue_table,
		{
			text = table.concat({"It was a ",choices[k][1]}),
			enabled = function(stats)
				return true
			end,
			func = function(dialog)
				if choices[k][2] == true then
					right_answer()
				else
					wrong_answer()
				end
			end
		}
	)
	end
	return(dialogue_table)
end

function set_controls_enabled(enabled) --Disable's player's controls
	local player = EntityGetWithTag("player_unit")[1]
	if player then
		local controls_component = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")
		ComponentSetValue2(controls_component, "enabled", enabled)
		for prop, val in pairs(ComponentGetMembers(controls_component) or {}) do
			if prop:sub(1, 11) == "mButtonDown" then
				ComponentSetValue2(controls_component, prop, false)
			end
		end
	end
end

function interacting(player_id, building_id, interactable_name)

	if #sampo_check > 0 then
		set_controls_enabled(false)
		local quiz_table = generate_quiz_table()
		GameTriggerMusicFadeOutAndDequeueAll(1)
		--Kill the sampo, it's your ticket to enter the game show
		for k=1,#sampo_check do
			EntityKill(sampo_check[k])
		end

		dialog = dialog_system.open_dialog({
			name = "Noitillionare Host",
			portrait = "mods/noita.fairmod/files/content/ending_quiz/portrait_noitillionare.png",
			typing_sound_interval = 5,
			typing_sound = "three", -- There are currently 6: default, sans, one, two, three, four and "none" to turn it off, if not specified uses "default"
			text = [[Greetings lucky contestant!
			You're about to complete the work but we have one
			final quiz for you before you can finish!]],
			options = {
				--Continue introduction
				{
					text = "Wait what?",
					enabled = function(stats)
						return true
					end,
					func = function(dialog)
						GlobalsSetValue( "fairmod_endquiz_timer", "1920" ) --I'll be nice and give them an extra 2 seconds for the text to render cinematically
						GamePlaySound( "mods/noita.fairmod/fairmod.bank", "ending_quiz/millionare_music", x, y )
						dialog.show({
							text = [[At the start of your run there was a shape near spawn!
							This is important so remember hard!
							What shape was it?
							You have 30 seconds to answer.]],
							options = quiz_table
						})
					end,
				}
			}
		})
	end
end
