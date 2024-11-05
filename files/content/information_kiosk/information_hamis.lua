local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35
dialog_system.dialog_box_height = 80
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

SetRandomSeed(x + GameGetFrameNum(), y)

local useed = ModSettingGet("user_seed")
local uid = ModSettingGet("user_id")

local tips = {
	"Jingle Bells, Hämis Sells,\nLots and lots of tips!\nMina buys, and then survives\nAll fairmod bullshit!",
}

if uid then table.insert(tips, "Higher beings, these words are for you alone.") end

local seasonal = {
	halloween = {
		"Happy Halloween!",
		"Trick or Treat!",
		"Nice makeup, you really look like a Hiisi!",
		"I'm dressing up as myself this year!",
	},
	winter = {
		"Brrr, it's getting cold out!",
		"All my competitors are stocking up to hibernate for winter\nNot me! I'm on the grind!",
		"Merry Christmas",
		"Happy Christmas",
		"For Christmas, I'm going to wish for your happiness!",
		"I hope we get snow!",
		"Jingle Bells, Hämis Sells,\nLots and lots of tips!\nMina buys, and then survives\nAll fairmod bull... heck!",
	}
}

local streamer_tips = {
	general = {
		"Are you sure you're still recording?",
		"Woooo its us, chat, we're in your gaaaaammee",
		"Chat is this a W?",
		"We can tell when OBS is open, like right now!",
		"Don't forget streamer mode!",
		"Streaming tip: Don't Die",
		"Streaming tip: Die",
		"This stream is pretty P.O.G-CHAMP!!!",
		"Higher beings"
	}
}

table.insert(tips, "there are " .. #tips + 1 .. " tips\ncan you read them all?")

-- Global so it's preserved across conversations
-- Used to avoid showing the same tip twice until you've seen all tips
remaining_tips = remaining_tips or {}

local function has_scratch_ticket(player)
	local inventory_items = GameGetAllInventoryItems(player) or {}
	for _, item in ipairs(inventory_items) do
		if EntityHasTag(item, "scratch_ticket") then return true end
	end
	return false
end

function interacting(player, entity_interacted, interactable_name)
	-- If viewing a scratch ticket, don't interact at the same time
	if EntityHasTag(entity_interacted, "viewing") or GameHasFlagRun("fairmod_scratch_interacting") then return end
	if GameHasFlagRun("fairmod_interacted_with_anything_this_frame") then return end
	GameAddFlagRun("fairmod_interacted_with_anything_this_frame")
	GameAddFlagRun("fairmod_dialog_interacting")

	dialog = dialog_system.open_dialog({
		name = "Information Hämis",
		portrait = "mods/noita.fairmod/files/content/information_kiosk/portrait.png",
		typing_sound = "default", -- There are currently 6: default, sans, one, two, three, four and "none" to turn it off, if not specified uses "default"
		text = "Heyyyy!! Welcome to this wonderful place!\nWhat can I do for you today?",
		options = {
			{
				text = "Ask for some tips",
				enabled = function(stats)
					return true
				end,
				func = function(dialog)
					if #remaining_tips == 0 then
						for _, tip in ipairs(tips) do
							remaining_tips[#remaining_tips + 1] = tip
						end
					end
					dialog.show({
						text = table.remove(remaining_tips, Random(1, #remaining_tips)),
						options = {
							{
								text = "Leave",
							},
						},
					})
				end,
			},
			{

				text = "Could I get an information booklet?",
				enabled = function(stats)
					return true
				end,
				func = function(dialog)
					local item_count = 0
					for i, child in ipairs(EntityGetAllChildren(player) or {}) do
						if EntityGetName(child) == "inventory_quick" then
							for i, v in ipairs(EntityGetAllChildren(child) or {}) do
								local ability_component = EntityGetFirstComponentIncludingDisabled(v, "AbilityComponent")
								if ability_component then
									local use_gun_script = ComponentGetValue2(ability_component, "use_gun_script")
									if not use_gun_script then item_count = item_count + 1 end
								end
							end
						end
					end

					if item_count < 4 then
						dialog.show({
							text = "Ofcourse!! Here you go.\nHave a great day!!",
							options = {
								{
									text = "Leave",
								},
							},
						})
						local items = EntityLoad("mods/noita.fairmod/files/content/instruction_booklet/booklet_entity/booklet.xml", x, y)
						GamePickUpInventoryItem(player, items, false)
					else
						dialog.show({
							text = "Your bag looks really full!\nPerhaps you should make some room first?",
							options = {
								{
									text = "Leave",
								},
							},
						})
					end
				end,
			},
			{
				text = "I'd like to buy a scratch-off (50 gold)",
				enabled = function(stats)
					return stats.gold >= 50
				end,
				func = function(dialog)
					dialog.show({
						text = "Oh, you want to try your luck? Here you go!!\nYou can redeem your winnings here or at the loanprey!",
						options = {
							{
								text = "Leave",
							},
						},
					})

					local item_count = 0
					for i, child in ipairs(EntityGetAllChildren(player) or {}) do
						if EntityGetName(child) == "inventory_quick" then
							for i, v in ipairs(EntityGetAllChildren(child) or {}) do
								local ability_component = EntityGetFirstComponentIncludingDisabled(v, "AbilityComponent")
								if ability_component then
									local use_gun_script = ComponentGetValue2(ability_component, "use_gun_script")
									if not use_gun_script then item_count = item_count + 1 end
								end
							end
						end
					end

					local ticket = EntityLoad("mods/noita.fairmod/files/content/gamblecore/scratch_ticket/scratch_ticket.xml", x, y)

					if item_count < 4 then GamePickUpInventoryItem(player, ticket, true) end

					local wallet_component = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
					ComponentSetValue2(wallet_component, "money", ComponentGetValue2(wallet_component, "money") - 50)
				end,
			},
			{
				text = "I want to redeem my scratch-off(s)",
				show = function(stats)
					return has_scratch_ticket(player)
				end,
				func = function(dialog)
					dialog.show({
						text = "Oh man!! I hope you won big!\nHere's your winnings!",
						options = {
							{
								text = "Leave",
							},
						},
					})

					local inventory_items = GameGetAllInventoryItems(player) or {}

					for _, item in ipairs(inventory_items) do
						if EntityHasTag(item, "scratch_ticket") then EntityRemoveTag(item, "scratch_ticket") end
					end
				end,
			},
			{
				text = "Trick or treat!",
				show = function()
					-- Don't show if you have a scratch ticket or there will be too many options
					return GameHasFlagRun("fairmod_halloween_mask") and not has_scratch_ticket(player)
				end,
				func = function(dialog)
					if GameHasFlagRun("fairmod_trickortreat_rewarded_kiosk") then
						dialog.show({
							text = "Sorry, you only get one!",
							options = {
								{
									text = "Leave",
								},
							},
						})
					else
						dialog.show({
							text = "Wow! You're all dressed up! :)",
							options = {
								{
									text = "Take treat",
									func = function(dialog)
										local candies = {
											"candy_fairmod_hamis", "candy_fairmod_ambrosia", "candy_fairmod_toxic"
										}
										local candy_num = ProceduralRandomi(x + entity_id, y + GameGetFrameNum(), 1, 3)

										GameCreateParticle(candies[candy_num], x, y, 100, 0, 0, false)

										GameAddFlagRun("fairmod_trickortreated")
										GameAddFlagRun("fairmod_trickortreat_rewarded_kiosk")
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
