function interacting(entity_who_interacted, entity_interacted, interactable_name)
	local x, y = EntityGetTransform(entity_who_interacted)
	SetRandomSeed(x, y + GameGetFrameNum())

	local seed = Random(1, 2147483646) + Random(1, 2147483646)
	print("New seed: " .. seed)

	SetWorldSeed(seed)

	GlobalsSetValue("teleporting_end", "1")

	EntityKill(entity_interacted)
end
