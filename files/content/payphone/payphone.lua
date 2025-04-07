local ring_chance = 1

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local sprite_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent")
dialog = dialog or nil
dialog_system = dialog_system or dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35
dialog_system.use_entity_pos_for_close_distance = true
dialog_system.sounds.pop = { bank = "mods/noita.fairmod/fairmod.bank", event = "loanshark/pop" }
dialog_system.sounds.breathing = { bank = "mods/noita.fairmod/fairmod.bank", event = "payphone/breathing" }
dialog_system.sounds.gibberish = { bank = "mods/noita.fairmod/fairmod.bank", event = "payphone/gibberish" }
dialog_system.sounds.garbled = { bank = "mods/noita.fairmod/fairmod.bank", event = "payphone/garbled" }

last_interactor = last_interactor or nil

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

function hangup()
	GamePlaySound("mods/noita.fairmod/fairmod.bank", "payphone/putdown", x, y)
	dialog.close()
	in_call = false
	is_disconnected = false
	if do_random_teleport then
		teleport_now()
		do_random_teleport = false
	end

	if(not HasFlagPersistent("fairmod_copimail_letter"))then
		AddFlagPersistent("fairmod_copimail_letter")
		ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "copi,")
	end
end

function disconnected()
	is_disconnected = true
end

function teleport()
	do_random_teleport = true
end

function copibuddy()
	GameAddFlagRun("copibuddy")
end

function ng_portal()
	EntityLoad("mods/noita.fairmod/files/content/payphone/content/rift/return_portal.xml", x, y - 45)
end

local function stop_ringing()
	ringing = false
	ring_timer = 0
	if sprite_comp ~= nil then
		ComponentSetValue2(sprite_comp, "rect_animation", "idle")
	end
end

local function start_ringing()
	ringing = true
	ring_end_time = 60 * 15
	if sprite_comp ~= nil then
		ComponentSetValue2(sprite_comp, "rect_animation", "ringing")
	end
end

if dialog and in_call and #(EntityGetInRadiusWithTag(x, y, 30, "player_unit") or {}) == 0 then hangup() end

dialog_system.functions.hangup = hangup
dialog_system.functions.copibuddy = copibuddy
dialog_system.functions.disconnected = disconnected
dialog_system.functions.teleport = teleport
dialog_system.functions.ng_portal = ng_portal
dialog_system.functions.iamsteve = function()
	GamePlaySound("mods/noita.fairmod/fairmod.bank", "minecraft/iamsteve", x, y)
end

local call_options = dofile("mods/noita.fairmod/files/content/payphone/content/dialog.lua")

ringing = ringing or false
ring_timer = ring_timer or 0
ring_end_time = ring_end_time or 0
in_call = in_call or false
is_disconnected = is_disconnected or false
do_random_teleport = do_random_teleport or false

local audio_loop_disconnected = EntityGetFirstComponent(entity_id, "AudioLoopComponent", "disconnected")
if audio_loop_disconnected ~= nil then
	if is_disconnected then
		ComponentSetValue2(audio_loop_disconnected, "m_volume", 1)

		GameEntityPlaySoundLoop(entity_id, "disconnected", 1)
	else
		ComponentSetValue2(audio_loop_disconnected, "m_volume", 0)
	end
end

local audio_loop_ring = EntityGetFirstComponent(entity_id, "AudioLoopComponent", "ring")
if audio_loop_ring ~= nil then
	if ringing then
		ComponentSetValue2(audio_loop_ring, "m_volume", 1)

		GameEntityPlaySoundLoop(entity_id, "ring", 1)
	else
		ComponentSetValue2(audio_loop_ring, "m_volume", 0)
	end
end

local players = EntityGetInRadiusWithTag(x, y, 500, "player_unit")

if players == nil or #players == 0 then return end

-- random chance for the phone to ring if the player is nearby
if GameGetFrameNum() % 45 == 0 and not ringing and not in_call and Random(0, 100) <= ring_chance then
	start_ringing()
end

if GameHasFlagRun("moshimoshi") and not ringing and not in_call then
	start_ringing()
	GameRemoveFlagRun("moshimoshi")
end

if ringing then ring_timer = ring_timer + 1 end

if not in_call and ringing and ring_timer >= ring_end_time then
	stop_ringing()
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


if(in_call and last_interactor and dialog_system.is_any_dialog_open and GameHasFlagRun("copibuddy") and dialog and dialog.message.name ~= "Copi")then
	if(Random(1, 100) <= 2 and GameGetFrameNum() % 30 == 0)then

		GameAddFlagRun("copibuddy.call_rerouted")
		
		--dialog.close()
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
			EntityRemoveTag(last_interactor, "viewing")
		end
		dialog_system.dialog_box_height = 70

		dialog = dialog_system.open_dialog(call)
		if call.func ~= nil then call.func(dialog) end
	end
end

if(in_call and last_interactor and dialog_system.is_any_dialog_open and GameHasFlagRun("safecall_redirect") and dialog and dialog.message.name ~= "Copi")then
	--dialog.close()
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
		EntityRemoveTag(last_interactor, "viewing")
	end
	dialog_system.dialog_box_height = 70

	dialog = dialog_system.open_dialog(call)
	if call.func ~= nil then call.func(dialog) end
	GameRemoveFlagRun("safecall_redirect")
end

function interacting(entity_who_interacted, entity_interacted, interactable_name)

	last_interactor = entity_who_interacted

	print("Interacting")
	if EntityHasTag(entity_interacted, "viewing") or GameHasFlagRun("fairmod_dialog_interacting") then return end
	if GameHasFlagRun("fairmod_interacted_with_anything_this_frame") then return end
	GameAddFlagRun("fairmod_interacted_with_anything_this_frame")
	GameAddFlagRun("fairmod_dialog_interacting")

	local year, month, day, hour, minute, second = GameGetDateAndTimeLocal()

	SetRandomSeed(x, y + GameGetFrameNum())
	if ringing then
		stop_ringing()
		in_call = true
		GamePlaySound("mods/noita.fairmod/fairmod.bank", "payphone/pickup", x, y)
		-- open random call
		local call = get_random_call(entity_who_interacted)
		local old_on_closed = call.on_closed
		call.on_closed = function()
			if old_on_closed ~= nil then old_on_closed() end
			GameRemoveFlagRun("fairmod_dialog_interacting")
			EntityRemoveTag(entity_interacted, "viewing")
		end
		dialog_system.dialog_box_height = 70

		dialog = dialog_system.open_dialog(call)
		if call.func ~= nil then call.func(dialog) end
		print("Call started")
	elseif ModSettingGet("fairmod.listened_to_numbers") and minute == 0 or minute == 30 then
		in_call = true
		GamePlaySound("mods/noita.fairmod/fairmod.bank", "payphone/pickup", x, y)
		dialog_system.dialog_box_height = 70
		dialog = dialog_system.open_dialog({
			name = "Payphone",
			portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
			typing_sound = "garbled",
			text = "{@delay 5}Talk to the staff, ask for gerald... {@func disconnected}",
			options = {
				{
					text = "Hang up",
					func = function(dialog)
						hangup()
					end,
				},
			},
			
		})
		dialog.on_closed = function()
			GameAddFlagRun("ask_for_gerald")
			GameRemoveFlagRun("fairmod_dialog_interacting")
			EntityRemoveTag(entity_interacted, "viewing")
		end
	elseif not in_call then
		in_call = true
		GamePlaySound("mods/noita.fairmod/fairmod.bank", "payphone/pickup", x, y)
		dialog_system.dialog_box_height = 70
		dialog = dialog_system.open_dialog({
			name = "Payphone",
			portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
			typing_sound = "none",
			text = "{@func disconnected}...",
			options = {
				{
					text = "Hang up",
					func = function(dialog)
						hangup()
					end,
				},
			},
		})
		dialog.on_closed = function()
			GameRemoveFlagRun("fairmod_dialog_interacting")
			EntityRemoveTag(entity_interacted, "viewing")
			print("Call ended")
		end
	end
end
