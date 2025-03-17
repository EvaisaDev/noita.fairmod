local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

local module = {
	gui = GuiCreate(),
	selected_slot = 1,
	place_distance_max = 100,
	grid_size = 16,
	ghost_entity = nil,
}

local blocks = {
	{
		texture = "door1",
		sound = "minecraft/wood",
		custom_handler = function(block)
			local xml = nxml.parse("<Entity></Entity>")
	
			xml:add_child(nxml.new_element("PhysicsBody2Component", {
				is_static = "1",
				kill_entity_after_initialized = "1",
			}))
		
			xml:add_child(nxml.new_element("PhysicsImageShapeComponent", {
				body_id = "100",
				is_root = "1",
				centered = "0",
				image_file = "mods/noita.fairmod/files/content/minecraft/textures/door1.png",
				material = block.material,
			}))

			xml:add_child(nxml.new_element("PhysicsImageShapeComponent", {
				body_id = "100",
				is_root = "1",
				centered = "0",
				offset_y = "-16",
				image_file = "mods/noita.fairmod/files/content/minecraft/textures/door2.png",
				material = block.material,
			}))

			local xml_ghost = nxml.parse("<Entity></Entity>")

			xml_ghost:add_child(nxml.new_element("SpriteComponent", {
				image_file = "mods/noita.fairmod/files/content/minecraft/textures/door1.png",
				offset_x = "0",
				offset_y = "0",
				update_transform = "1",
				z_index = "1",
				alpha = "0.5",
				emissive = "1",
			}))

			xml_ghost:add_child(nxml.new_element("SpriteComponent", {
				image_file = "mods/noita.fairmod/files/content/minecraft/textures/door2.png",
				offset_x = "0",
				offset_y = "16",
				update_transform = "1",
				z_index = "1",
				alpha = "0.5",
				emissive = "1",
			}))



			return xml, xml_ghost
		end,
		material = "wood_static",
	},
	{
		texture = "cobblestone",
		sound = "minecraft/stone",
		material = "rock_static",
	},
	{
		texture = "stone",
		sound = "minecraft/stone",
		material = "rock_static",
	},
	{
		texture = "dirt",
		sound = "minecraft/dirt",
		material = "soil",
	},
	{
		texture = "grass",
		sound = "minecraft/dirt",
		material = "soil",
	},
	{
		texture = "furnace",
		sound = "minecraft/stone",
		material = "rock_static",
	},
	{
		texture = "planks",
		sound = "minecraft/wood",
		material = "wood_static",
	},
	{
		texture = "craftingtable",
		sound = "minecraft/wood",
		material = "wood_static",
	},
	{
		texture = "tnt",
		sound = "minecraft/wood",
		material = "wood_prop_noplayerhit",
		custom_handler = function(block)
			local xml = nxml.parse("<Entity></Entity>")
	
			xml:add_child(nxml.new_element("PhysicsBody2Component", {
				is_static = "0",
				kill_entity_after_initialized = "0",
			}))
		
			xml:add_child(nxml.new_element("PhysicsImageShapeComponent", {
				body_id = "100",
				is_root = "1",
				centered = "0",
				image_file = "mods/noita.fairmod/files/content/minecraft/textures/tnt.png",
				material = block.material,
			}))

			
			xml:add_child(nxml.new_element("DamageModelComponent", {
				air_needed = "0",
				blood_material = "",
				drop_items_on_death = "0",
				falling_damage_damage_max = "1.2",
				falling_damage_damage_min = "0.1",
				falling_damage_height_max = "250",
				falling_damage_height_min = "70",
				falling_damages = "0",
				fire_damage_amount = "0.4",
				fire_probability_of_ignition = "0",
				critical_damage_resistance = "1",
				hp = "1.0",
				is_on_fire = "0",
				materials_create_messages = "0",
				materials_damage = "0",
				ragdoll_filenames_file = "",
				ragdoll_material = "",
			}))

			local explode_on_damage = nxml.new_element("ExplodeOnDamageComponent", {
				explode_on_death_percent = "1",
				explode_on_damage_percent = "0.0",
				physics_body_modified_death_probability = "1",
				physics_body_destruction_required = "0.04",
			})

			explode_on_damage:add_child(nxml.new_element("config_explosion", {
				never_cache = "0",
				damage = "2.5",
				camera_shake = "40",
				explosion_radius = "40",
				explosion_sprite = "data/particles/explosion_032.xml",
				explosion_sprite_lifetime = "10",
				create_cell_probability = "50",
				hole_destroy_liquid = "0",
				hole_enabled = "1",
				ray_energy = "4000000",
				particle_effect = "0",
				load_this_entity = "data/entities/particles/particle_explosion/main_gunpowder_medium.xml",
				damage_mortals = "1",
				physics_explosion_power_min = "1.5",
				physics_explosion_power_max = "2.2",
				physics_throw_enabled = "1",
				shake_vegetation = "1",
				sparks_count_min = "7",
				sparks_count_max = "20",
				sparks_enabled = "1",
				stains_enabled = "1",
				stains_radius = "15",
				delay_min = "1",
				delay_max = "4",
				explosion_delay_id = "1",
				audio_event_name = "explosions/box",
			}))

			xml:add_child(explode_on_damage)

			local projectile_comp = nxml.new_element("ProjectileComponent", {
				_tags = "enabled_in_world",
				lifetime = "-1",
				penetrate_entities = "0",
				damage = "0.0",
				on_lifetime_out_explode = "1",
				explosion_dont_damage_shooter = "0",
				friendly_fire = "1",
				collide_with_shooter_frames = "6",
				on_collision_die = "0",
				damage_every_x_frames = "25",
				do_moveto_update = "1",
			})

			projectile_comp:add_child(nxml.new_element("config_explosion", {
				never_cache = "0",
				damage = "8",
				camera_shake = "15",
				explosion_radius = "60",
				explosion_sprite = "data/particles/explosion_040_poof.xml",
				load_this_entity = "data/entities/particles/particle_explosion/main_gunpowder_medium.xml",
				explosion_sprite_lifetime = "0",
				create_cell_probability = "80",
				hole_destroy_liquid = "1",
				ray_energy = "650000",
				hole_enabled = "1",
				particle_effect = "1",
				damage_mortals = "1",
				physics_throw_enabled = "1",
				shake_vegetation = "0",
				sparks_enabled = "1",
				stains_enabled = "0",
			}))

			xml:add_child(projectile_comp)

			xml:add_child(nxml.new_element("VelocityComponent", {
				_tags="enabled_in_world",
    			affect_physics_bodies="1",
			}))


			local explosion_comp = nxml.new_element("ExplosionComponent", {
				_tags = "enabled_in_world",
				trigger = "ON_DEATH",
			})

			explosion_comp:add_child(nxml.new_element("config_explosion", {
				never_cache = "0",
				damage = "8",
				camera_shake = "15",
				explosion_radius = "60",
				explosion_sprite = "data/particles/explosion_040_poof.xml",
				load_this_entity = "data/entities/particles/particle_explosion/main_gunpowder_medium.xml",
				explosion_sprite_lifetime = "0",
				create_cell_probability = "80",
				hole_destroy_liquid = "1",
				ray_energy = "650000",
				hole_enabled = "1",
				particle_effect = "1",
				damage_mortals = "1",
				physics_throw_enabled = "1",
				shake_vegetation = "0",
				sparks_enabled = "1",
				stains_enabled = "0",
			}))

			xml:add_child(explosion_comp)


			local xml_ghost = nxml.parse("<Entity></Entity>")

			xml_ghost:add_child(nxml.new_element("SpriteComponent", {
				image_file = "mods/noita.fairmod/files/content/minecraft/textures/tnt.png",
				offset_x = "0",
				offset_y = "0",
				update_transform = "1",
				z_index = "1",
				alpha = "0.5",
				emissive = "1",
			}))

			return xml, xml_ghost
		end,
	}

}

function GenerateBlockEntity(block)
	if(block.custom_handler ~= nil)then
		local xml, xml_ghost = block.custom_handler(block)

		local path = "mods/noita.fairmod/files/content/minecraft/entities/" .. block.texture .. ".xml"
		ModTextFileSetContent(path, tostring(xml))

		local path_ghost = "mods/noita.fairmod/files/content/minecraft/entities/" .. block.texture .. "_ghost.xml"
		ModTextFileSetContent(path_ghost, tostring(xml_ghost))
		return
	end
	
	local xml = nxml.parse("<Entity></Entity>")
	
	xml:add_child(nxml.new_element("PhysicsBody2Component", {
		is_static = "1",
		kill_entity_after_initialized = "1",
	}))

	xml:add_child(nxml.new_element("PhysicsImageShapeComponent", {
		body_id = "100",
		is_root = "1",
		centered = "0",
		image_file = "mods/noita.fairmod/files/content/minecraft/textures/" ..block.texture .. ".png",
		material = block.material,
	}))

	local path = "mods/noita.fairmod/files/content/minecraft/entities/" .. block.texture .. ".xml"
	ModTextFileSetContent(path, tostring(xml))

	local xml_ghost = nxml.parse("<Entity></Entity>")
	xml_ghost:add_child(nxml.new_element("SpriteComponent", {
		image_file = "mods/noita.fairmod/files/content/minecraft/textures/" .. block.texture .. ".png",
		offset_x = "0",
		offset_y = "0",
		update_transform = "1",
		z_index = "1",
		alpha = "0.5",
		emissive = "1",
	}))

	local path_ghost = "mods/noita.fairmod/files/content/minecraft/entities/" .. block.texture .. "_ghost.xml"
	ModTextFileSetContent(path_ghost, tostring(xml_ghost))
end

function module.Init()
	for _, block in ipairs(blocks) do
		GenerateBlockEntity(block)
	end
end

function WorldToScreenPos(gui_input, x, y)
	local virt_x = MagicNumbersGetValue("VIRTUAL_RESOLUTION_X")
	local virt_y = MagicNumbersGetValue("VIRTUAL_RESOLUTION_Y")
	local screen_width, screen_height = GuiGetScreenDimensions(gui_input)
	local scale_x = virt_x / screen_width
	local scale_y = virt_y / screen_height
	local cx, cy = GameGetCameraPos()
	local sx, sy = (x - cx) / scale_x + screen_width / 2 + 1.5, (y - cy) / scale_y + screen_height / 2
	return sx, sy
end

function module.Draw(visible)
	local gui_id = 1251352
	local function new_id()
		gui_id = gui_id + 1
		return gui_id
	end

	local w, h = GuiGetScreenDimensions(module.gui)

	local hotbar_image = "mods/noita.fairmod/files/content/minecraft/textures/hotbar.png"
	local hotbar_selector = "mods/noita.fairmod/files/content/minecraft/textures/hotbar_selector.png"

	local hotbar_w, hotbar_h = GuiGetImageDimensions(module.gui, hotbar_image)

	local hotbar_x = w / 2 - hotbar_w / 2
	local hotbar_y = h - hotbar_h - 10


	GuiZSetForNextWidget(module.gui, -10)
	GuiImage(module.gui, new_id(), hotbar_x, hotbar_y, hotbar_image, 1, 1, 1)

	local slot_w, slot_h = 20, 20
	local hotbar_border = 1

	for i, block in ipairs(blocks) do
		local x = hotbar_x + hotbar_border + 2 + (i - 1) * (slot_w)
		local y = hotbar_y + hotbar_border + 2

		if(i == module.selected_slot)then
			GuiZSetForNextWidget(module.gui, -12)
			GuiImage(module.gui, new_id(), x - 4, y - 4, hotbar_selector, 1, 1, 1)
		end
		GuiZSetForNextWidget(module.gui, -11)
		GuiImage(module.gui, new_id(), x, y, "mods/noita.fairmod/files/content/minecraft/textures/" .. block.texture .. ".png", 1, 1, 1)
	end

end

function module.Update(visible)

	GuiStartFrame(module.gui)



	if(not visible)then
		if(module.ghost_entity ~= nil)then
			EntityKill(module.ghost_entity)
			module.ghost_entity = nil
		end
		return
	end



	local entity = GetUpdatedEntityID()
	local root = EntityGetRootEntity(entity)

	if(root == entity or not EntityHasTag(root, "player_unit"))then
		if(module.ghost_entity ~= nil)then
			EntityKill(module.ghost_entity)
			module.ghost_entity = nil
		end
		return
	end

	module.Draw(visible)

	local mouse_x, mouse_y = DEBUG_GetMouseWorld()
	local controls_comp = EntityGetFirstComponentIncludingDisabled(root, "ControlsComponent")

	local controller = GameGetIsGamepadConnected()

	if(controller)then
		local aim_x, aim_y = ComponentGetValue2(controls_comp, "mAimingVectorNormalized")

		local char_x, char_y = EntityGetTransform(root)
		char_y = char_y - 6

		mouse_x = char_x + aim_x * module.place_distance_max
		mouse_y = char_y + aim_y * module.place_distance_max
	end

	local grid_x = math.floor(mouse_x / module.grid_size) * module.grid_size
	local grid_y = math.floor(mouse_y / module.grid_size) * module.grid_size

	local fire1 = ComponentGetValue2(controls_comp, "mButtonDownFire") and GameGetFrameNum() == ComponentGetValue2(controls_comp, "mButtonFrameFire")
	local fire2 = ComponentGetValue2(controls_comp, "mButtonDownFire2") and GameGetFrameNum() == ComponentGetValue2(controls_comp, "mButtonFrameFire2")
	local throw = ComponentGetValue2(controls_comp, "mButtonDownThrow") and GameGetFrameNum() == ComponentGetValue2(controls_comp, "mButtonFrameThrow")

	local switch = (fire2 and not fire1) or (throw and not fire2 and not fire1)

	if(switch)then
		module.selected_slot = module.selected_slot + 1
		if(module.selected_slot > #blocks)then
			module.selected_slot = 1
		end

		if(module.ghost_entity ~= nil)then
			EntityKill(module.ghost_entity)
			module.ghost_entity = nil
		end
	end
	
	local block = blocks[module.selected_slot]

	if(module.ghost_entity == nil)then
		module.ghost_entity = EntityLoad("mods/noita.fairmod/files/content/minecraft/entities/" .. block.texture .. "_ghost.xml", grid_x, grid_y)
	else
		EntitySetTransform(module.ghost_entity, grid_x, grid_y)
	end

	if fire1 then
		local xml_file = "mods/noita.fairmod/files/content/minecraft/entities/" .. block.texture .. ".xml"


		local hit_count = 0
		for x = 0, module.grid_size - 1, 1 do
			for y = 0, module.grid_size - 1, 1 do
				local hit = Raytrace(grid_x + x + 0.2, grid_y + y + 0.2, grid_x + x + 0.4, grid_y + y + 0.4)
				if(hit)then
					hit_count = hit_count + 1
				end
			end
		end

		if(grid_x < 0)then
			grid_x = grid_x + 2
		end

		if(grid_y < 0)then
			grid_y = grid_y + 2
		end

		-- raytrace in a grid to make sure the space is free

		if(hit_count > (module.grid_size * module.grid_size) * 0.9)then
			return
		end


		EntityLoad(xml_file, grid_x, grid_y)

		GamePlaySound("mods/noita.fairmod/fairmod.bank", block.sound, grid_x, grid_y)
	end
end

return module