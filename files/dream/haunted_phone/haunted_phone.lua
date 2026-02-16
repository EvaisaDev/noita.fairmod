local ring_max_vol = .12
local ring_max_distance = 200
local ring_distance_buffer = 25

local entity_id = GetUpdatedEntityID()
local disconnected_audio = EntityGetFirstComponentIncludingDisabled(entity_id, "AudioLoopComponent", "disconnected")
local ringing_audio = EntityGetFirstComponentIncludingDisabled(entity_id, "AudioLoopComponent", "ring")
local ringing_data = EntityGetFirstComponentIncludingDisabled(entity_id, "VariableStorageComponent")
if not (disconnected_audio and ringing_audio and ringing_data) then return end

local x,y = EntityGetTransform(entity_id)
local current_frame = GameGetFrameNum()
SetRandomSeed(current_frame, x-y)

local is_currently_ringing = ComponentGetValue2(ringing_data, "value_bool")
if is_currently_ringing and current_frame > ComponentGetValue2(ringing_data, "value_int") then
	print("no longer ringing")
	is_currently_ringing = false
	EntitySetComponentIsEnabled(entity_id, ringing_audio, false)
	ComponentSetValue2(ringing_audio, "auto_play", false)
	ComponentSetValue2(ringing_data, "value_bool", false)
end


if not is_currently_ringing and current_frame % 60 == 0 and Random(1, 100) == 66 then
	print("playing ring")
	is_currently_ringing = true
	EntitySetComponentIsEnabled(entity_id, ringing_audio, true)
	ComponentSetValue2(ringing_audio, "auto_play", true)
	ComponentSetValue2(ringing_data, "value_bool", true)
	ComponentSetValue2(ringing_data, "value_int", current_frame + 270)
end


local function get_distance(target_x, target_y)
	if not (target_x and target_y) then return ring_max_distance * 10 end
	return math.sqrt((target_x-x)^2 + (target_y-y)^2)
end

if is_currently_ringing then
	local closest_player = EntityGetClosestWithTag(x, y, "player_unit")
	local closest_polied_player = EntityGetClosestWithTag(x, y, "polymorphed_player")
	local px,py = EntityGetTransform(closest_player)
	local ppx,ppy = EntityGetTransform(closest_polied_player)
	local closest_player_dist = math.min(get_distance(px, py) - ring_distance_buffer, get_distance(ppx, ppy) - ring_distance_buffer, ring_max_distance)

	local ringing_vol = ring_max_vol * (math.max(0, closest_player_dist)/ring_max_distance)
	ComponentSetValue2(ringing_audio, "m_volume", ringing_vol)
end
