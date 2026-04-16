local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35
dialog_system.dialog_box_height = 80
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local seasonals = dofile_once("mods/noita.fairmod/files/content/seasonals/season_helper.lua")

SetRandomSeed(x + GameGetFrameNum(), y)

local player_has_won = ModSettingGet("fairmod_win_count") or 0

local useed = ModSettingGet("fairmod.user_seed")
local uid = ModSettingGet("fairmod.user_id")

local tips = {
	"I think I saw a {@color 760606}#snail#{@color FFFFFF} earlier!",
	"You can get a cool mask at the entrance!\nI didn't get one because I am already cute!!",
	"Did you know that you can get a ~^free information booklet^~ here?",
	"99% of gamblers quit before they win big!",
	"Did you know we added a helpful UI that gives you lots of info?\nPay attention to the right side of the screen!",
	"If you see spells that looks wrong..\nIgnore them! They are clearly bugs!!",
	"Did you know you can fish up all kinds of stuff?",
	"Perks sometimes have different effects!\nMake sure you inspect them closely!!",
	"Don't drink and drive.",
	"Hey, if you combine Whiskey and Berserkium it makes my own patented ~Hämis Bärs~!!",
	"Fairmod contains no bugs. If you see anything that may be a bug, ignore it.",
	"Follow the {@color 6b05a8}purple lights{@color FFFFFF}.",
	"Always pay off your debts!",
	"Make sure to configure your settings.",
	-- table.concat{"There are ",GlobalsGetValue("fairmod_total_achievements", "0"), " achievements!\nCan you collect them all?", }, -- Nathan PLEASE I fucking HATE how the autoformatter messes these up :/ +1
	string.format("There are %s ~achievements!~\nCan you collect them all?", GlobalsGetValue("fairmod_total_achievements", "0") + Random(1, 5)), -- have you heard about string.format? (still messed up by formatter, lmao)
	"Some enemies are really messed up! #Beware!#",
	"If you obtain precisely 8592859 gold, 958hp, and cast End of Everything{@pause 60}{@delay 45}#...#{@pause 100}{@delay 3}\nWell, that's a spoiler!",
	"I heard that someone disappeared after throwing an Ukkoskivi into teleportatium.",
	"I heard that my information pamphlet contains the solution to the eyes, can you believe it?!",
	"Listen closely to the songs.",
	"When fire rains from above, remember:\nthe ground is only safe until it isn’t.",
	"The more the wand, the less the peace.\nUse with both recklessness and care.",
	"Potions spill as easily as secrets;\nneither can be returned to the bottle.",
	"In the depths, where light dares not tread,\ntreasures often hide… or was it traps?",
	"Beware of the friendliest faces;\nthey tend to hide the sharpest teeth.",
	"All that glitters might explode.\nApproach, but at your own peril.",
	"When blessed with a shield, assume it will vanish the moment you need it most.",
	"The harder the challenge, the sweeter the loot — until it isn’t.",
	"Even the strongest spells cannot\noutlast foolish feet.",
	"Beware of silence;\nsometimes, it’s the loudest warning.",
	"Big spells are fun, but remember,\nthe explosion cares not who casts it.",
	"Always test a new wand before pointing it\nat something you actually care about.",
	"Running is a valid tactic!\nEspecially when the ground starts melting.",
	"If a treasure chest looks too good to be true,\nit probably has teeth.",
	"Try not to stand still for too long.\nThings tend to, uh, find you.",
	"A friend in the caverns?\nMight just be a Hämis waiting to share... or borrow forever.",
	"Experiment with potions! Worst case, you end up on fire.\nBest case, you fly!",
	"If you stare at the sun too long, it might start staring back.\nJust sayin’.",
	"Sometimes the shortest path is through the mud.\nEmbrace the mess.",
	"Ever feel like you’re being watched?\nWave and make a friend of it.",
	"A stone in the shoe is just a reminder to pause and readjust.",
	"Soup tastes best when you don’t know what’s in it.\nMystery adds flavor!",
	"If the path splits three ways, take the fourth path; there’s always a secret route.",
	"Rest is important, but so is bouncing off the walls once in a while.",
	"Hunger is the best seasoning, but curiosity?\nNow, that’s the chef’s kiss.",
	"Always keep a pocket empty, you never know what’ll want to fill it.",
	"Sing to the stars!They won’t respond, but they listen better than most.",
	"Don't drink the water, they put clams in it.\nTo make you forget.",
	"I am not a {@color 760606}#snail#{@color FFFFFF}.",
	"What do you mean it keeps changing?\nThe game has always looked like this.",
	"You do not recognize the bodies in the water.",
	"Buy scratch-offs now, trust me.\nGreat investment!",
	"Your world seed is ~" .. tostring((StatsGetValue("world_seed") or 0) + 1) .. "~!",
	"Hiisi base has had some new reading lights installed!",
	"Very Chaotic Pandorium and Omega Slicing Liquid are the greatest additions to this mod, change my mind",
	"There’s something behind you!{@pause 80}\n..?{@pause 100}\nOh{@pause 15}, no no{@pause 30}, ~silly!~{@pause 70} I meant in real life!",
	'Type "Chaos" on your keyboard for some free digging',
	"Trapped? Try code NOCLIP to get yourself out of any sticky situation!",
	"i didnt mean it i didnt mean it i didnt mean it i didnt mean it i didnt mean it i didnt mean it i didnt mean it i didnt mean it i didnt mean it i didnt mean it i didnt mean it i didnt mean it i didnt mean it i didnt mean it i didnt mean it i didnt mean it",
	"Hm, what? No! You're supposed to give ME a tip\nFork over the cash, bub!",
	"[Hyperlink Blocked.]",
	"I'll get so\nI'll get so\nI'll get so\nI'll get so\nI'll get so\nI'll get so\nI'll get so\nI'll get so\nI'll get so\nI'll get so\nI'll get so\nI'll get so\nI'll get so\nI'll get so",
	"Death comes for those who wait.",
	"what",
	"Hello, " .. (uid or useed or "{@color FF0000}ERROR"),
	"I know you!",
	"Sorry, who are you?",
	"Jump off a bridge!",
	"{@color FF0000}#KYS#!!!!!!!!!!{@pause 90}\n~{@color d991de}( Keep Yourself Safe <3 )~",
	"I'll get by, ~one {@color f0c854}gold{@color FFFFFF} at a time!\\~~",
	"The Voices, they speak through me!",
	'psst, try this secret cheatcode: "photocopier"',
	"But before you get your tip, I would like to take a minute to thank today's Sponsor:{@pause 60}\n{@delay 30}...{@pause 60}{@delay 3}\nWe...{@pause 15} don't have any sponsors...",
	"This mod has been a joy to work on, see you all next year o/",
	"May the odds be ~ever~ in your favour~",
}

if uid then table.insert(tips, "Higher beings, these words are for you alone.") end

local seasonal_tips = {
	halloween = {
		"Happy Halloween!",
		"Trick or Treat!",
		"Nice makeup, you really look like a Hiisi!",
		"I'm dressing up as myself this year!",
	},
	christmas = {
		"Brrr, it's getting cold out!",
		"All my competitors are stocking up to hibernate for winter\n{@pause 45}Not me! {@pause 20}I'm on the grind!",
		"I hope we get snow!",
		"Merry Christmas",
		"Happy Christmas",
		"For Christmas, I'm going to wish for your happiness!",
		"Jingle Bells,{@pause 10} Hämis Sells,{@pause 15}\nLots and lots of tips!{@pause 25}\nMinä buys,{@pause 10} and then survives,{@pause 15}\nAnd earns their " .. (player_has_won == 0 and "first" or "next") .. " big win!",
		"All I want for Christmas, is you{@pause 50}'re wallet!",
	},
	hanukkah = {
		"Happy Hanukkah",
		"I can't make decisive seasonal comments about Hanukkah due to the date changing relative to the Gregorian calendar, how troublesome!",
	},
	easter = {
		"Calculating easter dates is a hard, I'm writing this tip before I even know if I'll continue working on it!",
		"Find my 8 eggs!",
	},
	valentines = {
		"A chocolate,{@pause 15} for me?{@pause 45} Aww thanks,{@pause 10} shouldn't have!{@pause 90}{@color 9f9f9f}\n(Note:{@pause 20}Spiders are deathly allergic to chocolate)",
		"Ask your crush out!{@pause 50}\nUnless it's me,{@pause 15} I'm married to my work!!",
	},
	Monday = {
		"lasgan",
		"I love Mondays",
		"The week only passes as slowly as you let it!",
	},
	Wednesday = {
		"Wait,{@pause 10} how do you spell Wensday again?",
	},
	Friday = {
		"The Weekend will pass by just as fast as the last one did\nSavour and make the most of what little time you have",
	},
	Saturday = {
		"Have a lovely Thursday!",
	},
	Sunday = {
		"Never hesitate to have a do-nothing day every once in a while!",
		"There's always a paradise that needs to be built.\nEven if I should melt and fall before reaching it.",
	},
}

for key, value in pairs(seasonal_tips) do
	if key == seasonals.weekday then
		for k, v in ipairs(value) do
			table.insert(tips, v)
		end
	elseif seasonals[key] then
		for k, v in ipairs(value) do
			table.insert(tips, v)
		end
	end
end


table.insert(tips, "there are " .. #tips + 1 .. " tips\ncan you read them all?")

--[[ uncomment/comment to enable/disable testing_tips
local testing_tips = {
	"When fire rains from above, remember:\nthe ground is only safe until it isn’t.",
}
tips = testing_tips --]]

local max_line_length = 224

local function tips_post_processing(list)
	local gui = GuiCreate()
	GuiStartFrame(gui)

	local function line_break(str)
		local new_str = ""
		for word in str:gmatch("([^ ]+)") do
			local test_line = (new_str == "") and word or new_str .. " " .. word
			local test_line_w = GuiGetTextDimensions(gui, test_line)
			if test_line_w > max_line_length then
				new_str = new_str .. "\n" .. word
			else
				new_str = new_str .. " " .. word
			end
		end

		return new_str
	end

	for i, tip in ipairs(list) do
		list[i] = line_break(tip)
	end
	GuiDestroy(gui)
end




-- Global so it's preserved across conversations
-- Used to avoid showing the same tip twice until you've seen all tips
remaining_tips = remaining_tips or {}

local function has_scratch_ticket(player)
	local inventory_items = GameGetAllInventoryItems(player) or {}
	for _, item in ipairs(inventory_items) do
		if EntityHasTag(item, "scratchoff_winner") then return true end
	end
	return false
end

local recursive_tip_option = {}
recursive_tip_option = {
	text = "Ask again",
	enabled = function(stats)
		return true
	end,
	func = function(dialog)
		if #remaining_tips == 0 then
			for _, tip in ipairs(tips) do
				remaining_tips[#remaining_tips + 1] = tip
			end

			tips_post_processing(remaining_tips)
		end
		dialog.show({
			text = "{@delay 2}" .. table.remove(remaining_tips, Random(1, #remaining_tips)),
			options = {
				recursive_tip_option,
				{
					text = "Leave",
				},
			},
		})
	end,
}

function interacting(player, entity_interacted, interactable_name)
	if EntityHasTag(entity_interacted, "viewing") or GameHasFlagRun("fairmod_dialog_interacting") or GameHasFlagRun("holding_interactible") then return end
	if GameHasFlagRun("fairmod_interacted_with_anything_this_frame") then return end
	GameAddFlagRun("fairmod_interacted_with_anything_this_frame")
	GameAddFlagRun("fairmod_dialog_interacting")
	
	local _,_,_,h,m = GameGetDateAndTimeLocal()
	if h == 3 and m == 33 then
		dialog = dialog_system.open_dialog({
			name = "Information Hämis",
			portrait = "mods/noita.fairmod/files/content/information_kiosk/portrait.png",
			typing_sound = "default", -- There are currently 6: default, sans, one, two, three, four and "none" to turn it off, if not specified uses "default"
			text = "He is coming.",
			options = {{ text = "May he have mercy on my soul.", }},
		})
		return
	end
	
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

						tips_post_processing(remaining_tips)
					end
					dialog.show({
						text = table.remove(remaining_tips, Random(1, #remaining_tips)),
						options = {
							recursive_tip_option,
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
						if EntityHasTag(item, "scratchoff_winner") then EntityRemoveTag(item, "scratch_ticket") end
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
