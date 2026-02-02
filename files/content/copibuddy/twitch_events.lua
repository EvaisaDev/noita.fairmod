local markers = dofile_once("mods/noita.fairmod/files/content/better_world/map_helper.lua")
return {
	{
		id = "event_scratch_ticket",
		name = "Scratch Ticket",
		description = "Free scratch-off!",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				EntityLoad("mods/noita.fairmod/files/content/gamblecore/scratch_ticket/scratch_ticket.xml", x, y - 20)
			end
		end,
	},
	{
		id = "event_eba_blessing",
		name = "Eba's Blessing",
		description = "I hope you like them I made them for you!!",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit") or {}
			if players[1] then
				local player = players[1]
				GameDestroyInventoryItems(player)

				local hm_visits = math.max(math.min(tonumber(GlobalsGetValue("HOLY_MOUNTAIN_VISITS", "0")) or 0, 6), 1)
				local x, y = EntityGetTransform(player)

				dofile("data/scripts/perks/perk.lua")

				local tmtrainer_perks = {}
				for i, v in ipairs(perk_list) do
					if string.sub(v.id, 1, 10) == "TMTRAINER_" then
						table.insert(tmtrainer_perks, v.id)
					end
				end

				for i = 1, 4 do
					local item = EntityLoad(
						"mods/noita.fairmod/files/content/payphone/entities/corrupted_wands/wand_level_0" .. tostring(hm_visits) .. ".xml",
						x + Random(-15, 15),
						y + Random(-15, 15)
					)
					GamePickUpInventoryItem(player, item, false)

					SetRandomSeed(GameGetFrameNum() + x + i, GameGetFrameNum() + y)
					if #tmtrainer_perks > 0 then
						local perk = perk_spawn(x + Random(-15, 15), y + Random(-15, 15), tmtrainer_perks[Random(1, #tmtrainer_perks)], true)
						perk_pickup(perk, player, "", false, false)
					end
				end
				GamePrintImportant("Eba's Blessing", "Your items have been... upgraded?")
			end
		end,
	},
	{
		id = "event_spawn_copi",
		name = "Spawn Copi",
		description = "Summon a friendly Copi",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				local copi = EntityLoad("mods/noita.fairmod/files/content/payphone/content/copi/copi_ghost.xml", x, y)
				EntityRemoveTag(copi, "enemy")
				EntityLoad("mods/noita.fairmod/files/content/copibuddy/sprites/poof.xml", x, y)
			end
		end,
	},
	{
		id = "event_nokia",
		name = "Nokia 3310",
		description = "Legendary durability",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				EntityLoad("mods/noita.fairmod/files/content/payphone/entities/nokia/nokia.xml", x, y - 20)
			end
		end,
	},
	{
		id = "event_hard_hat",
		name = "Hard Hat",
		description = "Safety first!",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/hard_hat/hard_hat.xml", x, y - 20)
			end
		end,
	},
	{
		id = "event_hampill",
		name = "Häm Pill",
		description = "Mystery medicine",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				EntityLoad("mods/noita.fairmod/files/content/mailbox/hampill/hampill.xml", x, y - 20)
			end
		end,
	},
	{
		id = "event_booklet",
		name = "READ THE MANUAL",
		description = "Read the fucking manual.",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				local items = EntityLoad("mods/noita.fairmod/files/content/instruction_booklet/booklet_entity/booklet.xml", x, y)
				GamePickUpInventoryItem(player, items, false)
			end
		end,
	},
	{
		id = "event_hamis_makeover",
		name = "Hämis Makeover",
		description = "Become one with the Hämis",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				LoadGameEffectEntityTo(players[1], "mods/noita.fairmod/files/content/cheats/misc/polymorph_hamis.xml")
			end
		end,
	},
	{
		id = "event_random_spell",
		name = "Random Spell",
		description = "A spell appears",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				dofile("data/scripts/gun/gun.lua")
				SetRandomSeed(GameGetFrameNum() + x, GameGetFrameNum() + y)
				local action_list = {}
				for _, v in ipairs(actions) do
					table.insert(action_list, v)
				end
				if #action_list > 0 then
					local result = action_list[Random(1, #action_list)]
					CreateItemActionEntity(result.id, x, y - 20)
				end
			end
		end,
	},
	{
		id = "event_random_potion",
		name = "Random Potion",
		description = "A mystery flask",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				SetRandomSeed(GameGetFrameNum() + x, GameGetFrameNum() + y)
				local level = math.max(1, math.min(7, Random(1, 7)))
				EntityLoad("data/entities/items/pickup/potion_random_material.xml", x, y - 20)
			end
		end,
	},
	{
		id = "event_spawn_hamis",
		name = "Hämis",
		description = "Spawn 3 Hämis",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				
				for i = 1, 3 do
					SetRandomSeed(GameGetFrameNum() + x + i, GameGetFrameNum() + y)
					local offset_x = Random(-50, 50)
					local offset_y = Random(-50, 50)
					EntityLoad("data/entities/animals/longleg.xml", x + offset_x, y + offset_y)
				end
			end
		end,
	},
	{
		id = "event_snowball",
		name = "Snowball",
		description = "I GOT YOU THIS SNOWBALL! FROM THE ANTIARCTIC!",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				EntityLoad("mods/noita.fairmod/files/content/snowman/snowball_item.xml", x, y - 20)
			end
		end,
	},
	{
		id = "event_spawn_copibuddy",
		name = "More copibuddies!",
		description = "You need more friends!",
		func = function(copibuddy)
			GameAddFlagRun("copibuddy")
		end,
	},
	{
		id = "event_spawn_dingus",
		name = "Dingus",
		description = "IT'S THE CAT!",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				EntityLoad("mods/noita.fairmod/files/content/dingus/dingus.xml", x, y - 20)
			end
		end,
	},
	{
		id = "event_everybody_loves_larpa",
		name = "Everybody loves larpa",
		description = "All projectiles become larpa",
		func = function(copibuddy)
			GameAddFlagRun("payphone_larpa")
			GamePrintImportant("Everybody loves larpa", "Your projectiles have been blessed")
		end,
	},
	{
		id = "event_teleport_random",
		name = "Free Vacation!",
		description = "Where will you go?",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				
				GameAddFlagRun("random_teleport_next")
				EntityLoad("mods/noita.fairmod/files/content/speedrun_door/portal_kolmi.xml", x, y)
			end
		end,
	},
	{
		id = "event_spawn_snail",
		name = "Immortal Snail",
		description = "It's coming for you...",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				
				SetRandomSeed(GameGetFrameNum() + x, GameGetFrameNum() + y)
				local angle = math.rad(Random(0, 360))
				local dx = math.cos(angle)
				local dy = math.sin(angle)
				local distance = Random(100, 250)
				
				local target_x = x + (dx * distance)
				local target_y = y + (dy * distance)
				
				EntityLoad("mods/noita.fairmod/files/content/immortal_snail/entities/snail.xml", target_x, target_y)
			end
		end,
	},
	{
		id = "event_spawn_radio",
		name = "Radio",
		description = "Tune in to your favorite station",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				EntityLoad("mods/noita.fairmod/files/content/backrooms/entities/radio.xml", x, y - 20)
			end
		end,
	},
	{
		id = "event_corrupted_wand",
		name = "Corrupted Wand",
		description = "Shady merchant special!",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				local hm_visits = math.max(math.min(tonumber(GlobalsGetValue("HOLY_MOUNTAIN_VISITS", "0")) or 0, 6), 1)
				EntityLoad("mods/noita.fairmod/files/content/payphone/entities/corrupted_wands/wand_level_0" .. tostring(hm_visits) .. ".xml", x, y - 20)
			end
		end,
	},
	{
		id = "event_bowling",
		name = "Bowling with Roman",
		description = "Let's go bowling!",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				EntityAddChild(player, EntityLoad("mods/noita.fairmod/files/content/payphone/content/bowling/bowling_timer.xml", x, y))
			end
		end,
	},
	{
		id = "event_100_snails",
		name = "100 Snails",
		description = "Additional snails.",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				
				for i = 1, 100 do
					SetRandomSeed(GameGetFrameNum() + x + i, GameGetFrameNum() + y + i)
					local angle = math.rad(Random(0, 360))
					local dx = math.cos(angle)
					local dy = math.sin(angle)
					local distance = Random(100, 250)
					
					local target_x = x + (dx * distance)
					local target_y = y + (dy * distance)
					
					EntityLoad("mods/noita.fairmod/files/content/immortal_snail/entities/snail.xml", target_x, target_y)
				end
			end
		end,
	},
	{
		id = "event_teleport_liminal",
		name = "Make it Liminal",
		description = "Teleport to backrooms",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				EntityApplyTransform(player, 1547, 14900)
			end
		end,
	},
	{
		id = "event_spawn_25_spells",
		name = "25 Random Spells",
		description = "Spell flood!",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				dofile("data/scripts/gun/gun.lua")
				for j = 1, 25 do
					SetRandomSeed(420 + j, 69 + j)
					local result = actions[Random(1, #actions)]
					CreateItemActionEntity(result.id, x + Random(-30, 30), y + Random(-30, 30))
				end
			end
		end,
	},
	{
		id = "event_tacobell",
		name = "Taco Bell",
		description = "Infinite shit and piss!",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				GameAddFlagRun("tacobell_mode")
				
				local timer = EntityCreateNew("tacobell_timer")
				EntityAddComponent2(timer, "LifetimeComponent", {
					lifetime = 60 * 60,
				})
				EntityAddComponent2(timer, "LuaComponent", {
					script_death = "mods/noita.fairmod/files/content/copibuddy/tacobell_remove.lua",
					execute_every_n_frame = -1,
				})
				EntityAddChild(player, timer)
			end
		end,
	},
	{
		id = "event_glock",
		name = "Second Amendment",
		description = "Oh, I'm Sorry, I Thought This Was America.",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				EntityLoad("mods/noita.fairmod/files/content/immortal_snail/gun/entities/items/glock.xml", x, y - 20)
			end
		end,
	},
	{
		id = "event_soma_prime",
		name = "Soma Prime",
		description = "Look at them, they come to this place...",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				EntityLoad("mods/noita.fairmod/files/content/immortal_snail/gun/entities/soma/soma.xml", x, y - 20)
			end
		end,
	},
	{
		id = "event_snoop_dogg",
		name = "Snoop Dogg",
		description = "La-da-da-da-dah!",
		func = function(copibuddy)
			GameAddFlagRun("fairmod_smokedogg_spawned")
			local smokedogg = EntityLoad("mods/noita.fairmod/files/content/smokedogg/smokedogg.xml")
			EntityAddComponent2(smokedogg, "AudioLoopComponent", {
				file = "mods/noita.fairmod/fairmod.bank",
				event_name = ModSettingGet("noita.fairmod.streamer_mode") and "smokedogg/loop_streamer" or "smokedogg/loop",
				auto_play = true,
			})
		end,
	},
	{
		id = "event_genocide",
		name = "Genocide",
		description = "Clear nearby enemies",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				for k, v in ipairs(EntityGetInRadiusWithTag(x, y, 256, "enemy") or {}) do
					EntityConvertToMaterial(v, "blood")
					EntityKill(v)
				end
			end
		end,
	},
	{
		id = "event_world_reincarnation",
		name = "World Reincarnation",
		description = "Regenerate the world with a new seed",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local x, y = EntityGetTransform(player)
				SetRandomSeed(x, y + GameGetFrameNum())
				local seed = Random(1, 2147483646) + Random(1, 2147483646)
				SetWorldSeed(seed)
				BiomeMapLoad_KeepPlayer(MagicNumbersGetValue("BIOME_MAP"), "data/biome/_pixel_scenes")
				GamePrintImportant("World Reincarnation", "New seed: " .. seed)
			end
		end,
	},
	{
		id = "event_spawn_to_start",
		name = "Teleport to Spawn",
		description = "Back to the beginning",
		func = function(copibuddy)
			local players = EntityGetWithTag("player_unit")
			if players[1] then
				local player = players[1]
				local spawn_x = tonumber(MagicNumbersGetValue("DESIGN_PLAYER_START_POS_X"))
				local spawn_y = tonumber(MagicNumbersGetValue("DESIGN_PLAYER_START_POS_Y"))
				local offset = GetParallelWorldPosition(EntityGetTransform(player)) * BiomeMapGetSize() * 512
				EntityApplyTransform(player, spawn_x + offset, spawn_y)
			end
		end,
	},
}
