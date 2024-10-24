local ring_chance = 1

local entity_id = GetUpdatedEntityID()
local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35

function hangup(dialog)
	GamePlaySound("mods/noita.fairmod/fairmod.bank", "payphone/putdown", x, y)
	dialog.close()
	in_call = false
	is_disconnected = false
end

function disconnected(dialog)
	is_disconnected = true
end

dialog = dialog or nil

if(dialog and in_call and #(EntityGetInRadiusWithTag(x, y, 30, "player_unit") or {}) == 0)then
	hangup(dialog)
end

dialog_system.functions.hangup = hangup
dialog_system.functions.disconnected = disconnected

local call_options = dofile("mods/noita.fairmod/files/content/payphone/content/dialog.lua")

ringing = ringing or false
ring_timer = ring_timer or 0
ring_end_time = ring_end_time or 0
in_call = in_call or false
is_disconnected = is_disconnected or false

if(is_disconnected)then
	GameEntityPlaySoundLoop(entity_id, "disconnected", 1)
end

local x, y = EntityGetTransform(entity_id)
local players = EntityGetInRadiusWithTag(x, y, 500, "player_unit")

if(players == nil or #players == 0) then
	return
end

-- random chance for the phone to ring if the player is nearby
if(GameGetFrameNum() % 2 == 0 and not ringing and not in_call and Random(0, 100) <= ring_chance)then
	ringing = true
	ring_end_time = 60 * 15
end

if(ringing)then
	ring_timer = ring_timer + 1
	print("Hanging up in: " .. tostring(ring_end_time - ring_timer))
	if(ring_timer % 220 == 0)then
		GamePlaySound("mods/noita.fairmod/fairmod.bank", "payphone/ring", x, y)
	end
end

if(not in_call and ringing and ring_timer >= ring_end_time)then
	ringing = false
	ring_timer = 0
end


function interacting(entity_who_interacted, entity_interacted, interactable_name)
	SetRandomSeed(x, y + GameGetFrameNum())
	if(ringing)then
		ringing = false
		ring_timer = 0
		in_call = true
		GamePlaySound("mods/noita.fairmod/fairmod.bank", "payphone/pickup", x, y)
		-- open random call
		local call = call_options[Random(1, #call_options)]
		dialog = dialog_system.open_dialog(call)

		print("Call started")
	end
end