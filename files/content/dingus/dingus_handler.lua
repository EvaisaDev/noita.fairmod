local entity = GetUpdatedEntityID()

exploding = exploding or false

local x, y, r = EntityGetTransform(entity)

local sprite_comp_hand = EntityGetFirstComponentIncludingDisabled(entity, "SpriteComponent", "enabled_in_hand")
local sprite_comp = EntityGetFirstComponentIncludingDisabled(entity, "SpriteComponent", "enabled_in_world")

if EntityGetRootEntity(entity) == entity then EntitySetTransform(entity, x, y, 0) end

if sprite_comp_hand then
	-- if rotated upside down, set ComponentSetValue2( sprite_comp_hand, "special_scale_y", -0.05 )
	if r > 1.6 or r < -1.6 then
		ComponentSetValue2(sprite_comp_hand, "special_scale_y", -0.05)
	else
		ComponentSetValue2(sprite_comp_hand, "special_scale_y", 0.05)
	end
end

exploding_timer = exploding_timer or 0

if exploding then
	exploding_timer = exploding_timer + 1

	if exploding_timer == 120 then GamePlaySound("mods/noita.fairmod/fairmod.bank", "dingus/riff", x, y) end
	if exploding_timer == 200 then
		SetRandomSeed(x, y)

		EntityLoad("data/entities/props/physics_skull_01.xml", x + 5, y - 5)

		local count = Random(3, 5)
		-- spawn bones
		for i = 1, count do
			local entity = EntityLoad("data/entities/props/physics_bone_0" .. Random(1, 6) .. ".xml", x, y)
			PhysicsApplyForce(entity, Random(-200, 200), Random(-200, 200))
		end

		EntityLoad("mods/noita.fairmod/files/content/dingus/explosion.xml", x, y)

		EntityKill(entity)
	end
	return
end

local var_storage_comps = EntityGetComponentIncludingDisabled(entity, "VariableStorageComponent")
if not var_storage_comps then return end
local volume_var = nil
for i, comp in ipairs(var_storage_comps) do
	local var_name = ComponentGetValue2(comp, "name")
	if var_name == "dingus_volume" then
		volume_var = comp
		break
	end
end
if not volume_var then return end
local volume = ComponentGetValue2(volume_var, "value_float")

if sprite_comp then
	if volume < 0.5 then
		ComponentSetValue2(sprite_comp, "rect_animation", "idle")
	else
		ComponentSetValue2(sprite_comp, "rect_animation", "dance")
	end
end

current_pitch = current_pitch or 1

if current_pitch > 1 then current_pitch = current_pitch - (3 / 60) end

local ability_component = EntityGetFirstComponentIncludingDisabled(entity, "AbilityComponent")
last_frame_used = last_frame_used or 0
local frame = GameGetFrameNum()
if ability_component then
	local next_frame_usable = ComponentGetValue2(ability_component, "mReloadNextFrameUsable")
	if next_frame_usable < frame and next_frame_usable >= last_frame_used then
		GamePlaySound("mods/noita.fairmod/fairmod.bank", "dingus/meow", x, y)
		current_pitch = current_pitch + 0.8
		last_frame_used = frame
	end
end

if current_pitch >= 9 then
	exploding = true

	ComponentSetValue2(sprite_comp, "image_file", "mods/noita.fairmod/files/content/dingus/dingus_sprite_bones.xml")

	EntityRefreshSprite(entity, sprite_comp)

	-- remove audio loops
	for i, comp in ipairs(EntityGetComponentIncludingDisabled(entity, "AudioLoopComponent") or {}) do
		EntityRemoveComponent(entity, comp)
	end

	function EntityDropItem(entity, item_entity)
		EntityRemoveFromParent(item_entity)
		EntitySetComponentsWithTagEnabled(item_entity, "enabled_in_hand", false)
		EntitySetComponentsWithTagEnabled(item_entity, "enabled_in_world", true)

		local inventory_comp = EntityGetFirstComponentIncludingDisabled(entity, "Inventory2Component")
		if inventory_comp ~= nil then
			ComponentSetValue2(inventory_comp, "mActiveItem", 0)
			ComponentSetValue2(inventory_comp, "mActualActiveItem", 0)
			ComponentSetValue2(inventory_comp, "mForceRefresh", true)
		end
	end

	EntityDropItem(EntityGetRootEntity(entity), entity)

	local item_component = EntityGetFirstComponentIncludingDisabled(entity, "ItemComponent")
	if item_component then ComponentSetValue2(item_component, "is_pickable", false) end
end

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	if volume > 0.5 then
		volume = 0.001
	else
		volume = 1
	end

	ComponentSetValue2(volume_var, "value_float", volume)
end

local audio_loop = EntityGetFirstComponentIncludingDisabled(entity, "AudioLoopComponent", "music")
if not audio_loop then return end

ComponentSetValue2(audio_loop, "m_volume", volume)
