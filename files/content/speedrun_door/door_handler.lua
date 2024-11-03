--dofile("mods/noita.fairmod/files/lib/coroutines.lua")

kolmi_location_x = 3476
kolmi_location_y = 13108

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	local from_x, from_y = EntityGetTransform(entity_who_interacted)
	EntityLoad("data/entities/particles/teleportation_source.xml", from_x, from_y)

	EntityLoad("mods/noita.fairmod/files/content/speedrun_door/portal_kolmi.xml", from_x, from_y)

	--EntityApplyTransform( entity_who_interacted, kolmi_location_x, kolmi_location_y )
	--EntityLoad("data/entities/particles/teleportation_target.xml", kolmi_location_x, kolmi_location_y)
	--GamePlaySound("data/audio/Desktop/misc.bank","misc/teleport_use", kolmi_location_x, kolmi_location_y)

	LoadBackgroundSprite(
		"mods/noita.fairmod/files/content/speedrun_door/door.png",
		kolmi_location_x - 30,
		kolmi_location_y - 40,
		-10,
		false
	)

	-- better_ui integration
	if not GameHasFlagRun("speedrun_door_used") then GlobalsSetValue("SPEEDRUN_SPLIT_DOOR", tostring(GameGetFrameNum())) end
	GameAddFlagRun("speedrun_door_used")
end
