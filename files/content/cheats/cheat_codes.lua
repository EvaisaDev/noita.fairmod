--stylua: ignore start
local markers = dofile_once("mods/noita.fairmod/files/content/better_world/map_helper.lua")
return {
	{
		code = "motherlode",
		name = "Motherlode",
		description = "You got 1000 gold, you filthy cheater.",
		func = function(player)
			local wallet_component = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
			if wallet_component == nil then return end
			ComponentSetValue2(wallet_component, "money", ComponentGetValue2(wallet_component, "money") + 1000)
		end,
	},
	{
		code = "duplicateme",
		name = "Dupe",
		description = "There are two of you??",
		func = function(player)
			EntitySetTransform(EntityLoad("data/entities/player_rng_items.xml", x, y), EntityGetTransform(player))
		end,
	},
	{
		code = "upupdowndownleftrightleftrightbaenter",
		name = "GOD HAMIS ARTIST-MARTIAL IMMORTALITY GAMER MODE",
		description = "Enabled GHAMING MODE",
		func = function(player)
			if HasFlagPersistent("fairmod_copimail_letter") == false then
				GamePrintImportant("This power is too great for you, young hämis.","Come back when you have recieved the dark lord's mail.")
				GamePrint("This power is too great for you, young hämis.")
				GamePrint("Come back when you have recieved the dark lord's mail.")
				LoadGameEffectEntityTo( player, "mods/noita.fairmod/files/content/cheats/misc/polymorph_hamis.xml" )
			else
				if EntityHasTag(player, "no_hamis_bullet") then return end
				EntityAddTag(player, "no_hamis_bullet")
				local comps_to_edit = {
					AudioComponent = {
						["file"] = "data/audio/Desktop/animals.bank",
						["event_root"] = "animals/longleg",
					},
					CharacterDataComponent = {
						["collision_aabb_min_x"] = -2,
						["collision_aabb_max_x"] = 2,
						["collision_aabb_min_y"] = -6,
						["collision_aabb_max_y"] = -3,
						["mass"] = 0.4,
						["buoyancy_check_offset_y"] = -6,
						["fly_recharge_spd"] = 0.4,
						["fly_recharge_spd_ground"] = 6,
						["fly_time_max"] = 3,
						["flying_in_air_wait_frames"] = 44,
						["flying_needs_recharge"] = false,
						["flying_recharge_removal_frames"] = 8,
						["platforming_type"] = 2,
						["send_transform_update_message"] = false,
					},
					CharacterPlatformingComponent = {
						["accel_x"] = 0.3,
						["fly_smooth_y"] = true,
						["fly_speed_change_spd"] = 1,
						["fly_speed_max_down"] = 90,
						["fly_speed_max_up"] = 90,
						["fly_speed_mult"] = 50,
						["fly_velocity_x"] = 26.8325,
						["jump_velocity_x"] = 500,
						["jump_velocity_y"] = -300,
						["pixel_gravity"] = 600,
						["run_animation_velocity_switching_enabled"] = true,
						["run_animation_velocity_switching_threshold"] = 50,
						["run_velocity"] = 2500,
						["turning_buffer"] = 0.1,
						["velocity_min_x"] = -50,
						["velocity_min_y"] = -500,
						["velocity_max_x"] = 50,
						["velocity_max_y"] = 500,
					},
					DamageModelComponent = {
						["invincibility_frames"] = 999999,
						["wait_for_kill_flag_on_death"] = true,
						["mFireProbability"] = 0,
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
					},
				}

				local x, y, r, sx, sy = EntityGetTransform(player)
				LoadRagdoll("data/ragdolls/player/filenames.txt", x, y - 10, "meat", sx, 0, -1)

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
					script_source_file = "mods/noita.fairmod/files/content/cheats/misc/godmode.lua",
				})
				EntityAddComponent2(player, "LuaComponent", {
					script_kick = "mods/noita.fairmod/files/content/cheats/misc/hamartial_arts.lua",
					execute_every_n_frame = -1,
				})

				local invuln = EntityCreateNew("invulnerability_GHAMIS")
				EntityAddChild(player, invuln)
				EntityAddComponent2(invuln, "GameEffectComponent", {
					effect = "PROTECTION_ALL",
					exclusivity_group = 0,
					frames = -1,
				})
				EntityAddComponent2(invuln, "GameEffectComponent", {
					effect = "RESPAWN",
					exclusivity_group = 0,
					frames = -1,
				})
				EntityAddComponent2(invuln, "GameEffectComponent", {
					effect = "SAVING_GRACE",
					exclusivity_group = 0,
					frames = -1,
				})
				EntityAddComponent2(invuln, "GameEffectComponent", {
					effect = "REMOVE_FOG_OF_WAR",
					exclusivity_group = 0,
					frames = -1,
				})
				EntityAddComponent2(invuln, "GameEffectComponent", {
					effect = "FASTER_LEVITATION",
					exclusivity_group = 0,
					frames = -1,
				})
				EntityAddComponent2(invuln, "GameEffectComponent", {
					effect = "MOVEMENT_FASTER_2X",
					exclusivity_group = 0,
					frames = -1,
				})
				EntityAddComponent2(invuln, "GameEffectComponent", {
					effect = "PROTECTION_POLYMORPH",
					exclusivity_group = 0,
					frames = -1,
				})

				local particles = EntityAddComponent2(player, "ParticleEmitterComponent", {
					velocity_always_away_from_center = 100,
					direction_random_deg = 360,
					emitted_material_name = "spark_purple",
					x_pos_offset_min = -1,
					x_pos_offset_max = 1,
					y_pos_offset_min = -9,
					y_pos_offset_max = -7,
					x_vel_min = 0,
					x_vel_max = 0,
					y_vel_min = -50,
					y_vel_max = -10,
					count_min = 10,
					count_max = 50,
					lifetime_min = 0.10,
					lifetime_max = 0.20,
					airflow_force = 0.1,
					airflow_time = 0.1,
					airflow_scale = 0.25,
					is_trail = false,
					create_real_particles = false,
					emit_cosmetic_particles = true,
					render_ultrabright = false,
					render_on_grid = true,
					emission_interval_min_frames = 1,
					emission_interval_max_frames = 1,
					fade_based_on_lifetime = false,
					is_emitting = true,
					draw_as_long = true,
				})

				ComponentSetValue2(particles, "gravity", 0, 100)
				ComponentSetValue2(particles, "offset", 0, 5)
				ComponentSetValue2(particles, "area_circle_radius", 0, 5)

				EntityAddComponent2(player, "AudioLoopComponent", {
					_tags = "music",
					file = "mods/noita.fairmod/fairmod.bank",
					event_name = ModSettingGet("noita.fairmod.streamer_mode") and "godhamis/loop_streamer"
						or "godhamis/loop",
					auto_play = true,
				})
			end
		end,
	},
	{
		code = "ahundredsnailsplease",
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

				if not hit then
					EntityLoad("mods/noita.fairmod/files/content/immortal_snail/entities/snail.xml", target_x, target_y)
				end
			end
		end,
	},
	{
		code = "snail",
		name = "snail",
		description = "shelled gastropod moment",
		func = function(player)
			local x, y = EntityGetTransform(player)

			-- get a random angle radian
			local angle = math.rad(Random(0, 360))
			-- get a random direction vector
			local dx = math.cos(angle)
			local dy = math.sin(angle)

			local distance = Random(100, 250)

			local target_x = x + (dx * distance)
			local target_y = y + (dy * distance)

			local hit = RaytracePlatforms(target_x, target_y, target_x, target_y - 5)

			if not hit then
				EntityLoad("mods/noita.fairmod/files/content/immortal_snail/entities/snail.xml", target_x, target_y)
			end
	
		end,
	},
	{
		code = "dingus",
		name = "Dingus",
		description = "He looks so polite!!",
		func = function(player)
			local x, y = EntityGetTransform(player)

			EntityLoad("mods/noita.fairmod/files/content/dingus/dingus.xml", x, y)
		end,
	},
	{
		code = "tacobell",
		name = "Tacobell",
		description = "You now have infinite shit and piss, enjoy.",
		func = function(player)
			GameAddFlagRun("tacobell_mode")
		end,
	},
	{
		code = "noclip",
		name = "Noclip",
		description = "You idiot, what did you think was gonna happen",
		func = function(player)
			EntityApplyTransform(player, markers.noclip.x + GetParallelWorldPosition(EntityGetTransform(player))*BiomeMapGetSize()*512, markers.noclip.y)
		end,
	},
	{
		code = "gamba",
		name = "Gamba",
		description = "All I have is scratch tickets!",
		func = function(player)
			local x, y = EntityGetTransform(player)
			EntityLoad("mods/noita.fairmod/files/content/gamblecore/scratch_ticket/scratch_ticket.xml", x, y)
		end,
	},
	{
		code = "haveanygamesonyourphone",
		name = "kbidhbny",
		description = "nokia get",
		func = function(player)
			local x, y = EntityGetTransform(player)
			EntityLoad("mods/noita.fairmod/files/content/payphone/entities/nokia/nokia.xml", x, y)
		end,
	},
	{
		code = "secondamendment",
		name = "Second Amendment",
		description = "Oh, I'm Sorry, I Thought This Was America.",
		decoration = "mods/noita.fairmod/files/content/immortal_snail/gun/ui_gfx/decoration/twin.png",
		func = function(player)
			local x, y = EntityGetTransform(player)
			EntityLoad("mods/noita.fairmod/files/content/immortal_snail/gun/entities/items/glock.xml", x, y)
		end,
	},
	{
		code = "holyshitsomaprimewarframe",
		name = "Look at them, they come to this place when they know they are not pure.",
		description = "Tenno use the keys, but they are mere trespassers. Only I, Vor, know the true power of the Void. I was cut in half, destroyed, but through it's Janus Key, the Void called to me.",
		decoration = "mods/noita.fairmod/files/content/immortal_snail/gun/ui_gfx/decoration/twin.png",
		func = function(player)
			local x, y = EntityGetTransform(player)
			EntityLoad("mods/noita.fairmod/files/content/immortal_snail/gun/entities/soma/soma.xml", x, y)
		end,
	},
	{
		code = "snoopdogg",
		name = "Snoop Dogg",
		description = "La-da-da-da-dah It's the motherfuckin' D-O-double-G (Snoop Dogg!)",
		func = function(player)
			GameAddFlagRun("fairmod_smokedogg_spawned")
			local smokedogg = EntityLoad("mods/noita.fairmod/files/content/smokedogg/smokedogg.xml")

			EntityAddComponent2(smokedogg, "AudioLoopComponent", {
				file = "mods/noita.fairmod/fairmod.bank",
				event_name = ModSettingGet("noita.fairmod.streamer_mode") and "smokedogg/loop_streamer"
					or "smokedogg/loop",
				auto_play = true,
			})
		end,
	},
	{
		code = function()
			return StatsGetValue("world_seed") or "12345"
		end,
		name = "World Reincarnation",
		description = "The world has been regenerated with a new seed.",
		func = function(player)
			local x, y = EntityGetTransform(player)

			SetRandomSeed(x, y + GameGetFrameNum())

			local seed = Random(1, 2147483646) + Random(1, 2147483646)
			print("New seed: " .. seed)

			SetWorldSeed(seed)

			BiomeMapLoad_KeepPlayer(MagicNumbersGetValue("BIOME_MAP"), "data/biome/_pixel_scenes")
		end,
	},
	{
		code = "userk",
		not_cheat = true,
		func = function()
			print("UserK")
			GamePrint("UserK")
			GamePrintImportant("UserK", "UserK")
		end,
	},
	{
		code = "/kill",
		name = "Ouch!",
		description = "Player fell out of the world.",
		func = function(player)
			EntityInflictDamage( player, 9999999999999999999999999, "DAMAGE_PHYSICS_BODY_DAMAGED", "yuor a looser", "DISINTEGRATED", 0, 0 )
			EntityKill(player)
		end,
	},
	{
		code = "boobs",
		func = function(player)
			EntityInflictDamage( player, 9999999999999999999999999, "DAMAGE_PHYSICS_BODY_DAMAGED", "yuor a looser", "DISINTEGRATED", 0, 0 )
			EntityKill(player)
		end,
	},
	{
		code = "ariral.boobs",
		func = function(player)
			EntityInflictDamage( player, 9999999999999999999999999, "DAMAGE_PHYSICS_BODY_DAMAGED", "yuor a looser", "DISINTEGRATED", 0, 0 )
			EntityKill(player)
		end,
	},
	{
		code = "sex",
		func = function(player)
			EntityInflictDamage( player, 9999999999999999999999999, "DAMAGE_PHYSICS_BODY_DAMAGED", "yuor a looser", "DISINTEGRATED", 0, 0 )
			EntityKill(player)
		end,
	},
	{
		code = "altf4",
		name = "oh",
		description = "okay bye-",
		func = function()
			EntityKill(GameGetWorldStateEntity()) --lmao
		end,
	},--[[sorry i fixed your bullshit :) -e]] --[[NOOOOOOOOOOOOOOOOOOOOOOOOOO THE ONE-LINER TABLE :devastated: -k]]
	--[[Fixed it again -c]] --[[W COPI -k]]
	{code="/spawn",name="/spawn",description="Teleporting in 3... 2... wait, you're already there!",func=function(a)local b=tonumber(MagicNumbersGetValue("DESIGN_PLAYER_START_POS_X"))local c=tonumber(MagicNumbersGetValue("DESIGN_PLAYER_START_POS_Y"))local d=GetParallelWorldPosition(EntityGetTransform(a))*BiomeMapGetSize()*512;EntityApplyTransform(a,b+d,c)end}
	,{
		code = "copi",
		func = function()
			GameAddFlagRun("COPI_IMMERSIVE_MIMICS")
			GamePrintImportant("THE CHEAT IS A MIMIC", "Setting Immersion: 100%!")
		end,
	},
	{
		code = "yourworldseed",
		not_cheat = true,
		func = function()
			GameAddFlagRun("YOUBLITHINGIDIOT")
		end,
	},
	{
		code = "london",
		name = "Aye bruv",
		description = "Oh, splendid! Another dreary cup of tea to elevate my utterly bland day—how terribly exciting!",
		func = function (player)
			EntityAddComponent2(player, "LuaComponent", {
				script_source_file="mods/noita.fairmod/files/content/cheats/london.lua",
				execute_every_n_frame=30
			})
			local state = EntityGetFirstComponent(GameGetWorldStateEntity(), "WorldStateComponent")
			ComponentSetValue2(state, "fog_target",		999)
			ComponentSetValue2(state, "fog",			999)
			ComponentSetValue2(state, "rain_target",	999)
			ComponentSetValue2(state, "rain",			999)
			ComponentSetValue2(state, "ENDING_HAPPINESS_HAPPENING", false) -- the world is miserable
			ComponentSetValue2(state, "ENDING_HAPPINESS_FRAMES", 0) -- the world is miserable
			ComponentSetValue2(state, "ENDING_HAPPINESS", false) -- the world is miserable
			-- I want to spawn a bunch of fuckers with knives but I'm lazy
		end
	},
	{
		code = "thebodies",
		name = "the bodies the bodies the bodies the bodies the bodies",
		description = "oh no",
		func = function(player)
			if not GameHasFlagRun("thebodies") then
				GameAddFlagRun("thebodies")
				ModTextFileSetContent(
					"data/thebodies.lua",
					[[local x, y, r, sx, sy = EntityGetTransform(GetUpdatedEntityID()); LoadRagdoll("data/ragdolls/player/filenames.txt", x, y - 10, "meat", sx, 0, -1)]]
				)
			end
			EntityAddComponent2(player, "LuaComponent", {
				script_source_file = "data/thebodies.lua",
				execute_every_n_frame = 30,
			})
		end,
	},
	{
		code = "genocide",
		name = "genocide",
		description = "we murderin",
		func = function(player)
			local x, y = EntityGetTransform(player)
			for k, v in ipairs(GetEnemiesInRadius(x, y, 256)) do
				EntityConvertToMaterial(v, "blood")
				EntityKill(v)
			end
		end,
	},
	{
		code = "wasdwasd",
		not_cheat = true,
		name = "oops!",
		description = "be more careful!",
		func = function(player)
			GameDropAllItems(player)
		end,
	},
	{
		code = "wdsawdsa",
		not_cheat = true,
		name = "oops!",
		description = "be more careful!",
		func = function(player)
			GameDropAllItems(player)
		end,
	},
	{
		code = "credits",
		not_cheat = true,
		func = function(player)
			if HasFlagPersistent("fairmod_unlocked_credits") then
				--yeah i didnt finish this
			else
				GamePrint("cheatcode function not found, printing error in logs...")
				print("pretend theres like, a lot of error logs here")
			end
		end,
	},
	{
		code = "chaos",
		name = "Chaos, Chaos!",
		description = "this is surely a good idea",
		func = function(player)
			local x, y = EntityGetTransform(player)
			EntityLoad("mods/noita.fairmod/files/content/chemical_horror/pandorium/sea_of_chaotic_pandorium.xml", x, y)
		end,
	},
	{
		code = "give4664",
		name = "Giving Noita 64 TNT",
		description = "Please don't blow up the map",
		func = function(player)
			local x, y = EntityGetTransform(player)
			math.randomseed(x + y)
			for k = 1, 64 do
				local opts = { "DYNAMITE", "TNTBOX", "TNTBOX_BIG" }
				CreateItemActionEntity(opts[math.random(1, 3)], x, y - 4)
			end
		end,
	},
	{
		code = "allsight",
		name = "All Seeing!",
		description = "i got tired of getting this manually while testing",
		func = function(player)
			perk_pickup( nil, player, "REMOVE_FOG_OF_WAR", true, false, true )
		end
	},
	{
		code = "scam",
		func = function()
			GameAddFlagRun("SPAWN_POPUP")
		end,
	},
	{
		code = "whereami",
		name = "Where am I?",
		description = "Must've sleep walked..",
		func = function(player)
			GameAddFlagRun("random_teleport_next")
			GameAddFlagRun("no_return")
		
			local x, y = EntityGetTransform(player)
		
			EntityLoad("mods/noita.fairmod/files/content/speedrun_door/portal_kolmi.xml", x, y)
		end
	},
	{
		code = "superchest",
		func = function(player)

			if GameHasFlagRun("chaos_run_active") then return end

			local x,y = EntityGetTransform(player)

			if HasFlagPersistent("fairmod_spawned_superchest") then
				GamePrintImportant("I said just once.", "May you be punished by torrents of chaos")
				local cid = EntityLoad( "mods/noita.fairmod/files/content/cheats/misc/essence_of_chaos.xml", x, y)
				EntityAddChild( player, cid )
				GameAddFlagRun("chaos_run_active")
				return
			end

			GamePrintImportant("Activated Cheat: Super Chest", "Alright, just this once")
			EntityLoad( "data/entities/items/pickup/chest_random_super.xml", x, y - 20)
			AddFlagPersistent("fairmod_spawned_superchest")
		end
	},
	{
		code = "gimmetinker",
		name = "gimme tinker",
		description = "no :)",
		func = function(player)
			perk_pickup( nil, player, "NO_WAND_EDITING", true, false, true )
		end
	},
	{
		code = "nodev",
		devmode = true,
		name = "Disable Developer Mode",
		description = "Happy testing o/",
		func = function()
			GameRemoveFlagRun("fairmod_developer_mode")
		end
	},
	{
		code = "radio",
		devmode = true,
		func = function(player)
			local x,y = EntityGetTransform(player)
			EntityLoad( "mods/noita.fairmod/files/content/backrooms/entities/radio.xml", x, y - 20)
		end
	},
	{
		code = "blacklight",
		devmode = true,
		func = function(player)
			local x,y = EntityGetTransform(player)
			EntityLoad( "mods/noita.fairmod/files/content/backrooms/props/ceiling_light_blacklight.xml", x, y - 20)
		end
	},
	{
		code = "protec",
		name = "protec",
		description = "missing description",
		func = function(player)
			local x,y = EntityGetTransform(player)
			LoadGameEffectEntityTo(player, "data/scripts/streaming_integration/entities/effect_protection_all.xml", x, y )
		end
	},
	{
		code = "printuserdiagnostic",
		not_cheat = true,
		func = function()
			GamePrint(tostring(ModSettingGet("fairmod.user_seed")))
		end
	},
	{
		code = "carrot",
		devmode = true,
		func = function(player)
			local x,y = EntityGetTransform(player)
			EntityLoad( "mods/noita.fairmod/files/content/better_world/carrot/entity.xml", x, y - 10)
		end
	},
	{
		code = "mainworld",
		devmode = true,
		func = function(player)
			local x,y = EntityGetTransform(player)
			EntityApplyTransform(player, x - (GetParallelWorldPosition(EntityGetTransform(player)) * BiomeMapGetSize() * 512), y)
		end
	},
	{
		code = "thirsty",
		name = "Thirsty",
		description = "Hydration is key!",
		func = function(player)
			local x,y = EntityGetTransform(player)
			EntityLoad("data/entities/projectiles/deck/sea_water.xml", x, y)
		end
	},
	{
		code = "hungryhungryportals",
		name = "Hungry Hungry Portals!",
		description = "Eat up!",
		func = function(player)
			local x, y = EntityGetTransform(player)

			for i = 1, 8 do
				for j = 1, 100 do
					-- get a random angle radian
					local angle = math.rad(Random(0, 360))
					-- get a random direction vector
					local dx = math.cos(angle)
					local dy = math.sin(angle)

					local distance = Random(100, 400)

					local target_x = x + (dx * distance)
					local target_y = y + (dy * distance)

					local hit = RaytracePlatforms(target_x, target_y, target_x, target_y - 5)
					if not hit then
						EntityLoad("mods/noita.fairmod/data/entities/animals/noita.fairmod_hm_portal_mimic.xml", target_x, target_y)
						break
					end
				end
			end
		end
	},
	{
		code = "gullible",
		func = function(player)
			ModSettingSet("noita.fairmod.popups", (ModSettingGet("noita.fairmod.popups") or "") .. "idiot,")
		end,
	},
}

--stylua: ignore end
