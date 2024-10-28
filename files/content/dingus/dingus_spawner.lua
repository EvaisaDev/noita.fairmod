local player = GetUpdatedEntityID()

local x, y = EntityGetTransform(player)

local chunk_x, chunk_y = math.floor(x / 512), math.floor(y / 512)

SetRandomSeed(x, y + GameGetFrameNum())

local dingus = EntityGetWithName("Dingus")

if dingus ~= nil and EntityGetIsAlive(dingus) then return end

-- create a unique id for this chunk
last_chunk_id = last_chunk_id or 0
local chunk_id = chunk_x + chunk_y * 10000

local discovery_chance = 2

local spawn_range = 512

if chunk_id ~= last_chunk_id then
	last_chunk_id = chunk_id
	local has_visited_chunk = GameHasFlagRun("dingus_visited_chunk_" .. chunk_id)

	if not has_visited_chunk then
		GameAddFlagRun("dingus_visited_chunk_" .. chunk_id)

		if Random(0, 100) <= discovery_chance then
			local points = {}
			local angle_step = math.pi * 2 / 32
			for i = 0, 31 do
				local angle = angle_step * i
				local add_x = math.cos(angle) * spawn_range
				local add_y = math.sin(angle) * spawn_range

				local new_x = x + add_x
				local new_y = y + add_y

				local hit = RaytraceSurfaces(new_x, new_y, new_x, new_y + 0.5)
				if hit == false then
					local hit2, hit_x, hit_y = RaytraceSurfaces(new_x, new_y, new_x, new_y + 256)
					if hit2 then table.insert(points, { hit_x, hit_y - 10 }) end
				end
			end

			if #points > 0 then
				-- pick random point
				local point = points[Random(1, #points)]
				local x = point[1]
				local y = point[2]

				EntityLoad("mods/noita.fairmod/files/content/dingus/dingus.xml", x, y)
			end
		end
	end
end
