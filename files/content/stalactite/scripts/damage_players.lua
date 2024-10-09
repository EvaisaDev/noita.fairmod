local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local velocity_comp = EntityGetFirstComponent(entity_id, "VelocityComponent")
local can_damage = false;
if(velocity_comp)then
	local vel_x, vel_y = ComponentGetValue2(velocity_comp, "mVelocity")
	local speed = math.sqrt(vel_x * vel_x + vel_y * vel_y)

	print("speed: "..speed)

	if(speed > 100)then
		can_damage = true
	end
end

if(not can_damage)then
	return
end
local players = EntityGetInRadiusWithTag(x, y, 9, "player_unit") or {}

for k, v in ipairs(players)do
	local player_id = v
	local px, py = EntityGetTransform(player_id)

	EntityInflictDamage(player_id, 100000, "DAMAGE_PHYSICS_HIT", "Falling Debris", "BLOOD_EXPLOSION", 0, 0, entity_id, x, y, 0.1)

	SetRandomSeed(px, py)

	local count = Random(3, 5)
	-- spawn guts
	for i = 1, count do
		EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/guts/guts"..Random(1, 5)..".xml", px, py)
	end
end
