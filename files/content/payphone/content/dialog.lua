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

									local wallet_component =
										EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
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
		name = "Heavy Breather",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		typing_sound = "breathing",
		typing_sound_interval = 5,
		text = [[...]],
		options = {
			{
				text = "Hello?",
				func = function(dialog)
					dialog.show({
						text = [[\\*heavy breathing\\*]],
						options = {
							{
								text = "Who is this?",
								func = function(dialog)
									dialog.show({
										text = [[...{@func disconnected}]],
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

												local hit =
													RaytracePlatforms(target_x, target_y, target_x, target_y - 5)

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
								text = tostring(Random(100, 999)),
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

									local wallet_component =
										EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
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
		text = [[Hello? Can Anyone there? \nI'm lost in some underground jungle!]],
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
					local hm_visits =
						math.max(math.min(tonumber(GlobalsGetValue("HOLY_MOUNTAIN_VISITS", "0")) or 0, 6), 1)
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
										local wallet =
											EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
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
		name = "Niko",
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
											EntityLoad(
												"mods/noita.fairmod/files/content/payphone/content/bowling/bowling_timer.xml",
												x,
												y
											)
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
		text = [[Hello, It is I. Copi of things!!]],
		options = {
			{
				text = "H.. Hello?",
				func = function(dialog)
					dialog.show({
						text = [[Just calling to see if your Copith is running!]],
						options = {
							{
								text = "No it is not..",
								func = function(dialog)
									dialog.show({
										text = [[Oh what the scallop!! you better enable it #NOW#.]],
										options = {
											{
												text = "No I don't think I will.",
												func = function(dialog)
													dialog.show({
														text = [[What if I promise you an achievement if you do{@delay 15} #.# #.# #?#]],
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
																	-- Add a script to the player to add a 'herobrine' shadow copi that just subtly appears at the edge of the screen sometimes
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
												text = [[Hmmmmm{@delay 15}#.# #.# #.# {@delay 3}{@pause 30}My copisenses are {@pause 20}~tingling~!{@pause 30}
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
												text = [[Well you better go catch it! ~hehehe!~ {@func disconnected}]],
												options = {
													{
														text = "...",
														func = function(dialog)
															-- Blessings of COpi
															dofile_once(
																"mods/noita.fairmod/files/scripts/utils/utilities.lua"
															)
															local a, b = EntityGetTransform(GetPlayers()[1])
															dofile_once("data/scripts/gun/gun_actions.lua")
															local c = {}
															for d = 1, #actions do
																if actions[d].author == "Copi" then
																	c[#c + 1] = actions[d].id
																end
															end
															for d = 0, 7 do
																local e = math.pi / 8 * d
																local f = a + 20 * math.cos(e)
																local g = b - 20 * math.sin(e)
																CreateItemActionEntity(c[math.random(1, #c)], f, g)
															end
															EntityLoad(
																"data/entities/particles/image_emitters/perk_effect.xml",
																a,
																b
															)
															hangup()
														end,
													},
												},
											})
										end
									else
										for k, v in ipairs(GetPlayers()) do
											EntityAddComponent2(v, "LuaComponent", {
												script_source_file = "mods/noita.fairmod/files/content/payphone/entities/curse_of_copi.lua",
												execute_every_n_frame = 30,
											})
										end
										dialog.show({
											text = [[{@sound default}{@delay 10}{@color FF0000}#LIAR.#
	{@delay 3}{@color FFFFFF}Go install it now to end the curse! {@delay 30}{@color FF0000}:3]],
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
		name = "Longest Hamis",
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

									local hm_visits = math.max(
										math.min(tonumber(GlobalsGetValue("HOLY_MOUNTAIN_VISITS", "0")) or 0, 6),
										1
									)
									local x, y = EntityGetTransform(player)

									dofile("data/scripts/perks/perk.lua")

									local tmtrainer_perks = {}

									for i, v in ipairs(perk_list) do
										-- if perk name starts with TMTRAINER_ then add it to the list
										if string.sub(v.id, 1, 10) == "TMTRAINER_" then
											table.insert(tmtrainer_perks, v.id)
										end
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

										local perk = perk_spawn(
											x + Random(-15, 15),
											y + Random(-15, 15),
											tmtrainer_perks[Random(1, #tmtrainer_perks)],
											true
										)

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
		text = "Haha bye.{@func disconnected} {@func teleport}",
		options = {
			{
				text = "What..?",
				func = function(dialog)
					hangup()
				end,
			},
		},
	},
}
