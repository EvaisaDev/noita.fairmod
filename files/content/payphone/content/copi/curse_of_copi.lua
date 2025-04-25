--stylua: ignore start
-- Punish the player for lying
if not ModIsEnabled("copis_things") then
	local victim = GetUpdatedEntityID()
	--[[local dmc = EntityGetFirstComponent(victim, "DamageModelComponent")
	local max_hp = ComponentGetValue2(dmc, "max_hp")
	EntityInflictDamage( victim, max_hp / 100, "DAMAGE_PHYSICS_BODY_DAMAGED", "Install Copi's Things!", "DISINTEGRATED", math.random(-5, 5), math.random(-5, 5), victim )
	EntityInflictDamage( victim, 0.04, "DAMAGE_CURSE", "Install Copi's Things!", "DISINTEGRATED", math.random(-5, 5), math.random(-5, 5), victim )]]
	local x, y = EntityGetTransform(victim)
	if(#EntityGetInRadiusWithTag(x, y, 512, "copi") < 10)then
			
		SetRandomSeed(x + GameGetFrameNum(), y)
		local copi = EntityLoad("mods/noita.fairmod/files/content/payphone/content/copi/copi_ghost.xml", x + Random(-5, 5), y + Random(-5, 5))
		EntityRemoveTag(copi, "enemy")
	end


	--[[ This just doesn't work
	local velc = EntityGetFirstComponent(victim, "CharacterDataComponent")
	local x, y = ComponentGetValue2(velc, "mVelocity")
	ComponentSetValue2(velc, "mVelocity", x+math.random(-5, 5), y+math.random(-5, 5))]]
end
--stylua: ignore end
