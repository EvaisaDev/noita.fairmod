-- Sorry this is deranged, however it was stolen from prototype code that I never bothered to rewrite, feel free to clean it up if you are even able to interpret it.
-- by eba btw

--Wrong Warp, WrongWarp (comments to make finding this script easier lmao)

delay = delay or dofile("mods/noita.fairmod/files/lib/delay.lua")

local max_search_range = 512
local step_size = 16

local get_content = ModTextFileGetContent

local function create_hole_of_size(x, y, r)
	local hole_maker = EntityCreateNew("hole")
	EntitySetTransform(hole_maker, x, y)
	EntityAddComponent(hole_maker, "CellEaterComponent", {
		radius = tostring(r),
	})
	EntityAddComponent(hole_maker, "LifetimeComponent", {
		lifetime = "1",
	})
end

delay.update()

function teleported(from_x, from_y, to_x, to_y, portal_teleport)
	local player_entity = GetUpdatedEntityID()
	SetRandomSeed((from_x + to_x) * GameGetFrameNum(), (from_y + to_y) * GameGetFrameNum())

	local rand = Random(0, 100)

	if GameHasFlagRun("always_lost") or GameHasFlagRun("random_teleport_next") or (portal_teleport and rand < 10) or rand < 5 then
		if portal_teleport then GameAddFlagRun("portal_malfunction") end
		GameRemoveFlagRun("random_teleport_next")
		dofile("mods/noita.fairmod/files/content/funky_portals/biome_blacklist.lua")
		local biome_map_w, biome_map_h = BiomeMapGetSize()
		local chunk_size = 512
		local offset = GetParallelWorldPosition(from_x, from_y) * BiomeMapGetSize() * 512

		local map_offset_y = 0

		local biomes_all_content = get_content("data/biome/_biomes_all.xml")

		-- use lua pattern to get `biome_offset_y="14"` value
		local biome_offset_y = string.match(biomes_all_content, 'biome_offset_y="(%d+)"')

		if biome_offset_y then map_offset_y = tonumber(biome_offset_y) end

		local positions = {}

		local a, b, c, d, e, f = GameGetDateAndTimeLocal()

		-- iterate through biome map pixels
		for x = 0, biome_map_w - 1 do
			for y = 0, biome_map_h - 1 do
				-- calculate world position
				local world_x = (x * chunk_size) - ((biome_map_w * chunk_size) / 2)
				local world_y = y * chunk_size - (map_offset_y * chunk_size)

				local weight = 1

				if y >= 14 then weight = 3 end

				-- get center of pixel
				local center_x = world_x + (chunk_size / 2) + offset --offset keeps player in PW
				local center_y = world_y + (chunk_size / 2)

				-- get biome at pixel
				local biome = BiomeMapGetName(center_x, center_y)

				if biome ~= nil and biome ~= "" then
					local legal = true
					for i, blacklist_biome in ipairs(biome_blacklist) do
						if biome == blacklist_biome then
							legal = false
							break
						end
					end

					if legal then table.insert(positions, { x = center_x, y = center_y, biome = biome, weight = weight }) end
				end
			end
		end

		local random_biome_list = {}
		local function GenerateRandomBiomeList()
			random_biome_list = {}
			local biome_positions = {}
		
			-- Collect positions for each biome
			for i, v in ipairs(positions) do
				if not biome_positions[v.biome] then
					biome_positions[v.biome] = {}
				end
				table.insert(biome_positions[v.biome], v)
			end
		
			-- For each biome, pick a random position and add to random_biome_list
			for biome, pos_list in pairs(biome_positions) do
				-- Pick a random position from the list
				local random_index = math.random(#pos_list)
				local random_pos = pos_list[random_index]
		
				-- Add the random position to the list, considering its weight
				for j = 1, random_pos.weight do
					table.insert(random_biome_list, random_pos)
				end
			end
		end

		local function ChooseSpawn()
			GenerateRandomBiomeList()

			local index = Random(1, #random_biome_list)

			EntityApplyTransform(player_entity, random_biome_list[index].x, random_biome_list[index].y)
			-- check if position is safe
			delay.new(function()
				return DoesWorldExistAt(
					random_biome_list[index].x,
					random_biome_list[index].y,
					random_biome_list[index].x + 1,
					random_biome_list[index].y + 1
				)
			end, function()
				--print("World loaded at spot, beginning search...")

				local valid_positions = {}
				for curr_x = random_biome_list[index].x - (max_search_range / 2), random_biome_list[index].x + (max_search_range / 2), step_size do
					for curr_y = random_biome_list[index].y - (max_search_range / 2), random_biome_list[index].y + (max_search_range / 2), step_size do
						EntityApplyTransform(player_entity, curr_x, curr_y)

						if DoesWorldExistAt(curr_x - 5, curr_y - 5, curr_x + 5, curr_y + 5) then
							local hit = RaytraceSurfaces(curr_x - 2, curr_y - 6, curr_x + 2, curr_y + 2)
							if not hit then
								-- raycast straight down for 512 pixels
								local hit2, hit_x, hit_y = RaytraceSurfaces(curr_x, curr_y, curr_x, curr_y + 512)
								local hit3 = RaytraceSurfacesAndLiquiform(hit_x, hit_y - 1, hit_x, hit_y - 5)

								if hit2 and not hit3 then table.insert(valid_positions, { x = hit_x, y = hit_y - 8 }) end
							end
						end
					end
				end

				if #valid_positions > 0 then
					local safe_index = Random(1, #valid_positions)

					-- remove all entities in the area, as long as they are not player_unit
					local entities = EntityGetInRadius(valid_positions[safe_index].x, valid_positions[safe_index].y, 20)
					for i, entity in ipairs(entities) do
						if entity ~= player_entity and EntityGetRootEntity(entity) == entity then
							local physics_body_component = EntityGetFirstComponentIncludingDisabled(entity, "PhysicsBodyComponent")
							local physics_body2_component = EntityGetFirstComponentIncludingDisabled(entity, "PhysicsBody2Component")
							local explosion_component = EntityGetFirstComponentIncludingDisabled(entity, "ExplosionComponent")
							local projectile_component = EntityGetFirstComponentIncludingDisabled(entity, "ProjectileComponent")
							local explode_on_damage_component = EntityGetFirstComponentIncludingDisabled(entity, "ExplodeOnDamageComponent")

							if
								physics_body_component
								or physics_body2_component
								or explosion_component
								or projectile_component
								or explode_on_damage_component
							then
								EntityKill(entity)
							end
						end
					end

					EntityApplyTransform(player_entity, valid_positions[safe_index].x, valid_positions[safe_index].y)
					delay.new(10, function()
						--EntityApplyTransform(player_entity, valid_positions[safe_index].x, valid_positions[safe_index].y)
						local new_x, new_y = FindFreePositionForBody(valid_positions[safe_index].x, valid_positions[safe_index].y, 0, 0, 6)
						EntityApplyTransform(player_entity, new_x, new_y)

						-- create hole
						delay.new(5, function()
							create_hole_of_size(new_x, new_y, 6)
							if not GameHasFlagRun("no_return") and not GameHasFlagRun("always_lost") then --return rift
								local return_portal = EntityLoad("mods/noita.fairmod/files/content/funky_portals/return_portal.xml", new_x, new_y)
								EntityAddComponent2(return_portal, "VariableStorageComponent", {
									name = "target_x",
									value_float = from_x,
								})
								EntityAddComponent2(return_portal, "VariableStorageComponent", {
									name = "target_y",
									value_float = from_y,
								})
							else
								GameRemoveFlagRun("no_return")
							end
						end)
					end)

					print("Safe position found at " .. valid_positions[safe_index].x .. ", " .. valid_positions[safe_index].y)
					-- print non chuck size
					print(
						"Safe position found at "
							.. math.floor(valid_positions[safe_index].x / chunk_size)
							.. ", "
							.. math.floor(valid_positions[safe_index].y / chunk_size)
					)
				else
					ChooseSpawn()
				end
			end)
		end

		ChooseSpawn()
	end
end
