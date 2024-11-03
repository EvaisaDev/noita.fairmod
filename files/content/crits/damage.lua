---@type script_damage_about_to_be_received
function damage_about_to_be_received(damage, x, y, entity_thats_responsible, critical_hit_chance)
	local me = GetUpdatedEntityID()
	local crit_mult = 1
	SetRandomSeed((x * GameGetFrameNum()) % 25781423, y + GameGetFrameNum())
	local jarated = GameGetGameEffectCount(me, "JARATE") > 0
	local crit_count = 0
	while Random(1, jarated and 4 or 10) == 1 do
		--GamePrint("Got Crit!")
		crit_count = crit_count + 1
		crit_mult = crit_mult * 3
	end
	if crit_count > 0 then
		GamePlaySound("data/audio/Desktop/projectiles.bank", "player_projectiles/critical_hit", x, y)
		EntityLoad("data/entities/particles/critical_hit.xml", x, y)
	end
	if crit_count > 1 then
		GamePlaySound("data/audio/Desktop/projectiles.bank", "player_projectiles/bullet_lightning/destroy", x, y)
		GamePlaySound("data/audio/Desktop/projectiles.bank", "player_projectiles/electric/create", x, y)
	end
	if crit_mult >= 125 then GameAddFlagRun("giga_critted_lol") end
	return damage * crit_mult, critical_hit_chance
end
