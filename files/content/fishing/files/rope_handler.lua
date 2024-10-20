dofile_once("mods/noita.fairmod/files/content/fishing/files/eva_utils.lua")
dofile_once("data/scripts/lib/utilities.lua")

rope = GetUpdatedEntityID()

entity_1 = EntityGetVariable(rope, "entity_1", "int")
entity_2 = EntityGetVariable(rope, "entity_2", "int")

if entity_1 ~= 0 and entity_2 ~= 0 then
	if EntityGetIsAlive(entity_1) and EntityGetIsAlive(entity_2) then
		--	print("eee?")
		local verletphysics_comp_found = false
		local last_point_index = 0
		edit_component(rope, "VerletPhysicsComponent", function(comp, vars)
			verletphysics_comp_found = true
			last_point_index = ComponentGetValue(comp, "num_points")

			--positions = ComponentGetValue2(comp, "positions")
		end)

		local x1, y1, rotation = EntityGetTransform(entity_1)
		local x2, y2 = EntityGetTransform(entity_2)

		y2 = y2 - 4

		local rx = math.cos(rotation)
		local ry = math.sin(rotation)

		x1 = x1 + (rx * 30)
		y1 = y1 + (ry * 30)
		--x1 = x1 + 18

		if verletphysics_comp_found then
			local index = 0

			EntitySetTransform(rope, x1, y1)
			edit_all_components(rope, "VerletWorldJointComponent", function(comp, vars)
				if index == 0 then
					ComponentSetValueVector2(comp, "world_position", x1, y1)
				else
					ComponentSetValueVector2(comp, "world_position", x2, y2)
					--vars.verlet_point_index = last_point_index
				end

				index = index + 1
			end)
		end
	else
		EntityKill(rope)
	end
else
	EntityKill(rope)
end
