local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
if root and root ~= entity_id and GameGetGameEffectCount(root, "WET") > 0 then
	local character_data_comp = EntityGetFirstComponentIncludingDisabled(root, "CharacterDataComponent")
	local controls_comp = EntityGetFirstComponentIncludingDisabled(root, "ControlsComponent")
	if not controls_comp or ComponentGetValue2(controls_comp, "mButtonDownDown") then return end
	if not character_data_comp then return end
	GameAddFlagRun("oiled_up")
	local vel_x, vel_y = ComponentGetValue2(character_data_comp, "mVelocity")
	ComponentSetValue2(character_data_comp, "mVelocity", vel_x, math.min(-9, vel_y - 9))
end
