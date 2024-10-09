dofile("data/scripts/streaming_integration/alt_event_utils.lua")
dofile("data/scripts/streaming_integration/event_list.lua")

action_info_map = action_info_map or nil

if (action_info_map == nil) then
	action_info_map = {
		{}, -- ACTION_TYPE_PROJECTILE
		{}, -- ACTION_TYPE_STATIC_PROJECTILE
		{}, -- ACTION_TYPE_MODIFIER
		{}, -- ACTION_TYPE_DRAW_MANY
		{}, -- ACTION_TYPE_MATERIAL
		{}, -- ACTION_TYPE_OTHER
		{}, -- ACTION_TYPE_UTILITY
		{}, -- ACTION_TYPE_PASSIVE
	}
	for i, v in ipairs(actions) do
		local action_type = v.type;
		table.insert(action_info_map[action_type + 1], v);
	end
end

local function get_action_info(action_type)
	local action_info = action_info_map[action_type + 1];
	if action_info == nil then
		return nil;
	end
	return action_info[Random(1, #action_info)];
end

dofile("mods/noita.fairmod/files/content/tmtrainer/files/scripts/icon_list.lua")
local TMTRAINER_SEED = StatsGetValue("world_seed")

TMTRAINER_INDEX = 0
for action_type, map in ipairs(action_info_map) do
	action_type = action_type - 1;
	SetRandomSeed(TMTRAINER_INDEX + TMTRAINER_SEED, TMTRAINER_INDEX + TMTRAINER_SEED)
	for _, action in ipairs(map) do
		local added_actions = {};
		local twitch_events = {};
		table.insert(added_actions, get_action_info(action_type))

		for i = 1, Random(1, 3) do

			local allowed_mix_types = {
				ACTION_TYPE_MODIFIER,
				ACTION_TYPE_DRAW_MANY,
				ACTION_TYPE_MATERIAL,
				ACTION_TYPE_UTILITY,
				ACTION_TYPE_PASSIVE,
				ACTION_TYPE_OTHER,
				action_type,
				"twitch_event" }

			local mix_type = allowed_mix_types[Random(1, #allowed_mix_types)];
			if (mix_type ~= "twitch_event") then
				table.insert(added_actions, get_action_info(mix_type));
			else
				local twitch_event = streaming_events[Random(1, #streaming_events)];
				table.insert(twitch_events, twitch_event);
			end
		end

		local name = ""
		local description = ""
		local functions = {}
		local mana = 0
		local max_uses = -1
		local price = 0
		local spawn_level = ""
		local spawn_probability = ""
		local sprite = ""
		local custom_xml_file = nil

		for i, added_action in ipairs(added_actions) do
			local added_name = GameTextGetTranslatedOrNot(added_action.name);
			-- select random part of X size from string, for example if size is 3, Firebolt > reb, Storm > sto, etc.
			local getRandomChunkOfSize = function(input, size)
				local len = string.len(input)
				local start = Random(1, len - size)
				return string.sub(input, start, start + size)
			end

			local name_part = getRandomChunkOfSize(added_name, 4)
			name = name .. name_part;

			table.insert(functions, added_action.action);
			mana = mana + (added_action.mana or 0);
			if (i ~= 1) then
				mana = mana / 2
			end
			if (added_action.max_uses ~= nil) then
				if (added_action.max_uses ~= -1 and max_uses == -1) then
					max_uses = added_action.max_uses;
				elseif (added_action.max_uses ~= -1) then
					max_uses = max_uses + added_action.max_uses;
				end
			end

			local added_description = GameTextGetTranslatedOrNot(added_action.description);
			local description_part = getRandomChunkOfSize(added_description, 10)
			description = description .. description_part;

			price = price + added_action.price;
			if (i ~= 1) then
				price = price / 2
			end

			if (i == 1) then
				spawn_level = added_action.spawn_level;
				spawn_probability = added_action.spawn_probability;
			end

			if (i == 1 or Random(0, 100) > 50) then
				sprite = "mods/noita.fairmod/files/content/tmtrainer/files/corruptions/" .. added_action.sprite;

				if (not icon_exists(action_icons, added_action.sprite)) then
					local random_sprite = action_icons[Random(1, #action_icons)]
					sprite = "mods/noita.fairmod/files/content/tmtrainer/files/corruptions/" .. random_sprite;
				end
			end

			if (added_action.custom_xml_file ~= nil and added_action.custom_xml_file ~= "" and (i == 1 or Random(0, 100) > 50 or custom_xml_file == nil)) then
				custom_xml_file = added_action.custom_xml_file;
			end

		end

		local has_projectile = nil

		local action_function = function(recursion_level, iteration)
			local tmtrainer_old_add_projectile = add_projectile
			local tmtrainer_old_add_projectile_trigger_timer = add_projectile_trigger_timer
			local tmtrainer_old_add_projectile_trigger_hit_world = add_projectile_trigger_hit_world
			local tmtrainer_old_add_projectile_trigger_death = add_projectile_trigger_death

			add_projectile = function(entity_filename)
				if (has_projectile == nil or has_projectile == entity_filename) then
					has_projectile = entity_filename
					tmtrainer_old_add_projectile(entity_filename)
				else
					c.extra_entities = c.extra_entities .. entity_filename .. ","
				end
			end

			add_projectile_trigger_timer = function(entity_filename, delay_frames, action_draw_count)
				if (has_projectile == nil or has_projectile == entity_filename) then
					has_projectile = entity_filename
					tmtrainer_old_add_projectile_trigger_timer(entity_filename, delay_frames, action_draw_count)
				else
					c.extra_entities = c.extra_entities .. entity_filename .. ","
				end
			end

			add_projectile_trigger_hit_world = function(entity_filename, action_draw_count)
				if (has_projectile == nil or has_projectile == entity_filename) then
					has_projectile = entity_filename
					tmtrainer_old_add_projectile_trigger_hit_world(entity_filename, action_draw_count)
				else
					c.extra_entities = c.extra_entities .. entity_filename .. ","
				end
			end

			add_projectile_trigger_death = function(entity_filename, action_draw_count)
				if (has_projectile == nil or has_projectile == entity_filename) then
					has_projectile = entity_filename
					tmtrainer_old_add_projectile_trigger_death(entity_filename, action_draw_count)
				else
					c.extra_entities = c.extra_entities .. entity_filename .. ","
				end
			end

			c.extra_entities = c.extra_entities .. "mods/noita.fairmod/files/content/tmtrainer/files/entities/spawn.xml,"

			for i, func in ipairs(functions) do
				func(recursion_level, iteration);
			end
			if (not reflecting) then
				for i, twitch_event in ipairs(twitch_events) do
					_streaming_run_event(twitch_event.id)
				end
			end

			add_projectile = tmtrainer_old_add_projectile
			add_projectile_trigger_timer = tmtrainer_old_add_projectile_trigger_timer
			add_projectile_trigger_hit_world = tmtrainer_old_add_projectile_trigger_hit_world
			add_projectile_trigger_death = tmtrainer_old_add_projectile_trigger_death
		end

		local new_action = {
			id = "TMTRAINER_" .. tostring(TMTRAINER_INDEX),
			name = name,
			description = description,
			sprite = sprite,
			type = action_type,
			spawn_level = spawn_level,
			spawn_probability = spawn_probability,
			price = price,
			mana = mana,
			tm_trainer = true,
			action = function(recursion_level, iteration)
				local success, err = pcall(action_function, recursion_level, iteration)
				if not success then
					print("TMTRAINER ERROR: " .. err)
				end
				return err
			end,
		}
		table.insert(actions, new_action);

		TMTRAINER_INDEX = TMTRAINER_INDEX + 1
	end
end
