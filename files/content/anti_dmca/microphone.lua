dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

local entity = GetUpdatedEntityID()

local x, y, r = EntityGetTransform(entity)

current_pitch = current_pitch or 1


local ability_component = EntityGetFirstComponentIncludingDisabled(entity, "AbilityComponent")
last_frame_used = last_frame_used or 0
local frame = GameGetFrameNum()
if ability_component then
	local next_frame_usable = ComponentGetValue2(ability_component, "mReloadNextFrameUsable")
	if next_frame_usable < frame and next_frame_usable >= last_frame_used then
		GamePlaySound("mods/noita.fairmod/fairmod.bank", "jerma/aaeeoo_local", x, y)
		last_frame_used = frame
	end
end
