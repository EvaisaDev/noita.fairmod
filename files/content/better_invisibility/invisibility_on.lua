local entity = GetUpdatedEntityID()

local root = EntityGetRootEntity(entity)
local x, y = EntityGetTransform(root)

local function get_all_sprites(entity)
	local result = {}

	for _, sprite in ipairs(EntityGetComponentIncludingDisabled(entity, "SpriteComponent") or {}) do
		table.insert(result, {entity, sprite})
	end

	for _, sprite in ipairs(EntityGetComponentIncludingDisabled(entity, "VerletPhysicsComponent") or {}) do
		table.insert(result, {entity, sprite})
	end

	for _, particle_emitter in ipairs(EntityGetComponentIncludingDisabled(entity, "ParticleEmitterComponent") or {}) do
		table.insert(result, {entity, particle_emitter})
	end

	if(EntityHasTag(entity, "player_unit"))then
		for _, comp in ipairs(EntityGetComponentIncludingDisabled(entity, "InventoryGuiComponent") or {}) do
			table.insert(result, {entity, comp})
		end

		for _, comp in ipairs(EntityGetComponentIncludingDisabled(entity, "PlatformShooterPlayerComponent") or {}) do
			table.insert(result, {entity, comp})
		end
	end

	local children = EntityGetAllChildren(entity) or {}

	for _, child in ipairs(children) do
		local child_sprites = get_all_sprites(child)

		for _, sprite in ipairs(child_sprites) do
			table.insert(result, sprite)
		end
	end

	return result
end

local sprites = get_all_sprites(EntityGetRootEntity(entity))

for _, sprite in ipairs(sprites) do
	if(ComponentGetTypeName(sprite[2]) == "SpriteComponent")then
		if(ComponentGetValue2(sprite[2], "visible"))then
			ComponentAddTag(sprite[2], "bi_invisibility")
			ComponentSetValue2(sprite[2], "visible", false)
		end
	end

	-- THIS EXPLODES THE CAPE BUT TOO LAZY TO FIX WAAAHG
	if(ComponentGetTypeName(sprite[2]) == "VerletPhysicsComponent")then
		if(ComponentGetIsEnabled(sprite[2]))then
			EntitySetComponentIsEnabled(sprite[1], sprite[2], false)
			ComponentAddTag(sprite[2], "bi_invisibility")
		end
	end

	if(ComponentGetTypeName(sprite[2]) == "InventoryGuiComponent")then
		if(ComponentGetIsEnabled(sprite[2]))then
			EntitySetComponentIsEnabled(sprite[1], sprite[2], false)
			ComponentAddTag(sprite[2], "bi_invisibility")
		end
	end

	if(ComponentGetTypeName(sprite[2]) == "ParticleEmitterComponent")then
		if(ComponentGetValue2(sprite[2], "emitting"))then
			ComponentAddTag(sprite[2], "bi_invisibility")
			ComponentSetValue2(sprite[2], "emitting", false)
		end
	end

	if(ComponentGetTypeName(sprite[2]) == "PlatformShooterPlayerComponent")then
		ComponentSetValue2(sprite[2], "center_camera_on_this_entity", false)

		local camera_x, camera_y = GameGetCameraPos()
		local lerp_speed = 0.01
		
		local dx = x - camera_x
		local dy = y - camera_y

		local new_x = camera_x + dx * lerp_speed
		local new_y = camera_y + dy * lerp_speed

		ComponentSetValue2(sprite[2], "mDesiredCameraPos", new_x, new_y)

		ComponentAddTag(sprite[2], "bi_invisibility")
	end




end





