local entity_id = GetUpdatedEntityID()

local debug_free = false

local x, y = EntityGetTransform( entity_id )

local sprite_component = EntityGetFirstComponent( entity_id, "SpriteComponent", "slotmachine_sprite" )

local cost_sprite = EntityGetFirstComponent( entity_id, "SpriteComponent", "cost" )

current_cost = current_cost or 100

if(debug_free)then
	current_cost = 0
end

currently_gambling = currently_gambling or false
lets_go_gambling = lets_go_gambling or false

if(cost_sprite)then
	local cost = tonumber(ComponentGetValue2(cost_sprite, "text"))
	if(cost)then
		if(current_cost ~= cost)then
			ComponentSetValue2(cost_sprite, "text", tostring(current_cost))

			local text = tostring(current_cost)
			local textwidth = 0
			
			for i=1,#text do
				local l = string.sub( text, i, i )
				
				if ( l ~= "1" ) then
					textwidth = textwidth + 6
				else
					textwidth = textwidth + 3
				end
			end
			
		
		
			local offsetx = textwidth * 0.5 - 0.5

			ComponentSetValue2(cost_sprite, "offset_x", offsetx)

		end
	end
end



SetRandomSeed( GameGetFrameNum(), entity_id )

-- get player entity
local player = EntityGetClosestWithTag( x, y, "player_unit" )

if(currently_gambling)then
	EntitySetComponentsWithTagEnabled( entity_id, "is_not_gambling", false )
else
	EntitySetComponentsWithTagEnabled( entity_id, "is_not_gambling", true )
end

-- check if player is further than 50 units away
if(player ~= nil and player ~= 0 and not EntityGetIsAlive(player))then
	local px, py = EntityGetTransform( player )
	local length = math.sqrt((px - x) ^ 2 + (py - y) ^ 2)

	if(length > 50)then
		lets_go_gambling = false
	end
end


if(player ~= nil)then
	-- get WalletComponent
	local wallet = EntityGetFirstComponent( player, "WalletComponent" )
	if(wallet)then
		-- get player's money
		local money = ComponentGetValue2(wallet, "money")

		if(money < current_cost)then
			EntitySetComponentsWithTagEnabled( entity_id, "enough_money", false )
			if(not currently_gambling)then
				EntitySetComponentsWithTagEnabled( entity_id, "not_enough_money", true )
			end
		else
			if(not currently_gambling)then
				EntitySetComponentsWithTagEnabled( entity_id, "enough_money", true )
			end
			EntitySetComponentsWithTagEnabled( entity_id, "not_enough_money", false )
		end
	
	end
end

local gamble_states = {
	{
		animation = "idle",
		time = 0
	},
	{
		time = 15,
		animation = "pull",
	},
	{
		time = 20,
		animation = "roll",
		play_win_sound = true
	},
	{
		time = 60,
		is_win_condition = true
	},
	{
		animation = "idle",
		time = 10
	},
}

state = state or 4
time = time or 0
will_win = will_win or false

if(currently_gambling)then
	time = time + 1
	if(time >= gamble_states[state].time)then

		state = state + 1
		time = 0
		if(state > #gamble_states)then
			currently_gambling = false
			return
		end

		if(gamble_states[state].is_win_condition)then
			current_cost = current_cost * 2
			if(will_win)then
				GamePrint("You won!")
				GameAddFlagRun("has_won")
				GamePlayAnimation( entity_id, "win", 1 )
				ComponentSetValue2(sprite_component, "rect_animation", "win")
				EntityRefreshSprite( entity_id, sprite_component )
				-- drop gold

				local total = math.floor(current_cost * 2 / 5)
				for i = 1, 5 do
					local nugget = EntityLoad("data/entities/items/pickup/goldnugget.xml", x, y)
					local storage_comps = EntityGetComponent(nugget, "VariableStorageComponent") or {}
					for k, v in pairs(storage_comps)do
						if(ComponentGetValue2(v, "name") == "gold_value")then
							ComponentSetValue2(v, "value_int", total) 
						end
					end
				end

			else
				GamePrint("You lost!")
				GamePlayAnimation( entity_id, "lose", 1 )
				ComponentSetValue2(sprite_component, "rect_animation", "lose")
				EntityRefreshSprite( entity_id, sprite_component )
			end
		else
			GamePlayAnimation( entity_id, gamble_states[state].animation, 1 )
			ComponentSetValue2(sprite_component, "rect_animation", gamble_states[state].animation)
			EntityRefreshSprite( entity_id, sprite_component )

			if(gamble_states[state].play_win_sound)then
				if(will_win)then
					GamePlaySound("mods/noita.fairmod/fairmod.bank", "gamblecore/icantstopwinning", 0, 0)
				else
					GamePlaySound("mods/noita.fairmod/fairmod.bank", "gamblecore/awdangit", 0, 0)
				end
			end
		end


	end
	
end

-- LETS GO GAMBLING
function interacting( entity_who_interacted, entity_interacted, interactable_name )

	if(interactable_name == "interact")then
		local wallet = EntityGetFirstComponent( entity_who_interacted, "WalletComponent" )

		if(wallet)then
			local money = ComponentGetValue2(wallet, "money")
			if(money < current_cost)then
				GamePrint("You don't have enough money!")
				return
			else
				currently_gambling = true
				state = 1
				GamePlayAnimation( entity_interacted, gamble_states[state].animation, 1 )
				ComponentSetValue2(sprite_component, "rect_animation", gamble_states[state].animation)
				EntityRefreshSprite( entity_id, sprite_component )

				will_win = (not GameHasFlagRun("has_won") and Random(1, 100) < 10)

				time = 0
				if(not lets_go_gambling)then
					GamePlaySound("mods/noita.fairmod/fairmod.bank", "gamblecore/letsgogambling", 0, 0)
					time = -30
					lets_go_gambling = true
				end
				ComponentSetValue2(wallet, "money", money - current_cost)
			end
		end



		-- remove money
		
	end
end
