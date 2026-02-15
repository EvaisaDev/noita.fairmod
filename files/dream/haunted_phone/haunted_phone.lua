local ring_chance = 1

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

local function hangup_internal(phone_entity_id)
	local state = payphone_state[phone_entity_id]
	if not state then return end

	local px, py = EntityGetTransform(phone_entity_id)
	GamePlaySound("mods/noita.fairmod/fairmod.bank", "payphone/putdown", px, py)
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