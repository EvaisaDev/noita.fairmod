local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35
dialog_system.dialog_box_height = 100
dialog_system.sounds.pop = { bank = "mods/noita.fairmod/fairmod.bank", event = "loanshark/pop" }
-- "mods/noita.fairmod/fairmod.bank", "immersivepiss/timetotakeapiss"
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

SetRandomSeed(x + GameGetFrameNum(), y)

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	-- If viewing a scratch ticket, don't interact at the same time
	if EntityHasTag(entity_interacted, "viewing") or GameHasFlagRun("fairmod_scratch_interacting") then return end

	local loan_shark_debt = tonumber(GlobalsGetValue("loan_shark_debt", "0"))

	GameAddFlagRun("fairmod_dialog_interacting")

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
				text = "I'd like to buy a scratch-off (50 gold)",
				enabled = function(stats)
					return stats.gold >= 50
				end,
				func = function(dialog)
					dialog.show({
						text = "Hmm, ofcourse! \nYour chances of winning are very high! \\*blub\\*\nYou can redeem your winnings here as well.",
						options = {
							{
								text = "Leave",
							},
						},
					})



					local ticket = EntityLoad("mods/noita.fairmod/files/content/gamblecore/scratch_ticket/scratch_ticket.xml", x, y)
					
					local item_count = 0
					for i, child in ipairs(EntityGetAllChildren(player) or {}) do
						if EntityGetName(child) == "inventory_quick" then
							for i, v in ipairs(EntityGetAllChildren(child) or {}) do
								local ability_component =
									EntityGetFirstComponentIncludingDisabled(v, "AbilityComponent")
								if ability_component then
									local use_gun_script = ComponentGetValue2(ability_component, "use_gun_script")
									if not use_gun_script then item_count = item_count + 1 end
								end
							end
						end
					end

					if item_count < 4 then
						GamePickUpInventoryItem(entity_who_interacted, ticket, true)
					end

					local wallet_component =
						EntityGetFirstComponentIncludingDisabled(entity_who_interacted, "WalletComponent")
					ComponentSetValue2(wallet_component, "money", ComponentGetValue2(wallet_component, "money") - 50)
				end,
			},
			{
				text = "I want to redeem my scratch-off(s)",
				show = function(stats)
					local inventory_items = GameGetAllInventoryItems(entity_who_interacted) or {}
					for _, item in ipairs(inventory_items) do
						if EntityHasTag(item, "scratch_ticket") then return true end
					end
					return false
				end,
				func = function(dialog)
					dialog.show({
						text = "Alright, here are your winnings. \\*blub\\*",
						options = {
							{
								text = "Leave",
							},
						},
					})

					local inventory_items = GameGetAllInventoryItems(entity_who_interacted) or {}

					for _, item in ipairs(inventory_items) do
						if EntityHasTag(item, "scratch_ticket") then EntityRemoveTag(item, "scratch_ticket") end
					end
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
											GameAddFlagRun("fairmod_trickortreated")
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
		on_closed = function()
			GameRemoveFlagRun("fairmod_dialog_interacting")
		end,
	})
end
