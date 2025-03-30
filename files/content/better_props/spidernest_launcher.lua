local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)

local spawn_distance_sq = 180 * 180
local e_id = EntityGetClosestWithTag(pos_x, pos_y, "player_unit")

if e_id ~= 0 then
	local x, y = EntityGetTransform(e_id)

	local distance_sq = (x - pos_x) * (x - pos_x) + (y - pos_y) * (y - pos_y)
	SetRandomSeed(x, y)
	if distance_sq < spawn_distance_sq and Random(0, 100) < 90 then
		pos_x = pos_x + Random(-4, 4)
		pos_y = pos_y + Random(-4, 4)

		-- forever spawns
		EntityLoad("data/entities/animals/longleg.xml", pos_x, pos_y - 12)
	elseif RaytraceSurfaces(pos_x, pos_y, x, y) == false then
		-- yeet hamis at the player
		local e = EntityLoad("mods/noita.fairmod/files/content/better_props/projectile_hamis.xml", pos_x, pos_y)

		local comp = EntityGetFirstComponent(e, "VelocityComponent")
		ComponentSetValue2(comp, "mVelocity", (x - pos_x) * 100, (y - pos_y) * 100)
	end
end
