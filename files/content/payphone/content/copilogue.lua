return {
		name = "Copi",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_copi.png",
		typing_sound = "sans",
		text = [[I see you have followed my instructions.
Well done, {@color 80FF80}{@pause 15}disciple{@pause 15}-to{@pause 15}-be{@pause 15}.
{@color 808080}{@sound default}(P.S. Drop the copimail to get normal calls)]],
		options = {
			{
				text = "Okay, okay, what now..?",
				func = function(dialog)
					dialog.show({
						portrait = "mods/noita.fairmod/files/content/payphone/portrait_copi2.png",
						text = [[I will bequeath upon you my mightiest weapon.
{@sound garbled}{@delay 10}{@color FF0000}#Slay 20 hiidet with it.#]],
						options = {
							{
								text = "Yes, milord.",
								func = function(dialog)
									local players = GetPlayers() or {}
									for i=1, #players do
										local weapon = EntityLoad("mods/noita.fairmod/files/content/payphone/copilogue/weapon.xml", EntityGetTransform(players[i]))
										GamePickUpInventoryItem(players[i], weapon, true)
									end
									hangup()
								end,
							},
							{
								text = "I have done so, oh copious one.",
								func = function(dialog)
									dialog.show({
										portrait = "mods/noita.fairmod/files/content/payphone/portrait_copi2.png",
										text = [[Wonderful.]],
										options = {
											{
												text = "I concur.",
												func = function(dialog)
													local players = GetPlayers() or {}
													dofile("data/scripts/gun/gun.lua")
													for i=1, #players do
														for j=1, 25 do
															SetRandomSeed(420, 69+j)
															local result = actions[Random(1, #actions)]
															CreateItemActionEntity( result.id, EntityGetTransform(players[i]) )
														end
													end
													GlobalsSetValue("copi_winnerness", "-1000000")
													AddFlagPersistent("fairmod_copi_evil_letter")
													hangup()
												end,
											},
											{
												text = "That's... it?",
												func = function(dialog)
													local players = GetPlayers() or {}
													GamePrintImportant("Your greed sickens me.")
													for i=1, #players do
														EntityKill(players[i])
													end
													hangup()
												end,
											}
										},
									})
								end,
								enabled = function()
									return tonumber(GlobalsGetValue("copi_winnerness", "0") or "0") >= 20
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
	}