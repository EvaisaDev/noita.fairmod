dofile_once("data/scripts/lib/utilities.lua")

local function get_chance(colliding_entity_id)
	if EntityHasTag(colliding_entity_id, "player_projectile") then
		return 50
	elseif EntityHasTag(colliding_entity_id, "enemy") then
		return 4
	end
	return 40
end

function should_collapse(colliding_entity_id)
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform(entity_id)

	if EntityHasTag(entity_id, "entrance") then
		local deaths = ModSettingGet("fairmod.deaths") or 0

		-- Don't collapse any on the very first run
		if deaths == 0 then return false end

		-- Maybe more conditions?
	end

	local collider_x, collider_y = EntityGetTransform(colliding_entity_id)
	SetRandomSeed(x + collider_x, y + collider_y + GameGetFrameNum())
	return Random(1, 100) <= get_chance(colliding_entity_id)
end

function collision_trigger(colliding_entity_id)
	if should_collapse(colliding_entity_id) then
		local entity_id = GetUpdatedEntityID()
		local x, y = EntityGetTransform(entity_id)

		local storage = get_variable_storage_component(entity_id, "projectile")
		local projectile = ComponentGetValue2(storage, "value_string")

		local entity = shoot_projectile(entity_id, projectile, x, y + 3, 0, 300, false)

		EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/misc/poof.xml", x, y)

		local physics_body_component = EntityGetFirstComponent(entity, "PhysicsBodyComponent")
		if physics_body_component ~= nil then
			local x, y, angle, vel_x, vel_y, angular_vel = PhysicsComponentGetTransform(physics_body_component)
			PhysicsComponentSetTransform(physics_body_component, x, y, angle, 0, 25, angular_vel)
		end

		EntityKill(entity_id)
	end

	local is_projectile = EntityHasTag(colliding_entity_id, "projectile") or EntityHasTag(colliding_entity_id, "player_projectile")

	if is_projectile then
		local projectile_component = EntityGetFirstComponent(colliding_entity_id, "ProjectileComponent")
		if projectile_component ~= nil then ComponentSetValue2(projectile_component, "lifetime", 1) end
	end
end
