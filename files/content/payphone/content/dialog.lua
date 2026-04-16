local userseed = ModSettingGet("fairmod.userseed")

local function get_distance(x1, y1, x2, y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

local function statue_get_distance()
	local player = (EntityGetWithTag("player_unit") or {})[1]
	if player == nil or not EntityGetIsAlive(player) then return 10000 end
	local x, y = EntityGetTransform(player)

	local statue = EntityGetClosestWithTag(x, y, "phonecall_statue")
	if statue == nil or not EntityGetIsAlive(statue) then return 10000 end
	local x2, y2 = EntityGetTransform(statue)

	return get_distance(x, y, x2, y2)
end

local function statue_check()
	local statue = EntityGetClosestWithTag(x, y, "phonecall_statue")

	local dist = statue_get_distance()
	if dist < 25 then
		local phys = EntityGetFirstComponent(statue, "PhysicsBody2Component")
		local x, y, angle, vel_x, vel_y, angular_vel = PhysicsComponentGetTransform(phys)
		PhysicsComponentSetTransform(phys, x, y, angle, vel_x + 20, vel_y - 1, -20)
		return true
	end
	return dist > 100
end

local function statue_closeness_dialog(dialog)
	if statue_check() then hangup() end

	local requests = {
		"Closer . . .",
		"No, closer.",
		"No, you're too far.",
		"Come closer.",
		"Not close enough.",
	}
	local responses = {
		"How's this?",
		"Am I close enough?",
		"Here?",
		"How about now?",
	}
	dialog.show({
		text = requests[Random(1, #requests)],
		options = {
			{
				text = responses[Random(1, #responses)],
				func = statue_closeness_dialog,
			},
			{
				text = "Bye",
				func = function(dialog)
					hangup()
				end,
			},
		},
	})
end

-- I use this for debugging :)

do
	--[[return {

	}]]
end

return {
	{
		name = "Unknown Caller",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		typing_sound = "sans",
		text = [[Hello!! Is your refrigerator running?]],
		options = {
			{
				text = "I.. Think so?",
				func = function(dialog)
					dialog.show({
						text = [[Well you better go catch it!!! HAHAHAHAHAHA!!! {@func disconnected}]],
						options = {
							{
								text = "...",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Who is this?",
				func = function(dialog)
					dialog.show({
						text = [[Well you better go catch it!!! HAHAHAHAHAHA!!! {@func disconnected}]],
						options = {
							{
								text = "...",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "I'm calling the police.",
				func = function(dialog)
					dialog.show({
						text = [[Well you better go catch it!!! HAHAHAHAHAHA!!! {@func disconnected}]],
						options = {
							{
								text = "...",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Goodbye",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "Unknown Caller",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		typing_sound_interval = 5,
		typing_sound = "pop",
		text = [[Hello.. Is this that, witch..? \\*blub\\*]],
		can_call = function() -- optional
			return tonumber(GlobalsGetValue("loan_shark_debt", "0")) >= 50
		end,
		options = {
			{
				text = "Uhh, yes..? Who is this?",
				func = function(dialog)
					dialog.show({
						text = [[\\*blub\\* Just reminding you, you should pay off your debts,
	or {@color b82318}#you will regret it.#{@func disconnected}]],
						options = {
							{
								text = "...",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "You got the wrong number.",
				func = function(dialog)
					dialog.show({
						text = [[Oh.. I'm sorry. \\*blub\\* {@func disconnected}]],
						options = {
							{
								text = "...",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Goodbye",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "Telemarketer",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		typing_sound = "two",
		text = [[
			Hello! I'm calling from Wand Insurance Co.
			Do you have a moment to talk about your wand's extended
			warranty?
			]],
		options = {
			{
				text = "I'm not interested.",
				func = function(dialog)
					dialog.show({
						text = [[Oh, but this is a limited time offer!
							You don't want to miss out right?]],
						options = {
							{
								text = "No, thanks.",
								func = function(dialog)
									dialog.show({
										text = [[Alright, have a magical day! {@func disconnected}]],
										options = {
											{
												text = "...",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})
								end,
							},
							{
								text = "Goodbye.",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Tell me more.",
				func = function(dialog)
					dialog.show({
						text = [[Wonderful!
							For just 600 gold, you can extend your wand's
							warranty for another year.]],
						options = {
							{
								text = "Sign me up! (600 gold)",
								enabled = function(stats)
									return stats.gold >= 600
								end,
								func = function(dialog)
									dialog.show({
										text = [[Great! Your wand is now covered.
											Thank you for your business! {@func disconnected}]],
										options = {
											{
												text = "...",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})

									-- remove gold
									local players = EntityGetWithTag("player_unit") or {}

									if players == nil or #players == 0 then return end

									local player = players[1]

									local wallet_component = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
									local gold = ComponentGetValue2(wallet_component, "money")

									ComponentSetValue2(wallet_component, "money", gold - 600)
								end,
							},
							{
								text = "On second thought, nevermind.",
								func = function(dialog)
									dialog.show({
										text = [[No problem! Have a magical day! {@func disconnected}]],
										options = {
											{
												text = "...",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})
								end,
							},
						},
					})
				end,
			},
			{
				text = "Hang up.",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "Suspicious Caller",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		typing_sound = "three",
		text = [[We have detected unusual activity on your bank account.
	Please provide your account number to verify your
	identity.]],
		func = function(dialog)
			dialog_system.dialog_box_height = 100
		end,
		options = {
			{
				text = "Sure, it's " .. Random(100000, 999999) .. ".",
				func = function(dialog)
					dialog.show({
						text = [[Thank you. Your account has been secured. {@func disconnected}]],
						options = {
							{
								text = "Wait...",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})

					-- remove all gold
					local players = EntityGetWithTag("player_unit") or {}

					if players == nil or #players == 0 then return end

					local player = players[1]

					local wallet_component = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")

					ComponentSetValue2(wallet_component, "money", 0)
				end,
			},
			{
				text = "I don't have a bank account.",
				func = function(dialog)
					dialog.show({
						text = [[Oh, my mistake. Have a good day. {@func disconnected}]],
						options = {
							{
								text = "Hmm.",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Nice try, scammer.",
				func = function(dialog)
					dialog.show({
						text = [[You can't blame me for trying!! {@func disconnected}]],
						options = {
							{
								text = "Unbelievable.",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Hang up.",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "Wrong Number",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		typing_sound = "default",
		text = [[Hey, is this Bob?]],
		options = {
			{
				text = "No, you have the wrong number.",
				func = function(dialog)
					dialog.show({
						text = [[Oh, sorry about that! Have a good day! {@func disconnected}]],
						options = {
							{
								text = "You too.",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Yes, this is Bob.",
				func = function(dialog)
					dialog.show({
						text = [[Great! About that gold you owe me...]],
						options = {
							{
								text = "Uh, gotta go!",
								func = function(dialog)
									hangup()
								end,
							},
							{
								text = "Sorry, wrong Bob.",
								func = function(dialog)
									dialog.show({
										text = [[Dang.. {@func disconnected}]],
										options = {
											{
												text = "Phew.",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})
								end,
							},
						},
					})
				end,
			},
			{
				text = "Hang up.",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "Survey Taker",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		typing_sound = "gibberish",
		text = [[Hello! Would you like to participate in a short survey about
	your recent cave-dwelling experiences?]],
		func = function(dialog)
			dialog_system.dialog_box_height = 100
		end,
		options = {
			{
				text = "Sure, why not.",
				func = function(dialog)
					-- Define survey functions
					local function survey_end(dialog, reward_final)
						local players = EntityGetWithTag("player_unit") or {}
						if players == nil or #players == 0 then return end
						local player = players[1]
						local wallet_component = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
						local gold = ComponentGetValue2(wallet_component, "money")
						ComponentSetValue2(wallet_component, "money", gold + 500)
						local x, y = EntityGetTransform(player)

						dialog.show({
							text = [[Thank you for participating in our survey! As a token of our
	appreciation, please accept 500 gold! {@func disconnected}]],
							options = {
								{
									text = "Thank you!",
									func = function(dialog)
										if reward_final == "nuke" then
											local x, y = EntityGetTransform(player)
											EntityLoad("data/entities/projectiles/deck/nuke.xml", x, y)
										elseif reward_final == "snails" then
											for i = 1, 100 do
												-- get a random angle radian
												local angle = math.rad(Random(0, 360))
												-- get a random direction vector
												local dx = math.cos(angle)
												local dy = math.sin(angle)

												local distance = Random(100, 250)

												local target_x = x + (dx * distance)
												local target_y = y + (dy * distance)

												local hit = RaytracePlatforms(target_x, target_y, target_x, target_y - 5)

												if not hit then
													EntityLoad(
														"mods/noita.fairmod/files/content/immortal_snail/entities/snail.xml",
														target_x,
														target_y
													)
												end
											end
										elseif reward_final == "liminal" then
											EntityApplyTransform(player, 1547, 14900)
										elseif reward_final == "larpa" then
											GameAddFlagRun("payphone_larpa")
										elseif reward_final == "copibuddy" then
											GameAddFlagRun("copibuddy")
										end
										hangup()
									end,
								},
							},
						})
					end

					-- Add 500 gold
					local function survey_question4(dialog)
						dialog.show({
							text = [[Any suggestions for improving the experience?]],
							options = {
								{
									text = "Nope, it is perfect!",
									func = function(dialog)
										survey_end(dialog)
									end,
								},
								{
									text = "Everybody loves larpa.",
									func = function(dialog)
										survey_end(dialog, "larpa")
									end,
								},
								{
									text = "More explosions!!",
									func = function(dialog)
										survey_end(dialog, "nuke")
									end,
								},
								{
									text = "Additional snails.",
									func = function(dialog)
										survey_end(dialog, "snails")
									end,
								},
								{
									text = "Make it liminal.",
									func = function(dialog)
										survey_end(dialog, "liminal")
									end,
								},
								{
									text = "Give me a friend.",
									func = function(dialog)
										survey_end(dialog, "copibuddy")
									end,
								},
							},
						})
					end

					local function survey_question3(dialog)
						dialog.show({
							text = [[Interesting.. Have you experienced any glitches, strange
								spells, or other anomalies?]],
							options = {
								{
									text = "A lot of them.",
									func = survey_question4,
								},
								{
									text = "Can.. You be more specific?",
									func = survey_question4,
								},
								{
									text = "Rarely",
									func = survey_question4,
								},
								{
									text = "Never",
									func = survey_question4,
								},
							},
						})
					end

					local function survey_question2(dialog)
						dialog.show({
							text = [[Have you seen a snail?]],
							options = {
								{
									text = "A.. A snail?",
									func = survey_question3,
								},
								{
									text = "N.. No?",
									func = survey_question3,
								},
								{
									text = "Oh yes, that fucker has been chasing me.",
									func = survey_question3,
								},
							},
						})
					end

					local function survey_question1(dialog)
						dialog.show({
							text = [[Great! On a scale of 1 to 5, how would you rate your recent
								exploration experience?]],
							options = {
								{
									text = "1",
									func = survey_question2,
								},
								{
									text = "2",
									func = survey_question2,
								},
								{
									text = "3",
									func = survey_question2,
								},
								{
									text = "4",
									func = survey_question2,
								},
								{
									text = "5",
									func = survey_question2,
								},
							},
						})
					end

					-- Start the survey
					survey_question1(dialog)
				end,
			},
			{
				text = "No, thanks.",
				func = function(dialog)
					dialog.show({
						text = [[No problem! Have a great day! {@func disconnected}]],
						options = {
							{
								text = "You too.",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Hang up.",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "Game Show Host",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		typing_sound = "four",
		text = [[Congratulations! You've been selected to answer a question
				for a chance to win 1000 gold coins!
				Are you ready to play?]],
		options = {
			{
				text = "Yes!",
				func = function(dialog)
					dialog.show({
						text = [[Fantastic! Here is your question:
									What are the 3 numbers on the back of your credit card?]],
						options = {
							{
								text = userseed:sub(28, 30),
								func = function(dialog)
									dialog.show({
										text = [[Correct! You've won 1000 gold! {@func disconnected}]],
										options = {
											{
												text = "Wait, what?",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})

									-- add gold
									local players = EntityGetWithTag("player_unit") or {}

									if players == nil or #players == 0 then return end

									local player = players[1]

									local wallet_component = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
									local gold = ComponentGetValue2(wallet_component, "money")

									ComponentSetValue2(wallet_component, "money", gold + 1000)
								end,
							},
							{
								text = "I don't think so.",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "No, thanks.",
				func = function(dialog)
					dialog.show({
						text = [[Alright, maybe next time! {@func disconnected}]],
						options = {
							{
								text = "Goodbye.",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Hang up.",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "Unknown Caller",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		typing_sound = "default",
		text = [[Hello? Is Anyone there? 
		I'm lost in some underground jungle!]],
		options = {
			{
				text = "Yes, I'm  here. Where are you?",
				func = function(dialog)
					dialog.show({
						text = [[I'm near some.. Vines?
							Oh god they're everywhere, please help..]],
						options = {
							{
								text = "I'll try. Describe your surroundings in detail.",
								func = function(dialog)
									dialog.show({
										text = [[Wait, I see a light! I think I found the exit!
		Thank you! {@func disconnected}]],
										options = {
											{
												text = "I.. didn't do anything.",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})
								end,
							},
							{
								text = "Sorry, I can't help.",
								func = function(dialog)
									dialog.show({
										text = [[Oh... Okay. I'll keep searching. {@func disconnected}]],
										options = {
											{
												text = "Good luck.",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})
								end,
							},
						},
					})
				end,
			},
			{
				text = "Hang up.",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "Wizard Academy",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		typing_sound = "two",
		text = [[Greetings!
			This is the Wizard Academy reminding you about your
			overdue library books.]],
		options = {
			{
				text = "I don't recall borrowing any books.",
				func = function(dialog)
					dialog.show({
						text = [[Our records show you have
							"Nuclear Theory for the Ambitious Apprentice"
							checked out.
							Please return it promptly to avoid a fine.]],
						options = {
							{
								text = "I'll return it soon.",
								func = function(dialog)
									dialog.show({
										text = [[Thank you for your cooperation! {@func disconnected}]],
										options = {
											{
												text = "You're welcome.",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})
								end,
							},
							{
								text = "I think you have the wrong person.",
								func = function(dialog)
									dialog.show({
										text = [[Oh, apologies for the mix-up.
											Have a good day! {@func disconnected}]],
										options = {
											{
												text = "No problem.",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})
								end,
							},
						},
					})
				end,
			},
			{
				text = "Hang up.",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "Shady Merchant",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		typing_sound = "two",
		text = [[Greetings! Interested in purchasing a rare artifact?]],
		options = {
			{
				text = "What are you offering?",
				func = function(dialog)
					local hm_visits = math.max(math.min(tonumber(GlobalsGetValue("HOLY_MOUNTAIN_VISITS", "0")) or 0, 6), 1)
					local price = hm_visits * 200
					dialog.show({
						text = "I have a powerful wand for only " .. price .. " gold. Interested?",
						options = {
							{
								text = "Yes, I'll take it. (" .. price .. " gold)",
								enabled = function(stats)
									return stats.gold >= price
								end,
								func = function(dialog)
									-- Deduct gold and give item
									local players = EntityGetWithTag("player_unit") or {}
									if #players > 0 then
										local player = players[1]
										local wallet = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
										local gold = ComponentGetValue2(wallet, "money")
										ComponentSetValue2(wallet, "money", gold - price)

										local x, y = EntityGetTransform(player)

										EntityLoad(
											"mods/noita.fairmod/files/content/payphone/entities/corrupted_wands/wand_level_0"
												.. tostring(hm_visits)
												.. ".xml",
											x,
											y
										)
									end
									dialog.show({
										text = [[Pleasure doing business with you! {@func disconnected}]],
										options = {
											{
												text = "Likewise.",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})
								end,
							},
							{
								text = "Too expensive for me.",
								func = function(dialog)
									dialog.show({
										text = [[Understandable. Maybe next time. {@func disconnected}]],
										options = {
											{
												text = "Maybe.",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})
								end,
							},
						},
					})
				end,
			},
			{
				text = "Not interested.",
				func = function(dialog)
					dialog.show({
						text = [[Very well. Safe travels! {@func disconnected}]],
						options = {
							{
								text = "Goodbye.",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
		},
	},
	{
		name = "Roman",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		typing_sound = "four",
		text = [[Niko it's Roman.
				Let's go bowling.]],
		options = {
			{
				text = "Sure thing!",
				func = function(dialog)
					dialog.show({
						text = [[Okay, I'll come to get you in an hour, be ready!]],
						options = {
							{
								text = "Sounds good, I'll see you soon then.",
								func = function(dialog)
									local player_id = EntityGetWithTag("player_unit")
									for k = 1, #player_id do
										local x, y = EntityGetTransform(player_id[k])
										EntityAddChild(
											player_id[k],
											EntityLoad("mods/noita.fairmod/files/content/payphone/content/bowling/bowling_timer.xml", x, y)
										)
									end
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "I can't right now I'm busy.",
				func = function(dialog)
					dialog.show({
						text = [[Okay, we'll make arrangement for another time!]],
						options = {
							{
								text = "Goodbye.",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
		},
	},
	{
		name = "Copi",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_copi.png",
		typing_sound = "sans",
		text = [[{@color C0FFC0}Hello, It is I. Copi of things!!]],
		options = {
			{
				text = "H.. Hello?",
				func = function(dialog)
					dialog.show({
						text = [[{@color C0FFC0}Just calling to see if your ~Copi's Things~ mod is running!
	{@color 808080}{@pause 15}(Don't lie, or you'll #suffer#!)]],
						options = {
							{
								text = "No it is not..",
								func = function(dialog)
									dialog.show({
										text = [[{@color C0FFC0}Oh what the scallop!! you better enable it #NOW#.]],
										options = {
											{
												text = "No I don't think I will.",
												func = function(dialog)
													dialog.show({
														text = [[{@color C0FFC0}What if I promise you an ~achievement~ if you do{@delay 15} #.# #.# #?#]],
														options = {
															{
																text = "Deal!",
																func = function(dialog)
																	hangup()
																end,
															},
															{
																text = "Maybe another time.",
																func = function(dialog)
																	hangup()
																end,
															},
														},
													})
												end,
											},
											{
												text = "Of-course my great Copi, creator of things.",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})
								end,
							},
							{
								text = "Yes it is!",
								func = function(dialog)
									if ModIsEnabled("copis_things") then
										if tonumber(GlobalsGetValue("copis_things_version")) <= 0.5 then
											dialog.show({
												text = [[{@color C0FFC0}Hmmmmm{@delay 15}#.# #.# #.# {@delay 3}{@pause 30}My copisenses are {@pause 20}~tingling~!{@pause 30}
	Your version is not up to date! Make sure to update it!{@func disconnected}]],
												options = {
													{
														text = "...",
														func = function(dialog)
															hangup()
														end,
													},
												},
											})
										else
											dialog.show({
												text = [[{@color C0FFC0}Well you better go catch it! ~hehehe!~ {@func disconnected}]],
												options = {
													{
														text = "...",
														func = function(dialog)
															-- Blessings of COpi
															dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")
															local a, b = EntityGetTransform(GetPlayers()[1])
															dofile_once("data/scripts/gun/gun_actions.lua")
															local c = {}
															for d = 1, #actions do
																if actions[d].author == "Copi" then c[#c + 1] = actions[d].id end
															end
															for d = 0, 7 do
																local e = math.pi / 8 * d
																local f = a + 20 * math.cos(e)
																local g = b - 20 * math.sin(e)
																CreateItemActionEntity(c[math.random(1, #c)], f, g)
															end
															EntityLoad("data/entities/particles/image_emitters/perk_effect.xml", a, b)
															hangup()
														end,
													},
												},
											})
										end
									else
										for k, v in ipairs(GetPlayers()) do
											EntityAddComponent2(v, "LuaComponent", {
												script_source_file = "mods/noita.fairmod/files/content/payphone/content/copi/curse_of_copi.lua",
												execute_every_n_frame = 60,
											})
										end
										dialog.show({
											text = [[{@sound default}{@delay 10}{@color FF0000}#LIAR.#
	{@delay 3}{@color C0FFC0}Go install it now to end the curse! {@delay 30}{@color FF0000}:3]],
											options = {
												{
													text = "...",
													func = function(dialog)
														hangup()
													end,
												},
											},
										})
									end
								end,
							},
						},
					})
				end,
			},
			{
				text = "Hang up.",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "Commando 'Risk' O'Rain",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_commando.png",
		typing_sound = "default",
		text = [[Captain? Is that you?]],
		options = {
			{
				text = "COMMANDO I NEED YOU TO BRING ME TONICS.",
				func = function(dialog)
					dialog.show({
						portrait = "mods/noita.fairmod/files/content/payphone/portrait_commando_whar.png",
						text = [[Cap'n I'm talling you it's an addiction{@delay 15}...{@func disconnected}]],
						options = {
							{
								text = "...",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Who is this?",
				func = function(dialog)
					dialog.show({
						text = [[{@delay 15}... {@delay 3}Wrong number.{@func disconnected}]],
						options = {
							{
								text = "...",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Goodbye",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	-- Condensed these two into one, randomly chooses between them
	Random(1, 2) == 1
			and {
				name = "Lamia",
				portrait = "mods/noita.fairmod/files/content/payphone/content/portrait_lamia.xml",
				text = "Psst..\nHave you tried Meta Leveling?",
				options = {
					{
						text = "My favourite mod",
						func = function(dialog)
							dialog.show({
								text = "Don't play it with fairmod though.\nThis is meant to be painful.{@func disconnected}",
								options = {
									{
										text = "Sure!",
										func = function()
											hangup()
										end,
									},
								},
							})
						end,
					},
					{
						text = "No?",
						func = function(dialog)
							dialog.show({
								text = "That's unfortunate, look what it has!",
								options = {
									{
										text = "Huh?",
										func = function()
											local entity = EntityCreateNew()
											EntityAddComponent2(entity, "LifetimeComponent", { lifetime = 260 })
											local comp = EntityAddComponent2(entity, "ParticleEmitterComponent", {
												emitted_material_name = "spark_green",
												image_animation_file = "mods/noita.fairmod/files/content/payphone/content/meta_leveling/levelup_8.png",
												emit_cosmetic_particles = true,
												emission_interval_min_frames = 1,
												emission_interval_max_frames = 3,
												fade_based_on_lifetime = true,
												friction = 20,
												collide_with_gas_and_fire = false,
												collide_with_grid = false,
												attractor_force = 0.1,
												image_animation_speed = 5,
												image_animation_loop = false,
												lifetime_min = 7,
												lifetime_max = 8,
												color = 0x7f96FF46,
											})
											ComponentSetValue2(comp, "gravity", 0, 0)
											local player = EntityGetWithTag("player_unit")[1]
											local x, y = EntityGetTransform(player)
											EntitySetTransform(entity, x, y - 50)
											hangup()
										end,
									},
								},
							})
						end,
					},
				},
			}
		or {
			name = "Lamia",
			portrait = "mods/noita.fairmod/files/content/payphone/content/portrait_lamia.xml",
			text = "Have you seen flying fish?",
			options = {
				{
					text = "What?",
					func = function(dialog)
						dialog.show({
							text = "I heard it's hiding in some cliffs.{@func disconnected}",
							options = {
								{
									text = "Ok?",
									func = function()
										hangup()
									end,
								},
							},
						})
					end,
				},
				{
					text = "Yes",
					func = function(dialog)
						dialog.show({
							text = "I hope you helped him.{@func disconnected}",
							options = {
								{
									text = "Huh?",
									func = function()
										hangup()
									end,
								},
							},
						})
					end,
				},
			},
		},
	{
		name = "Longest Hämis",
		portrait = "mods/noita.fairmod/files/content/pixelscenes/longest_leg/longest_portrait.xml",
		text = "...",
		options = {
			{
				text = "...?",
				func = function(dialog)
					dialog.show({
						text = "Find me.{@func disconnected}",
						options = {
							{
								text = "???",
								func = function()
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Leave",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "Evaisa",
		portrait = "mods/noita.fairmod/files/content/payphone/content/portrait_eba.png",
		typing_sound = "gibberish",
		text = "Hello, It is I, the eba.",
		options = {
			{
				text = "Hello?",
				func = function(dialog)
					dialog.show({
						text = "Hiii hellooo hii hihiiii hiii :3",
						options = {
							{
								text = "Okay..? So why were you calling?",
								func = function()
									dialog.show({
										text = ":3{@func disconnected}",
										options = {
											{
												text = "Okay... Wait how do you even :3 on a phone?",
												func = function()
													hangup()
												end,
											},
										},
									})
								end,
							},
						},
					})
				end,
			},
			{
				text = "Woahh eba I love your mods you are so cool wow.",
				func = function(dialog)
					dialog.show({
						text = "Thanks!! I shall bless you with my best creations!{@func disconnected}",
						options = {
							{
								text = "This surely won't backfire.",
								func = function()
									local players = EntityGetWithTag("player_unit") or {}

									if players == nil or #players == 0 then return end

									local player = players[1]

									GameDestroyInventoryItems(player)

									local hm_visits = math.max(math.min(tonumber(GlobalsGetValue("HOLY_MOUNTAIN_VISITS", "0")) or 0, 6), 1)
									local x, y = EntityGetTransform(player)

									dofile("data/scripts/perks/perk.lua")

									local tmtrainer_perks = {}

									for i, v in ipairs(perk_list) do
										-- if perk name starts with TMTRAINER_ then add it to the list
										if string.sub(v.id, 1, 10) == "TMTRAINER_" then table.insert(tmtrainer_perks, v.id) end
									end

									for i = 1, 4 do
										local item = EntityLoad(
											"mods/noita.fairmod/files/content/payphone/entities/corrupted_wands/wand_level_0"
												.. tostring(hm_visits)
												.. ".xml",
											x + Random(-15, 15),
											y + Random(-15, 15)
										)

										GamePickUpInventoryItem(player, item, false)

										local perk =
											perk_spawn(x + Random(-15, 15), y + Random(-15, 15), tmtrainer_perks[Random(1, #tmtrainer_perks)], true)

										perk_pickup(perk, player, "", false, false)
									end

									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Hang up.",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "G???O??D????",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		text = "Haha bye.",
		options = {
			{
				text = "What..?",
				func = function(dialog)
					GameAddFlagRun("random_teleport_next")
					--GameAddFlagRun("no_return")

					local players = EntityGetWithTag("player_unit") or {}

					if players == nil or #players == 0 then return end

					local player = players[1]

					local x, y = EntityGetTransform(player)

					EntityLoad("mods/noita.fairmod/files/content/speedrun_door/portal_kolmi.xml", x, y)
					hangup()
				end,
			},
			{
				text = "No u.",
				func = function(dialog)
					dialog.show({
						text = "Wait you can't do that! \n\\*Faint teleporting noise\\*{@func disconnected}",
						options = {
							{
								text = "He didn't see that one coming.",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
		},
	},
	{
		name = "Heinermann",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_heinermann.png",
		text = "Hello, have you heard of the Archipelago mod?",
		options = {
			{
				text = "Yep, I've even played it!",
				func = function(dialog)
					dialog.show({
						text = "Great! Please share it!",
						options = {
							{
								text = "Okay",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Yeah, but I haven't tried it.",
				func = function(dialog)
					dialog.show({
						text = [[Don't be afraid to give it a shot. You can switch between
						different games on your own, or play with others, short
						session, multi-day session, lots of ways to play.]],
						options = {
							{
								text = "Cool, maybe I will",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "No, what is it?",
				func = function(dialog)
					dialog.show({
						text = [[It's a multi-game, multi-world randomizer. You connect
						with multiple games and items are shuffled between them.
					
						Work together to complete all the games!]],
						options = {
							{
								text = "Oh, interesting",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
		},
	},
	{
		name = "Statue?",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_statue.png",
		text = [[Psst . . .
		{@pause 60}
		Come closer . . .]],
		can_call = function() -- optional
			return statue_get_distance() < 100
		end,
		options = {
			{
				text = "How's this?",
				func = statue_closeness_dialog,
			},
			{
				text = "No thanks",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "Garbled Voice",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		typing_sound = "garbled",
		text = [[{@delay 2}#                    H                               E    
		#  #L                                                      
		#                                                #P        
		#  #M                                                      
		#                            #E                            
		]],
		options = {
			{
				text = "wh.. what?",
				func = function(dialog)
					dialog.show({
						text = [[{@delay 1}#                    L                               O
		#  #S
		#                                                #T
		#  #I						#I                    
		#                            #TS     W    R    O    N    G
		]],
						options = {
							{
								text = "I.. I don't understand.",
								func = function(dialog)
									dialog.show({
										text = [[{@delay 10}#      E N TER {@func disconnected} {@func ng_portal}]],
										options = {
											{
												text = "Hang up.",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})
								end,
							},
						},
					})
				end,
			},
			{
				text = "hang up",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "Heavy Breather",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		typing_sound = "breathing",

		text = [[{@delay 60}...]],
		options = {
			{
				text = "Hello?",
				func = function(dialog)
					dialog.show({
						text = [[{@delay 60}...]],
						options = {
							{
								text = "Who is this?",
								func = function(dialog)
									dialog.show({
										text = [[{@delay 60}...{@func disconnected}]],
										options = {
											{
												text = "Creepy.",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})
								end,
							},
							{
								text = "I'm calling the authorities.",
								func = function(dialog)
									dialog.show({
										typing_sound_interval = 5,
										text = [[\\*gasp\\* {@func disconnected}]],
										options = {
											{
												text = "Good riddance.",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})
								end,
							},
						},
					})
				end,
			},
			{
				text = "Hang up.",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "Bomb Threat",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		text = [[{@pause 30}... {@delay 5}Give me 200 gold or I'll blow you up.]],
		options = {
			{
				text = "You can't do that! That's against the law!",
				func = function(dialog)
					ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "bomb,")
					dialog.show({
						text = "We'll see about that.",
						options = {
							{
								text = "Hang up.",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Alright, here you go.",
				enabled = function(stats)
					return stats.gold >= 200
				end,
				func = function(dialog)
					local player = EntityGetWithTag("player_unit")[1]
					if not player then return end
					local wallet = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
					ComponentSetValue2(wallet, "money", ComponentGetValue2(wallet, "money") - 200)

					dialog.show({
						text = "Good choice.",
						options = {
							{
								text = "Okay, bye! Love you!",
								func = function(stats)
									dialog.show({
										text = "??? What ??",
										options = {
											{
												text = "Uh, hang up.",
												func = function(dialog)
													hangup()
												end,
											},
										}
									})
								end,
							},
							{
								text = "Hang up.",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end
			},
		},
	},
	{
		name = "Steve",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_steve.png",
		text = "{@func iamsteve}I... Am Steve. \nAs a child I yearned for the mines.\nBut something always got in the way..",
		typing_sound = "none",
		options = {
			{
				text = "Okay...?",
				func = function(dialog)
					dialog.show({
						text = "{@func iamsteve}But the call of the mines was too strong.. \nSo one day I started digging.. and digging.. \nUntil I found...",
						options = {
							{
								text = "Found WHAT?",
								func = function(dialog)

									local players = EntityGetWithTag("player_unit") or {}
									if players == nil or #players == 0 then return end
									local player = players[1]
									local x, y = EntityGetTransform(player)
									EntityLoad("mods/noita.fairmod/files/content/minecraft/minecraft.xml", x, y)
									dialog.show({
										text = "{@func iamsteve}This.{@func disconnected}",
										options = {
											{
												text = "...",
												func = function(dialog)
													hangup()
												end,
											},
										},
									})

								end,
							},
						},
					})
				end,
			},
			{
				text = "Goodbye Steve.",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
	{
		name = "Copi",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_copi.png",
		typing_sound = "sans",
		text = [[{@color C0FFC0}Greetings! {@pause 10}You've been selected to playtest my 
		top secret project!]],
		can_call = function() -- optional
			return not GameHasFlagRun("is_copibuddied")
		end,
		options = {
			{
				text = "Uhhh... okay?",
				func = function(dialog)
					dialog.show({
						text = [[{@color 808080}{@pause 15}#INSTALLING#{@delay 15} #.# #.# #.#{@func copibuddy}{@func disconnected}]],
						options = {
							{
								text = "...",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Thank you, oh copious one.",
				func = function(dialog)
					dialog.show({
						text = [[{@color 808080}{@pause 15}#INSTALLING#{@delay 15} #.# #.# #.#{@func copibuddy}{@func disconnected}]],
						options = {
							{
								text = "...",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
		},
	},
	{
		name = "Copi",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_copi.png",
		typing_sound = "sans",
		text = [[{@color C0FFC0}Kneel kneel!
		Your lord ~Copi~ {@pause 5}~Of~ {@pause 5}~Things~ {@pause 5} is here!]],
		options = {
			{
				text = "I'm such a big fan!",
				func = function(dialog)
					dialog.show({
						text = [[{@color C0FFC0}I will grant you one of my boons! Go forth! Win fairmod!{@func disconnected}]],
						options = {
							{
								text = "Thank you copi!",
								func = function()
									local players = EntityGetWithTag("player_unit") or {}
									if #players<1 then hangup() return end
									local x, y = EntityGetTransform(players[1])
									dofile("data/scripts/perks/perk.lua")
									perk_pickup(perk_spawn(x + Random(-15, 15), y + Random(-15, 15), perk_list[Random(1, #perk_list)].id, true), players[1], "", false, false)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "I hate you!",
				func = function(dialog)
					dialog.show({
						text = [[{@color C0FFC0}In time you will learn to appreciate me! ~Hahaha!~{@func disconnected}]],
						options = {
							{
								text = "What?",
								func = function()
									ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "hampill,")
									hangup()
								end,
							},
						},
					})
				end,
			},
		},
	},
	{
		name = "Copi",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_copi.png",
		typing_sound = "sans",
		text = "{@color C0FFC0}Have you heard of the Apotheosis mod for noita?",
		options = {
			{
				text = "No..?",
				func = function(dialog)
					dialog.show({
						text = [[{@color C0FFC0}Well now you have!{@func disconnected}]],
						options = {
							{
								text = "Hmm, how insightful. I will look it up on steam workshop now!",
								func = function()
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Yes!",
				func = function(dialog)
					dialog.show({
						text = [[{@color C0FFC0}I'm glad :) it's a really cool project and I'm happy 
						I get to work on it!{@func disconnected}]],
						options = {
							{
								text = "...",
								func = function()
									ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "hampill,")
									hangup()
								end,
							},
						},
					})
				end,
			},
		},
	},
	{
		name = "Copi",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_copi3.png",
		typing_sound = "sans",
		text = [[{@color 800000}{@delay 15} !pesj !pfo !jmnoh !pede !it !pemd" Jxof 
		!gtnpfxm !bbfu !fpfuj@Hp !vl]],
		options = {
			{
				text = "What?",
				func = function(dialog)
					dialog.show({
						portrait = "mods/noita.fairmod/files/content/payphone/portrait_copi.png",
						text = [[{@color C0FFC0}Huh? My head hurts.{@func disconnected}]],
						options = {
							{
								text = "...",
								func = function()
									hangup()
								end,
							},
						},
					})
				end,
			},
		},
	},
	{
		name = "Copi",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_copi4.png",
		typing_sound = "sans",
		text = [[{@color 608060}{@delay 5}Shhhhh, #evil copi# might be listening....]],
		can_call = function() -- optional
			return not HasFlagPersistent("fairmod_evilcopi")
		end,
		options = {
			{
				text = "Who?",
				func = function(dialog)
					dialog.show({
						text = [[{@color 608060}{@delay 5}He's basically me but evil.]],
						options =  {
							{
								text = "You have an evil clone?",
								func = function(dialog)
									dialog.show({
										text = [[{@color 608060}{@delay 5}He keeps raving about some "things". 
										He cannot be trusted.]],
										options =  {
											{
												text = "Uhh...",
												func = function(dialog)
													dialog.show({
														text = [[{@color 608060}{@delay 5}Shit, I've got to go.{@func disconnected}]],
														options = {
															{
																text = "...",
																func = function()
																	AddFlagPersistent("fairmod_evilcopi")
																	hangup()
																end,
															},
														},
													})
												end,
											}
										},
									})
								end,
							}
						},
					})
				end,
			},
		},
	},
	{
		name = "Copi",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_copi4.png",
		typing_sound = "sans",
		text = [[{@color 608060}{@delay 5}Good, so you remembered.]],
		can_call = function() -- optional
			return HasFlagPersistent("fairmod_evilcopi") and not HasFlagPersistent("fairmod_evilcopi2")
		end,
		options = {
			{
				text = "How can I know you're not evil copi?",
				func = function(dialog)
					dialog.show({
						text = [[{@color 608060}{@delay 5}Because I love hamis.]],
						options =  {
							{
								text = "You're telling me evil copi hates hamis?",
								func = function(dialog)
									dialog.show({
										text = [[{@color 608060}{@delay 5}Yes, only evil people hate hamis.
										]]..(tonumber(GlobalsGetValue("FAIRMOD_HAMIS_KILLED", "0")) or 0)>0 and "{@color 808080}~You feel the guilt of having slain hamis.~" or "",
										options =  {
											{
												text = "Got it...",
												func = function(dialog)
													dialog.show({
														text = [[{@color 608060}{@delay 5}He's catching on. 
														You heard nothing.{@func disconnected}]],
														options = {
															{
																text = "...",
																func = function()
																	AddFlagPersistent("fairmod_evilcopi2")
																	hangup()
																end,
															},
														},
													})
												end,
											}
										},
									})
								end,
							}
						},
					})
				end,
			},
		},
	},
	{
		name = "Copi",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_copi4.png",
		typing_sound = "sans",
		text = [[{@color 608060}{@delay 5}We're making progress. 
		I see you've spared hamisket.]],
		can_call = function() -- optional
			return HasFlagPersistent("fairmod_evilcopi2") and (tonumber(GlobalsGetValue("FAIRMOD_HAMIS_KILLED", "0")) or 0)==0
		end,
		options = {
			{
				text = "Why are they so special anyways?",
				func = function(dialog)
					dialog.show({
						text = [[{@color 608060}{@delay 5}They're cute as fuck?]],
						options =  {
							{
								text = "...That's it?",
								func = function(dialog)
									dialog.show({
										text = [[{@color 608060}{@delay 5}Yeah? Evil copi HATES cute hamis.\n]],
										options =  {
											{
												text = "I'll avoid killing them then..",
												func = function(dialog)
													dialog.show({
														text = [[{@color 608060}{@delay 5}Read the back of the info booklet. 
														I left a note.{@func disconnected}]],
														options = {
															{
																text = "...",
																func = function()
																	RemoveFlagPersistent("fairmod_evilcopi2")
																	RemoveFlagPersistent("fairmod_evilcopi")
																	hangup()
																end,
															},
														},
													})
												end,
											}
										},
									})
								end,
							}
						},
					})
				end,
			},
		},
	},
}