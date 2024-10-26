local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35
dialog_system.sounds.pop = { bank = "mods/noita.fairmod/fairmod.bank", event = "loanshark/pop" }
-- "mods/noita.fairmod/fairmod.bank", "immersivepiss/timetotakeapiss"
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

SetRandomSeed(x + GameGetFrameNum(), y)

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	local loan_shark_debt = tonumber(GlobalsGetValue("loan_shark_debt", "0"))
	dialog_system.dialog_box_height = 70
	dialog = dialog_system.open_dialog({
		name = "Loanprey",
		portrait = "mods/noita.fairmod/files/content/loan_shark/portrait.png",
		typing_sound_interval = 5,
		typing_sound = "pop", -- There are currently 6: default, sans, one, two, three, four and "none" to turn it off, if not specified uses "default"
		text = "\\*blub\\* \\*blub blub\\* \\*blub\\* ...",
		options = {
			-- loaning money
			{

				text = "I'd like to take out a loan.",
				enabled = function(stats)
					return true
				end,
				func = function(dialog)
					dialog_system.dialog_box_height = 100
					dialog.show({
						text = loan_shark_debt < 10000 and "\\*blub!\\* \\*blub blub blub..\\*"
							or "I cannot loan you any more money. \n\\*blub\\* Pay off your debts or {@color b82318}#you will regret it.#",
						options = {
							{
								text = "Take loan (50 gold)",
								enabled = function(stats)
									return loan_shark_debt < 10000
								end,
								func = function(dialog)
									GameAddFlagRun("reset_debt_timer")
									dialog_system.dialog_box_height = 70
									GlobalsSetValue("loan_shark_debt", tostring(loan_shark_debt + 50))
									local wallet_component = EntityGetFirstComponentIncludingDisabled(
										entity_who_interacted,
										"WalletComponent"
									)
									ComponentSetValue2(
										wallet_component,
										"money",
										ComponentGetValue2(wallet_component, "money") + 50
									)
									dialog.show({
										text = "Please return the money soon \\*blub\\* \nor {@color b82318}#I will send my collectors. #{@color FFFFFF}",
										options = {
											{
												text = "Leave",
											},
										},
									})
								end,
							},
							{
								text = "Take loan (100 gold)",
								enabled = function(stats)
									return loan_shark_debt < 10000
								end,
								func = function(dialog)
									GameAddFlagRun("reset_debt_timer")
									dialog_system.dialog_box_height = 70
									GlobalsSetValue("loan_shark_debt", tostring(loan_shark_debt + 100))
									local wallet_component = EntityGetFirstComponentIncludingDisabled(
										entity_who_interacted,
										"WalletComponent"
									)
									ComponentSetValue2(
										wallet_component,
										"money",
										ComponentGetValue2(wallet_component, "money") + 100
									)
									dialog.show({
										text = "Please return the money soon \\*blub\\* \nor {@color b82318}#I will send my collectors. #{@color FFFFFF}",
										options = {
											{
												text = "Leave",
											},
										},
									})
								end,
							},
							{
								text = "Take loan (500 gold)",
								enabled = function(stats)
									return loan_shark_debt < 10000
								end,
								func = function(dialog)
									GameAddFlagRun("reset_debt_timer")
									dialog_system.dialog_box_height = 70
									GlobalsSetValue("loan_shark_debt", tostring(loan_shark_debt + 500))
									local wallet_component = EntityGetFirstComponentIncludingDisabled(
										entity_who_interacted,
										"WalletComponent"
									)
									ComponentSetValue2(
										wallet_component,
										"money",
										ComponentGetValue2(wallet_component, "money") + 500
									)
									dialog.show({
										text = "Please return the money soon \\*blub\\* \nor {@color b82318}#I will send my collectors. #{@color FFFFFF}",
										options = {
											{
												text = "Leave",
											},
										},
									})
								end,
							},
							{
								text = "Take loan (1000 gold)",
								enabled = function(stats)
									return loan_shark_debt < 10000
								end,
								func = function(dialog)
									GameAddFlagRun("reset_debt_timer")
									dialog_system.dialog_box_height = 70
									GlobalsSetValue("loan_shark_debt", tostring(loan_shark_debt + 1000))
									local wallet_component = EntityGetFirstComponentIncludingDisabled(
										entity_who_interacted,
										"WalletComponent"
									)
									ComponentSetValue2(
										wallet_component,
										"money",
										ComponentGetValue2(wallet_component, "money") + 1000
									)
									dialog.show({
										text = "Please return the money soon \\*blub\\* \nor {@color b82318}#I will send my collectors. #{@color FFFFFF}",
										options = {
											{
												text = "Leave",
											},
										},
									})
								end,
							},
							{
								text = "Take loan (5000 gold)",
								enabled = function(stats)
									return loan_shark_debt < 10000
								end,
								func = function(dialog)
									GameAddFlagRun("reset_debt_timer")
									dialog_system.dialog_box_height = 70
									GlobalsSetValue("loan_shark_debt", tostring(loan_shark_debt + 5000))
									local wallet_component = EntityGetFirstComponentIncludingDisabled(
										entity_who_interacted,
										"WalletComponent"
									)
									ComponentSetValue2(
										wallet_component,
										"money",
										ComponentGetValue2(wallet_component, "money") + 5000
									)
									dialog.show({
										text = "Please return the money soon \\*blub\\* \nor {@color b82318}#I will send my collectors. #{@color FFFFFF}",
										options = {
											{
												text = "Leave",
											},
										},
									})
								end,
							},
							{
								text = "Leave",
							},
						},
					})
				end,
			},
			-- paying debt
			{
				text = "I'd like to pay off my debt.",
				enabled = function(stats)
					return loan_shark_debt > 0
				end,
				func = function(dialog)
					dialog.show({
						text = "\\*blub\\* You owe me " .. loan_shark_debt .. " gold. \\*blub blub\\*",
						options = {
							{
								text = "Pay debt",
								enabled = function(stats)
									return loan_shark_debt > 0
								end,
								func = function(dialog)
									-- take all of the players gold and subtract it from debt, make sure we don't go negative
									local wallet_component = EntityGetFirstComponentIncludingDisabled(
										entity_who_interacted,
										"WalletComponent"
									)
									local gold = ComponentGetValue2(wallet_component, "money")
									local debt = loan_shark_debt
									debt = debt - gold

									local leftover = 0
									if debt < 0 then
										leftover = math.abs(debt)

										debt = 0
									end

									GlobalsSetValue("loan_shark_debt", tostring(debt))
									ComponentSetValue2(wallet_component, "money", leftover)

									dialog.show({
										text = "Thank you for your payment. \\*blub\\*",
										options = {
											{
												text = "Leave",
											},
										},
									})
								end,
							},
							{
								text = "Leave",
							},
						},
					})
				end,
			},
			{
				text = "Trick or treat!",
				show = function()
					return GameHasFlagRun("fairmod_halloween_mask")
				end,
				func = function(dialog)
					if GameHasFlagRun("fairmod_trickortreat_rewarded_loanshark") then
						dialog.show({
							text = "You've gotten your treat kid, now scram! \\*blub\\*",
							options = {
								{
									text = "Leave",
								},
							},
						})
					else
						dialog.show({
							text = "Nice mask kid.. \\*blub\\*",
							options = {
								{
									text = "Take treat",
									func = function(dialog)
										SetRandomSeed(GameGetFrameNum() + y, y * x)
										if Random(1, 4) == 1 then
											local pos_x, pos_y = EntityGetTransform(entity_who_interacted)
											CreateItemActionEntity(GetRandomAction(GameGetFrameNum(), y, 10, 1), x, y)
											GameAddFlagRun("fairmod_trickortreat_rewarded_loanshark")
										else
											EntityLoad("data/entities/projectiles/bomb.xml", x, y)
										end
										dialog.close()
									end,
								},
							},
						})
					end
				end,
			},
			{
				text = "Leave",
			},
		},
	})
end
