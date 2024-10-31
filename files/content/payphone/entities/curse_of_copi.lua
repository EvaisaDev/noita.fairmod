-- Punish the player for lying
if not ModIsEnabled("copis_things") then
	local victim = GetUpdatedEntityID()
	local dmc = EntityGetFirstComponent(victim, "DamageModelComponent")
	local max_hp = ComponentGetValue2(dmc, "max_hp")
	EntityInflictDamage(
		victim,
		max_hp / 100,
		"DAMAGE_PHYSICS_BODY_DAMAGED",
		"Install Copi's Things!",
		"DISINTEGRATED",
		math.random(-5, 5),
		math.random(-5, 5),
		victim
	)
	EntityInflictDamage(
		victim,
		0.04,
		"DAMAGE_CURSE",
		"Install Copi's Things!",
		"DISINTEGRATED",
		math.random(-5, 5),
		math.random(-5, 5),
		victim
	)
	--[[ This just doesn't work
	local velc = EntityGetFirstComponent(victim, "CharacterDataComponent")
	local x, y = ComponentGetValue2(velc, "mVelocity")
	ComponentSetValue2(velc, "mVelocity", x+math.random(-5, 5), y+math.random(-5, 5))]]
end
