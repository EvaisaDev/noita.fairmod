local entity_id = GetUpdatedEntityID()

local debug_free = false

local x, y = EntityGetTransform(entity_id)

local sprite_component = EntityGetFirstComponent(entity_id, "SpriteComponent", "slotmachine_sprite")

local cost_sprite = EntityGetFirstComponent(entity_id, "SpriteComponent", "cost")

gamba_gui = gamba_gui or GuiCreate()

GuiStartFrame(gamba_gui)
-- biome based cost

SetRandomSeed(x + GameGetFrameNum(), y)

local biomes = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 1,
	[5] = 1,
	[6] = 1,
	[7] = 2,
	[8] = 2,
	[9] = 2,
	[10] = 2,
	[11] = 2,
	[12] = 2,
	[13] = 3,
	[14] = 3,
	[15] = 3,
	[16] = 3,
	[17] = 4,
	[18] = 4,
	[19] = 4,
	[20] = 4,
	[21] = 5,
	[22] = 5,
	[23] = 5,
	[24] = 5,
	[25] = 6,
	[26] = 6,
	[27] = 6,
	[28] = 6,
	[29] = 6,
	[30] = 6,
	[31] = 6,
	[32] = 6,
	[33] = 6,
}

local biomepixel = math.floor(y / 512)
local biomeid = biomes[biomepixel] or 0

if biomeid < 1 then biomeid = 1 end
if biomeid > 6 then biomeid = 6 end

biomeid = (0.5 * biomeid) + (0.5 * biomeid * biomeid)
local biomecost = (biomeid * 100)

--------------------

current_cost = current_cost or biomecost
current_winnings = current_winnings or 200
win_chance = tonumber(GlobalsGetValue("GAMBLECORE_WIN_CHANCE", "10"))

broken_timer = broken_timer or 0

if debug_free then current_cost = 0 end

currently_gambling = currently_gambling or false
lets_go_gambling = lets_go_gambling or false

if cost_sprite then
	local cost_text = ComponentGetValue2(cost_sprite, "text")
	local cost_pruned = string.sub(cost_text, 2)
	local cost = tonumber(cost_pruned)
	if cost then
		if current_cost ~= cost then
			local cost_text = "$" .. tostring(current_cost)
			ComponentSetValue2(cost_sprite, "text", cost_text)

			-- deranged bullshit because noita treats $ as a translation token always
			local w, h = GuiGetTextDimensions(gamba_gui, string.gsub(cost_text, "%$", "7"))

			ComponentSetValue2(cost_sprite, "offset_x", w / 2)
		end
	end
end

SetRandomSeed(GameGetFrameNum(), entity_id)

-- get player entity
local player = EntityGetClosestWithTag(x, y, "player_unit")

if currently_gambling then
	EntitySetComponentsWithTagEnabled(entity_id, "is_not_gambling", false)
else
	EntitySetComponentsWithTagEnabled(entity_id, "is_not_gambling", true)
end

-- check if player is further than 50 units away
if player ~= nil and player ~= 0 and not EntityGetIsAlive(player) then
	local px, py = EntityGetTransform(player)
	local length = math.sqrt((px - x) ^ 2 + (py - y) ^ 2)

	if length > 50 then lets_go_gambling = false end
end

if player ~= nil then
	-- get WalletComponent
	local wallet = EntityGetFirstComponent(player, "WalletComponent")
	if wallet then
		-- get player's money
		local money = ComponentGetValue2(wallet, "money")

		if money < current_cost then
			EntitySetComponentsWithTagEnabled(entity_id, "enough_money", false)
			if not currently_gambling then EntitySetComponentsWithTagEnabled(entity_id, "not_enough_money", true) end
		else
			if not currently_gambling then EntitySetComponentsWithTagEnabled(entity_id, "enough_money", true) end
			EntitySetComponentsWithTagEnabled(entity_id, "not_enough_money", false)
		end
	end
end

local gamble_states = {
	{
		animation = "idle",
		time = 0,
	},
	{
		time = 15,
		animation = "pull",
	},
	{
		time = 20,
		animation = "roll",
		play_win_sound = true,
	},
	{
		time = 60,
		is_win_condition = true,
	},
	{
		animation = "idle",
		time = 10,
	},
}

state = state or 4
time = time or 0
will_win = will_win or false
will_break = will_break or false

if currently_gambling then
	time = time + 1
	if time >= gamble_states[state].time then
		state = state + 1
		time = 0
		if state > #gamble_states then
			currently_gambling = false
			return
		end

		if gamble_states[state].is_win_condition then
			if will_break then return end

			if will_win then
				-- better_ui integration
				GlobalsSetValue("GAMBLECORE_TIMES_WON", tostring((tonumber(GlobalsGetValue("GAMBLECORE_TIMES_WON", "0")) or 0) + 1))
				GlobalsSetValue("GAMBLECORE_TIMES_LOST_IN_A_ROW", "0")

				GamePrint("You won!")
				GameAddFlagRun("has_won")
				GamePlayAnimation(entity_id, "win", 1)
				ComponentSetValue2(sprite_component, "rect_animation", "win")
				EntityRefreshSprite(entity_id, sprite_component)
				-- drop gold

				win_chance = math.max(math.max(win_chance - 1, win_chance * 0.5), 0.01)

				GlobalsSetValue("GAMBLECORE_WIN_CHANCE", tostring(win_chance))

				for i = 1, 5 do
					local nugget = EntityLoad("data/entities/items/pickup/goldnugget.xml", x, y)
					local storage_comps = EntityGetComponent(nugget, "VariableStorageComponent") or {}
					for k, v in pairs(storage_comps) do
						if ComponentGetValue2(v, "name") == "gold_value" then
							ComponentSetValue2(v, "value_int", math.max(math.floor(current_winnings / 5), 1))
						end
					end
				end

				current_winnings = 200
			else
				-- better_ui integration
				GlobalsSetValue(
					"GAMBLECORE_TIMES_LOST_IN_A_ROW",
					tostring((tonumber(GlobalsGetValue("GAMBLECORE_TIMES_LOST_IN_A_ROW", "0")) or 0) + 1)
				)

				GamePrint("You lost! Current jackpot: $" .. tostring(current_winnings))
				GamePlayAnimation(entity_id, "lose", 1)
				ComponentSetValue2(sprite_component, "rect_animation", "lose")
				EntityRefreshSprite(entity_id, sprite_component)
			end
		else
			if GetValueBool("broken", false) then return end
			GamePlayAnimation(entity_id, gamble_states[state].animation, 1)
			ComponentSetValue2(sprite_component, "rect_animation", gamble_states[state].animation)
			EntityRefreshSprite(entity_id, sprite_component)

			if gamble_states[state].play_win_sound then
				if will_break then
					--broken = true
					SetValueBool("broken", true)

					local explosion = EntityLoad("mods/noita.fairmod/files/content/gamblecore/explosion.xml", x, y - 12)

					EntityRemoveComponent(entity_id, cost_sprite)
					EntityAddChild(entity_id, explosion)
					GamePlaySound("mods/noita.fairmod/fairmod.bank", "gamblecore/break", 0, 0)
					return
				end
				if will_win then
					GamePlaySound("mods/noita.fairmod/fairmod.bank", "gamblecore/icantstopwinning", 0, 0)
				else
					GamePlaySound("mods/noita.fairmod/fairmod.bank", "gamblecore/awdangit", 0, 0)
				end
			end
		end
	end
end

if GetValueBool("broken", false) then
	broken_timer = broken_timer + 1
	if broken_timer == 35 then
		GamePlayAnimation(entity_id, "broken", 1)
		ComponentSetValue2(sprite_component, "rect_animation", "broken")
		EntityRefreshSprite(entity_id, sprite_component)
	end
end

-- LETS GO GAMBLING
function interacting(entity_who_interacted, entity_interacted, interactable_name)
	SetRandomSeed(x + GameGetFrameNum(), y)
	local broken = GetValueBool("broken", false)
	if(broken)then
		GamePrint("The slot machine is broken!")
	end
	if interactable_name == "interact" and not broken and not currently_gambling then
		-- better_ui integration
		GameAddFlagRun("gamblecore_found")

		local wallet = EntityGetFirstComponent(entity_who_interacted, "WalletComponent")

		if wallet then
			local money = ComponentGetValue2(wallet, "money")
			if money < current_cost then
				GamePrint("You don't have enough money!")
				return
			else
				if Random(1, 100) <= 2 then
					will_break = true
					local interactible_component = EntityGetFirstComponent(entity_interacted, "InteractableComponent")
					EntityRemoveComponent(entity_interacted, interactible_component)
				end

				currently_gambling = true
				state = 1
				GamePlayAnimation(entity_interacted, gamble_states[state].animation, 1)
				ComponentSetValue2(sprite_component, "rect_animation", gamble_states[state].animation)
				EntityRefreshSprite(entity_id, sprite_component)

				will_win = Random(1, 1000000) / 10000 < win_chance

				time = 0
				if not lets_go_gambling then
					GamePlaySound("mods/noita.fairmod/fairmod.bank", "gamblecore/letsgogambling", 0, 0)
					time = -30
					lets_go_gambling = true
				end
				current_cost = math.floor(current_cost * 1.5)
				ComponentSetValue2(wallet, "money", money - current_cost)
				current_winnings = current_winnings + (current_cost * 2)
			end
		end
	end
end
