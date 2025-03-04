ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita.fairmod/files/content/fishing/files/gun_actions.lua")
--ModLuaFileAppend("data/scripts/gun/gun.lua", "mods/noita.fairmod/files/content/fishing/files/gun.lua")

local module = {}

function module.OnMagicNumbersAndWorldSeedInitialized()
	dofile("mods/noita.fairmod/files/content/fishing/definitions/bait_list.lua")
	dofile("mods/noita.fairmod/files/content/fishing/definitions/fish_list.lua")
	for _, v in pairs(bait_list) do
		if v.id ~= "any" then
			local bait_file = [[
				<Entity name="bobber" tags="bobber" >
					<Base file="data/entities/base_projectile.xml" >
						<VelocityComponent
							gravity_y="350"
							air_friction="0.6"
							mass="0.05"
							>
						</VelocityComponent>
					</Base>
				
					<MaterialSuckerComponent 
						_tags="enabled_in_world"
						barrel_size="1"
						num_cells_sucked_per_frame="1"
						set_projectile_to_liquid="1"
						material_type="3"
					></MaterialSuckerComponent>
					
					<MaterialInventoryComponent 
						_tags="enabled_in_world,enabled_in_hand"
						drop_as_item="0" 
						on_death_spill="0"
						leak_pressure_min="0.07"
						leak_pressure_min="0.1"
						leak_on_damage_percent="1"
						min_damage_to_leak="0.0"
						death_throw_particle_velocity_coeff="0.5" >
						<count_per_material_type>
						</count_per_material_type>
					</MaterialInventoryComponent>
					
					<ProjectileComponent 
						lob_min="0.5"
						lob_max="0.7"
						speed_min="250"
						speed_max="300"
						friction="1"
						direction_random_rad="0.01"
						on_death_explode="0"
						on_death_gfx_leave_sprite="1" 
						on_lifetime_out_explode="0"
						explosion_dont_damage_shooter="1"
						on_collision_die="0"
						on_collision_remove_projectile="0"
						lifetime="99999999999999"
						damage="0"
						damage_scaled_by_speed="1"
						lifetime_randomness="7"
						ragdoll_force_multiplier="0"
						hit_particle_force_multiplier="0.2"
						create_shell_casing="0"
						muzzle_flash_file=""
						shoot_light_flash_r="255"
						shoot_light_flash_g="240"
						shoot_light_flash_b="30"
						shoot_light_flash_radius="64"
						die_on_low_velocity="0"
						penetrate_entities="0"
						penetrate_world="0"
						penetrate_world_velocity_coeff="0"
						damage_every_x_frames="5"
						die_on_low_velocity_limit="0"
						bounces_left="99999999999999999"
						bounce_energy="0"
						bounce_at_any_angle="1"
						collide_with_shooter_frames="6"
						friendly_fire="1"
						velocity_sets_rotation="0"
						velocity_updates_animation="1"
						velocity_sets_scale="0"
						>
						<damage_by_type
							>
						</damage_by_type>
						<config_explosion>
						</config_explosion>
					</ProjectileComponent>
					
					<SpriteComponent 
						_enabled="1" 
						alpha="1" 
						image_file="mods/noita.fairmod/files/content/fishing/files/baits/gfx/wood_bobber_projectile.png" 
						offset_x = "4.5"
						offset_y = "4.5"
						>
					</SpriteComponent>
					
					<SpriteComponent 
						_tags="fish_catch"
						_enabled="0" 
						alpha="0.5" 
						emissive="1"
						image_file="mods/noita.fairmod/files/content/fishing/files/fish/shadows/catch.png"  
						offset_x = "-1"
						offset_y = "-2"
						>
					</SpriteComponent>
				
				
					<LuaComponent
						script_source_file="mods/noita.fairmod/files/content/fishing/files/baits/scripts/bobber_handler.lua"
						execute_on_added="1"
						execute_every_n_frame="1"
					>
					</LuaComponent>

					<LuaComponent
						script_source_file="mods/noita.fairmod/files/content/fishing/files/baits/scripts/bobber_init.lua"
						execute_on_added="0"
						execute_every_n_frame="2"
						execute_times="1"
					>
					</LuaComponent>
				
					<VariableStorageComponent
						name="has_catch"
						value_bool="0"
						>
					</VariableStorageComponent>
					
					<VariableStorageComponent
						name="return_bobber"
						value_bool="0"
					>
					</VariableStorageComponent>
				
					<VariableStorageComponent
						name="rope_entity"
						value_int="0"
						>
					</VariableStorageComponent>

					<VariableStorageComponent
						name="bait_type"
						value_string="]] .. v.id .. [["
					>
					</VariableStorageComponent>
					<SpriteComponent 
						_tags="bait_sprite"
						_enabled="1" 
						alpha="1" 
						image_file="]] .. v.sprite_small .. [["
						offset_x = "4.5"
						offset_y = "0"
					>
					</SpriteComponent>
				
				</Entity>
			]]

			ModTextFileSetContent("mods/noita.fairmod/files/content/fishing/files/baits/entities/" .. v.id .. ".xml", bait_file)
		end
	end
end

function module.OnPlayerSpawned(player)
	local x, y = EntityGetTransform(player)

	local entity = EntityLoad("mods/noita.fairmod/files/content/fishing/files/rod/default_rod.xml", x, y)

	GamePickUpInventoryItem(player, entity, false)
end

ModRegisterAudioEventMappings("mods/noita.fairmod/files/content/fishing/GUIDs.txt")

return module
