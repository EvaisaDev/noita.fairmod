return {
	["motherlode"] = {
		name = "Motherlode",
		description = "You got 1000 gold, you filthy cheater.",
		func = function(player)
			local wallet_component = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
			if(wallet_component == nil) then return end	
			ComponentSetValue2(wallet_component, "money", ComponentGetValue2(wallet_component, "money") + 1000)
		end,
	},
	["duplicateme"] = {
        name = "Dupe",
        description = "There are two of you??",
        func = function(player)
            EntitySetTransform(EntityLoad("data/entities/player_rng_items.xml", x, y), EntityGetTransform(player))
        end,
    },
	["upupdowndownleftrightleftrightbaenter"] = {
		name = "GOD HAMIS ARTIST-MARTIAL IMMORTALITY GAMER MODE",
		description = "Enabled GHAMING MODE",
		func = function(player)
			if EntityHasTag(player, "no_hamis_bullet") then return end
			EntityAddTag(player, "no_hamis_bullet")
			local comps_to_edit = {
				AudioComponent = {
					["file"] = "data/audio/Desktop/animals.bank",
					["event_root"] = "animals/longleg",
				},
				CharacterDataComponent = {
					["collision_aabb_min_x"]			= -2,
					["collision_aabb_max_x"]			= 2,
					["collision_aabb_min_y"]			= -6,
					["collision_aabb_max_y"]			= -3,
					["mass"]							= 0.4,
					["buoyancy_check_offset_y"]			= -6,
					["fly_recharge_spd"]				= 0.4,
					["fly_recharge_spd_ground"]			= 6,
					["fly_time_max"]					= 3,
					["flying_in_air_wait_frames"]		= 44,
					["flying_needs_recharge"]			= false,
					["flying_recharge_removal_frames"]	= 8,
					["platforming_type"]				= 2,
					["send_transform_update_message"]	= false,
				},
				CharacterPlatformingComponent = {
					["accel_x"]										= 0.3,
					["fly_smooth_y"]								= true,
					["fly_speed_change_spd"]						= 1,
					["fly_speed_max_down"]							= 90,
					["fly_speed_max_up"]							= 90,
					["fly_speed_mult"]								= 50,
					["fly_velocity_x"]								= 26.8325,
					["jump_velocity_x"]								= 500,
					["jump_velocity_y"]								= -300,
					["pixel_gravity"]								= 600,
					["run_animation_velocity_switching_enabled"]	= true,
					["run_animation_velocity_switching_threshold"]	= 50,
					["run_velocity"]								= 2500,
					["turning_buffer"]								= 0.1,
					["velocity_min_x"]								= -50,
					["velocity_min_y"]								= -500,
					["velocity_max_x"]								= 50,
					["velocity_max_y"]								= 500,
				},
				DamageModelComponent = {
					["invincibility_frames"] = 999999,
					["wait_for_kill_flag_on_death"] = true,
					["mFireProbability"] = 0
				},
				GenomeDataComponent = {
					["herd_id"] = "spider",
				},
				HitboxComponent = {
					["aabb_min_x"] = -5,
					["aabb_min_y"] = -6,
					["aabb_max_x"] = 5,
					["aabb_max_y"] = 6,
					["damage_multiplier"] = 0,
				}
			}

			local x, y, r, sx, sy = EntityGetTransform(player)
			LoadRagdoll("data/ragdolls/player/filenames.txt", x, y-10, "meat", sx, 0, -1)

			for comp, values in pairs(comps_to_edit) do
				local comp_id = EntityGetFirstComponentIncludingDisabled(player, comp) --[[@cast comp_id number]]
				for attr, value in pairs(values) do
					ComponentSetValue2(comp_id, attr, value)
				end
			end

			local sprite = EntityGetFirstComponent(player, "SpriteComponent", "lukki_disable") --[[@cast sprite number]]
			ComponentSetValue2(sprite, "image_file", "data/enemies_gfx/longleg.xml")
			ComponentSetValue2(sprite, "offset_y", 14)

			EntityAddComponent2(player, "LuaComponent", {
				script_source_file="mods/noita.fairmod/files/content/cheats/misc/godmode.lua"
			})
			EntityAddComponent2(player, "LuaComponent", {
				script_kick="mods/noita.fairmod/files/content/cheats/misc/hamartial_arts.lua",
				execute_every_n_frame=-1,
			})

			local invuln = EntityCreateNew("invulnerability_GHAMIS")
			EntityAddChild(player, invuln)
			EntityAddComponent2(invuln, "GameEffectComponent", {
				effect="PROTECTION_ALL",
				exclusivity_group=0,
				frames=-1,
			})
			EntityAddComponent2(invuln, "GameEffectComponent", {
				effect="RESPAWN",
				exclusivity_group=0,
				frames=-1,
			})
			EntityAddComponent2(invuln, "GameEffectComponent", {
				effect="SAVING_GRACE",
				exclusivity_group=0,
				frames=-1,
			})
			EntityAddComponent2(invuln, "GameEffectComponent", {
				effect="REMOVE_FOG_OF_WAR",
				exclusivity_group=0,
				frames=-1,
			})
			EntityAddComponent2(invuln, "GameEffectComponent", {
				effect="FASTER_LEVITATION",
				exclusivity_group=0,
				frames=-1,
			})
			EntityAddComponent2(invuln, "GameEffectComponent", {
				effect="MOVEMENT_FASTER_2X",
				exclusivity_group=0,
				frames=-1,
			})
			
			local particles = EntityAddComponent2(player, "ParticleEmitterComponent", {
				velocity_always_away_from_center=100,
				direction_random_deg=360,
				emitted_material_name="spark_purple",
				x_pos_offset_min=-1,
				x_pos_offset_max=1,
				y_pos_offset_min=-9,
				y_pos_offset_max=-7,
				x_vel_min=0,
				x_vel_max=0,
				y_vel_min=-50,
				y_vel_max=-10,
				count_min=10,
				count_max=50,
				lifetime_min=0.10,
				lifetime_max=0.20,
				airflow_force=0.1,
				airflow_time=0.1,
				airflow_scale=0.25,
				is_trail=false,
				create_real_particles=false,
				emit_cosmetic_particles=true,
				render_ultrabright=false,
				render_on_grid=true,
				emission_interval_min_frames=1,
				emission_interval_max_frames=1,
				fade_based_on_lifetime=false,
				is_emitting=true,
				draw_as_long=true,
			})

			ComponentSetValue2(particles, "gravity", 0, 100)
			ComponentSetValue2(particles, "offset", 0, 5)
			ComponentSetValue2(particles, "area_circle_radius", 0, 5)

			EntityAddComponent2(player, "AudioLoopComponent", {
				_tags="music",
				file="mods/noita.fairmod/fairmod.bank",
				event_name="godhamis/loop",
				auto_play=true
			})
		end,
	},
	["ahundredsnailsplease"] = {
        name = "A hundred snails",
        description = "Are you sure about this??",
        func = function(player)
			local x, y = EntityGetTransform(player)

            for i = 1, 100 do
				-- get a random angle radian
				local angle = math.rad(Random(0, 360))
				-- get a random direction vector
				local dx = math.cos(angle)
				local dy = math.sin(angle)

				local distance = Random(100, 250)

				local target_x = x + (dx * distance)
				local target_y = y + (dy * distance)

				local hit = RaytracePlatforms(target_x, target_y, target_x, target_y - 5)

				if(not hit)then
					EntityLoad("mods/noita.fairmod/files/content/immortal_snail/entities/snail.xml", target_x, target_y)
				end
			end
        end,
    },
	["dingus"] = {
        name = "Dingus",
        description = "He looks so polite!!",
        func = function(player)
			local x, y = EntityGetTransform(player)

			EntityLoad("mods/noita.fairmod/files/content/dingus/dingus.xml", x, y)
        end,
    },
}