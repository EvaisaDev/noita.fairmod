local ring_chance = 1

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local sprite_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent")

-- Check if this is a Nokia phone
local entity_name = EntityGetName(entity_id)
local is_nokia = entity_name == "Nokia 3310"

payphone_state = payphone_state or {}
payphone_state[entity_id] = payphone_state[entity_id] or {
	dialog = nil,
	dialog_system = nil, 
	last_interactor = nil,
	ringing = false,
	ring_timer = 0,
	ring_end_time = 0,
	in_call = false,
	is_disconnected = false,
	do_random_teleport = false,
	payphone_x = 0, 
	payphone_y = 0,
	is_nokia = is_nokia,
}

local state = payphone_state[entity_id]

if not state.dialog_system then
	state.dialog_system = dofile("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
	state.dialog_system.distance_to_close = 35
	state.dialog_system.use_entity_pos_for_close_distance = true
	state.dialog_system.sounds = state.dialog_system.sounds or {}
	state.dialog_system.sounds.pop = { bank = "mods/noita.fairmod/fairmod.bank", event = "loanshark/pop" }
	state.dialog_system.sounds.breathing = { bank = "mods/noita.fairmod/fairmod.bank", event = "payphone/breathing" }
	state.dialog_system.sounds.gibberish = { bank = "mods/noita.fairmod/fairmod.bank", event = "payphone/gibberish" }
	state.dialog_system.sounds.garbled = { bank = "mods/noita.fairmod/fairmod.bank", event = "payphone/garbled" }
	state.dialog_system.functions = state.dialog_system.functions or {}
end

local dialog_system = state.dialog_system

local state = payphone_state[entity_id]

state.payphone_x = x
state.payphone_y = y

--dialog_system.sounds.steve = { bank = "mods/noita.fairmod/fairmod.bank", event = "minecraft/steve2" }
dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

SetRandomSeed(x, y + GameGetFrameNum())

function teleport_now()
	GameAddFlagRun("random_teleport_next")
	--GameAddFlagRun("no_return")

	local players = EntityGetWithTag("player_unit") or {}

	if players == nil or #players == 0 then return end

	local player = players[1]

	local x, y = EntityGetTransform(player)

	EntityLoad("mods/noita.fairmod/files/content/speedrun_door/portal_kolmi.xml", x, y)
end

local function hangup_internal(phone_entity_id)
	local state = payphone_state[phone_entity_id]
	if not state then return end
	
	local px, py = EntityGetTransform(phone_entity_id)
	local sound_event = state.is_nokia and "payphone/nokia_putdown" or "payphone/putdown"
	GamePlaySound("mods/noita.fairmod/fairmod.bank", sound_event, px, py)
	if state.dialog then
		state.dialog.close()
	end
	state.in_call = false
	state.is_disconnected = false
	if state.do_random_teleport then
		teleport_now()
		state.do_random_teleport = false
	end

	if(not HasFlagPersistent("fairmod_copimail_letter"))then
		AddFlagPersistent("fairmod_copimail_letter")
		ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "copi,")
	end
end

local function disconnected_internal(phone_entity_id)
	local state = payphone_state[phone_entity_id]
	if not state then return end
	state.is_disconnected = true
end

local function teleport_internal(phone_entity_id)
	local state = payphone_state[phone_entity_id]
	if not state then return end
	state.do_random_teleport = true
end

local function copibuddy()
	GameAddFlagRun("copibuddy")
end

local function ng_portal_internal(phone_entity_id)
	local px, py = EntityGetTransform(phone_entity_id)
	EntityLoad("mods/noita.fairmod/files/content/payphone/content/rift/return_portal.xml", px, py - 45)
end

local function stop_ringing(phone_entity_id)
	local state = payphone_state[phone_entity_id]
	if not state then return end
	
	state.ringing = false
	state.ring_timer = 0
	local sprite_comp = EntityGetFirstComponentIncludingDisabled(phone_entity_id, "SpriteComponent")
	if sprite_comp ~= nil then
		ComponentSetValue2(sprite_comp, "rect_animation", "idle")
	end
end

local function start_ringing(phone_entity_id)
	local state = payphone_state[phone_entity_id]
	if not state then return end
	
	state.ringing = true
	state.ring_end_time = 60 * 15
	local sprite_comp = EntityGetFirstComponentIncludingDisabled(phone_entity_id, "SpriteComponent")
	if sprite_comp ~= nil then
		ComponentSetValue2(sprite_comp, "rect_animation", "ringing")
	end
end

state.entity_id = entity_id

local function register_callbacks(phone_entity_id, target_dialog_system)
	local callbacks_key = "payphone_" .. tostring(phone_entity_id)
	local ds = target_dialog_system or dialog_system
	
	ds.functions[callbacks_key .. "_hangup"] = function()
		hangup_internal(phone_entity_id)
	end
	
	ds.functions[callbacks_key .. "_disconnected"] = function()
		disconnected_internal(phone_entity_id)
	end
	
	ds.functions[callbacks_key .. "_teleport"] = function()
		teleport_internal(phone_entity_id)
	end
	
	ds.functions[callbacks_key .. "_ng_portal"] = function()
		ng_portal_internal(phone_entity_id)
	end
	
	ds.functions[callbacks_key .. "_iamsteve"] = function()
		local px, py = EntityGetTransform(phone_entity_id)
		GamePlaySound("mods/noita.fairmod/fairmod.bank", "minecraft/iamsteve", px, py)
	end
	
	return callbacks_key
end

local callbacks_key = register_callbacks(entity_id)
state.callbacks_key = callbacks_key

local function get_active_payphone_id()
	for eid, pstate in pairs(payphone_state) do
		if pstate.dialog and pstate.in_call then
			return eid
		end
	end
	return nil
end

function hangup()
	local phone_id = get_active_payphone_id()
	if phone_id then hangup_internal(phone_id) end
end

function disconnected()
	local phone_id = get_active_payphone_id()
	if phone_id then disconnected_internal(phone_id) end
end

function teleport()
	local phone_id = get_active_payphone_id()
	if phone_id then teleport_internal(phone_id) end
end

function ng_portal()
	local phone_id = get_active_payphone_id()
	if phone_id then ng_portal_internal(phone_id) end
end

dialog_system.functions.hangup = hangup
dialog_system.functions.disconnected = disconnected
dialog_system.functions.teleport = teleport
dialog_system.functions.ng_portal = ng_portal

if not dialog_system.functions.iamsteve then
	dialog_system.functions.iamsteve = function()
		local phone_id = get_active_payphone_id()
		if phone_id then
			local px, py = EntityGetTransform(phone_id)
			GamePlaySound("mods/noita.fairmod/fairmod.bank", "minecraft/iamsteve", px, py)
		end
	end
end

dialog_system.functions.copibuddy = copibuddy

local call_options = dofile("mods/noita.fairmod/files/content/payphone/content/dialog.lua")

local audio_loop_disconnected = EntityGetFirstComponent(entity_id, "AudioLoopComponent", "disconnected")
if audio_loop_disconnected ~= nil then
	if state.is_disconnected then
		ComponentSetValue2(audio_loop_disconnected, "m_volume", 1)

		GameEntityPlaySoundLoop(entity_id, "disconnected", 1)
	else
		ComponentSetValue2(audio_loop_disconnected, "m_volume", 0)
	end
end

local audio_loop_ring = EntityGetFirstComponent(entity_id, "AudioLoopComponent", "ring")
if audio_loop_ring ~= nil then
	if state.ringing then
		ComponentSetValue2(audio_loop_ring, "m_volume", 1)

		GameEntityPlaySoundLoop(entity_id, "ring", 1)
	else
		ComponentSetValue2(audio_loop_ring, "m_volume", 0)
	end
end

local players = EntityGetInRadiusWithTag(x, y, 500, "player_unit")

if players == nil or #players == 0 then return end

-- random chance for the phone to ring if the player is nearby
if GameGetFrameNum() % 45 == 0 and not state.ringing and not state.in_call and Random(0, 100) <= ring_chance then
	start_ringing(entity_id)
end

if GameHasFlagRun("moshimoshi") and not state.ringing and not state.in_call then
	start_ringing(entity_id)
	GameRemoveFlagRun("moshimoshi")
end

if state.ringing then state.ring_timer = state.ring_timer + 1 end

if not state.in_call and state.ringing and state.ring_timer >= state.ring_end_time then
	stop_ringing(entity_id)
end

local get_random_call = function(entity_who_interacted)
	-- get random call where call.can_call() returns true
	-- first filter out calls that can't be called
	local can_call = {}
	for i, call in ipairs(call_options) do
		if call.can_call == nil or call.can_call() then table.insert(can_call, call) end
	end

	-- then get a random call
	local call = can_call[Random(1, #can_call)]

	-- egypt start
	if not GameHasFlagRun("evil_call_ended") then
		local invs = EntityGetAllChildren(entity_who_interacted) or {}; for i=1, #invs do
			if EntityGetName(invs[i]) == "inventory_quick" then
				local kids = EntityGetAllChildren(invs[i]) or {}; for j=1, #kids do
					if EntityHasTag(kids[j], "grow") and EntityHasTag(kids[j], "glue_NOT") then
						-- force the call if you're holding the incredibly shitty perk
						call = dofile("mods/noita.fairmod/files/content/payphone/content/copilogue.lua")
					end
				end
			end
		end
	end
	-- egypt end

	return call
end


if(state.in_call and state.last_interactor and dialog_system.is_any_dialog_open and GameHasFlagRun("is_copibuddied") and state.dialog and state.dialog.message.name ~= "Copi")then
	if(Random(1, 100) <= 2 and GameGetFrameNum() % 30 == 0)then

		GameAddFlagRun("copibuddy.call_rerouted")
		
		--state.dialog.close()
		local can_call = {}
		for i, call in ipairs(call_options) do
			if (call.can_call == nil or call.can_call()) and call.name == "Copi" then table.insert(can_call, call) end
		end
		GlobalsSetValue("DialogSystem_dialog_last_frame_open", "0")
		-- get random call
		local call = can_call[Random(1, #can_call)]
		local old_on_closed = call.on_closed
		call.on_closed = function()
			if old_on_closed ~= nil then old_on_closed() end
			GameRemoveFlagRun("fairmod_dialog_interacting")
			EntityRemoveTag(state.last_interactor, "viewing")
		end
		local phone_dialog_system = state.dialog_system
		phone_dialog_system.dialog_box_height = 70

		state.dialog = phone_dialog_system.open_dialog(call)
		if call.func ~= nil then call.func(state.dialog) end
	end
end

if(state.in_call and state.last_interactor and dialog_system.is_any_dialog_open and GameHasFlagRun("safecall_redirect") and state.dialog and state.dialog.message.name ~= "Copi")then
	--state.dialog.close()
	local can_call = {}
	for i, call in ipairs(call_options) do
		if (call.can_call == nil or call.can_call()) and call.name == "Copi" then table.insert(can_call, call) end
	end
	GlobalsSetValue("DialogSystem_dialog_last_frame_open", "0")
	-- get random call
	local call = can_call[Random(1, #can_call)]
	local old_on_closed = call.on_closed
	call.on_closed = function()
		if old_on_closed ~= nil then old_on_closed() end
		GameRemoveFlagRun("fairmod_dialog_interacting")
		EntityRemoveTag(state.last_interactor, "viewing")
	end
	local phone_dialog_system = state.dialog_system
	phone_dialog_system.dialog_box_height = 70

	state.dialog = phone_dialog_system.open_dialog(call)
	if call.func ~= nil then call.func(state.dialog) end
end
GameRemoveFlagRun("safecall_redirect")

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	local state = payphone_state[entity_interacted]
	if not state then return end
	
	state.last_interactor = entity_who_interacted
	
	state.callbacks_key = register_callbacks(entity_interacted, phone_dialog_system)

	local year, month, day, hour, minute, second = GameGetDateAndTimeLocal()
	local entity_x, entity_y = EntityGetTransform(entity_interacted)

	SetRandomSeed(entity_x, entity_y + GameGetFrameNum())
	if state.ringing then
		stop_ringing(entity_interacted)
		state.in_call = true
		local sound_event = state.is_nokia and "payphone/nokia_pickup" or "payphone/pickup"
		GamePlaySound("mods/noita.fairmod/fairmod.bank", sound_event, entity_x, entity_y)
		local phone_dialog_system = state.dialog_system
		
		local call = get_random_call(entity_who_interacted)
		local old_on_closed = call.on_closed
		call.on_closed = function()
			if old_on_closed ~= nil then old_on_closed() end
			GameRemoveFlagRun("fairmod_dialog_interacting")
			EntityRemoveTag(entity_interacted, "viewing")
			state.in_call = false
		end
		phone_dialog_system.dialog_box_height = 70

		state.dialog = phone_dialog_system.open_dialog(call)
		
		if not state.dialog then
			state.in_call = false
			GameRemoveFlagRun("fairmod_dialog_interacting")
			return
		end

		state.dialog.is_too_far = function()
			local player = EntityGetWithTag("player_unit")[1]
			if not player then return true end
			local px, py = EntityGetTransform(player)
			local phone_x, phone_y = EntityGetTransform(entity_interacted)
			local distance = math.sqrt((px - phone_x)^2 + (py - phone_y)^2)
			return distance > 35
		end
		
		if call.func ~= nil then call.func(state.dialog) end
	elseif ModSettingGet("fairmod.listened_to_numbers") and minute == 0 or minute == 30 then
		state.in_call = true
		local sound_event = state.is_nokia and "payphone/nokia_pickup" or "payphone/pickup"
		GamePlaySound("mods/noita.fairmod/fairmod.bank", sound_event, entity_x, entity_y)
		local phone_dialog_system = state.dialog_system
		phone_dialog_system.dialog_box_height = 70

		state.dialog = phone_dialog_system.open_dialog({
			name = state.is_nokia and "Nokia 3310" or "Payphone",
			portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
			typing_sound = "garbled",
			text = "{@delay 5}Talk to the staff, ask for gerald... {@func " .. state.callbacks_key .. "_disconnected}",
			options = {
				{
					text = "Hang up",
					func = function(dialog)
						hangup_internal(entity_interacted)
					end,
				},
			},
			
		})
		
		if not state.dialog then
			state.in_call = false
			GameRemoveFlagRun("fairmod_dialog_interacting")
			return
		end
		
		state.dialog.on_closed = function()
			GameAddFlagRun("ask_for_gerald")
			GameRemoveFlagRun("fairmod_dialog_interacting")
			EntityRemoveTag(entity_interacted, "viewing")
			state.in_call = false
		end
		
		state.dialog.is_too_far = function()
			local player = EntityGetWithTag("player_unit")[1]
			if not player then return true end
			local px, py = EntityGetTransform(player)
			local phone_x, phone_y = EntityGetTransform(entity_interacted)
			local distance = math.sqrt((px - phone_x)^2 + (py - phone_y)^2)
			return distance > 35
		end
	elseif not state.in_call then
		state.in_call = true
		local sound_event = state.is_nokia and "payphone/nokia_pickup" or "payphone/pickup"
		GamePlaySound("mods/noita.fairmod/fairmod.bank", sound_event, entity_x, entity_y)
		local phone_dialog_system = state.dialog_system
		phone_dialog_system.dialog_box_height = 70
		
		state.callbacks_key = register_callbacks(entity_interacted, phone_dialog_system)
		
		local func_name = state.callbacks_key .. "_disconnected"
		state.dialog = phone_dialog_system.open_dialog({
			name = state.is_nokia and "Nokia 3310" or "Payphone",
			portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
			typing_sound = "none",
			text = "{@func " .. func_name .. "}...",
			options = {
				{
					text = "Hang up",
					func = function(dialog)
						hangup_internal(entity_interacted)
					end,
				},
			},
		})
		
		if not state.dialog then
			state.in_call = false
			GameRemoveFlagRun("fairmod_dialog_interacting")
			return
		end
		
		state.dialog.on_closed = function()
			GameRemoveFlagRun("fairmod_dialog_interacting")
			EntityRemoveTag(entity_interacted, "viewing")
			state.in_call = false
		end

		state.dialog.is_too_far = function()
			local player = EntityGetWithTag("player_unit")[1]
			if not player then return true end
			local px, py = EntityGetTransform(player)
			local phone_x, phone_y = EntityGetTransform(entity_interacted)
			local distance = math.sqrt((px - phone_x)^2 + (py - phone_y)^2)
			return distance > 35
		end
	end
end
