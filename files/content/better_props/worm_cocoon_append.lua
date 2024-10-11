dofile_once("data/scripts/director_helpers.lua")

local wormies = {
	total_prob = 0,
	{
		prob = 0.5,
		entity = "data/entities/animals/worm_tiny.xml",
	},
	{
		prob = 0.25,
		entity = "data/entities/animals/worm.xml",
	},
	{
		prob = 0.1,
		entity = "data/entities/animals/worm_big.xml",
	},
	{
		prob = 0.1,
		entity = "data/entities/animals/meatmaggot.xml",
	},
	{
		prob = 0.005,
		entity = "data/entities/animals/worm_end.xml",
	},
	{
		prob = 0.005,
		entity = "data/entities/animals/worm_skull.xml",
	},
}

local original_spawn_worm = spawn_worm
spawn_worm = function(entity_id, pos_x, pos_y)
	local max_amt = RandomDistribution(1, 50, 5, 2.5)
	for i = 1, max_amt do
		local spawn_x = pos_x + Random(-8, 8)
		local spawn_y = pos_y + Random(-8, 8)
		local spawn_worm = random_from_table(wormies, spawn_x, spawn_y)
		if spawn_worm ~= nil then
			local e = EntityLoad(tostring(spawn_worm.entity), spawn_x, spawn_y)

			local worm = EntityGetFirstComponent(e, "WormComponent")
			if worm ~= nil then
				local x, y = EntityGetTransform(e)
				local dx = Random(-1, 1)
				local dy = Random(-1, 1)
				ComponentSetValue2(worm, "mTargetVec", dx, dy)
				ComponentSetValue2(worm, "mTargetPosition", x + dx * 10, y + dy * 10)
				ComponentSetValue2(worm, "mSpeed", 0.5)
				ComponentSetValue2(worm, "mTargetSpeed", 0.5)
			end
		end
	end

	original_spawn_worm(entity_id, pos_x, pos_y)
end
