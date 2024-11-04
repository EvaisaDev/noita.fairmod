-- Load required scripts
dofile("data/scripts/streaming_integration/alt_event_utils.lua")
dofile("data/scripts/streaming_integration/event_list.lua")
dofile("mods/noita.fairmod/files/content/tmtrainer/files/scripts/icon_list.lua")

-- Initialize action_info_map if it doesn't exist
local action_info_map = action_info_map or {}

if next(action_info_map) == nil then
	-- Define the list of action types
	local action_types = {
		ACTION_TYPE_PROJECTILE,
		ACTION_TYPE_STATIC_PROJECTILE,
		ACTION_TYPE_MODIFIER,
		ACTION_TYPE_DRAW_MANY,
		ACTION_TYPE_MATERIAL,
		ACTION_TYPE_OTHER,
		ACTION_TYPE_UTILITY,
		ACTION_TYPE_PASSIVE,
	}

	-- Initialize action_info_map with empty tables for each action type
	for _, action_type in ipairs(action_types) do
		action_info_map[action_type] = {}
	end

	-- Populate action_info_map with actions grouped by type
	for _, action in ipairs(actions) do
		local action_type = action.type
		if not action_info_map[action_type] then action_info_map[action_type] = {} end
		table.insert(action_info_map[action_type], action)
	end
end

-- Function to retrieve a random action of a given type
local function get_random_action(action_type)
	local action_list = action_info_map[action_type]
	if not action_list or #action_list == 0 then return nil end
	return action_list[Random(1, #action_list)]
end

-- Function to get a random substring of specified size
local function get_random_chunk(input, size)
	if not input or input == "" then return "" end
	local len = string.len(input)
	if len <= size then
		return input
	else
		local start_pos = Random(1, len - size + 1)
		return string.sub(input, start_pos, start_pos + size - 1)
	end
end

local function generate_image(index, original_sprite, was_first)
	local corrupted_sprite = "mods/noita.fairmod/files/content/tmtrainer/files/spell_icons/" .. index .. ".png"

	-- Randomly overlay parts of the original sprite onto the corrupted sprite

	local original_sprite_id, original_sprite_width, original_sprite_height = ModImageIdFromFilename(original_sprite)
	local corrupted_sprite_id, corrupted_sprite_width, corrupted_sprite_height = ModImageIdFromFilename(corrupted_sprite)

	if was_first then
		for i = 0, corrupted_sprite_width - 1 do
			for j = 0, corrupted_sprite_height - 1 do
				local color = ModImageGetPixel(original_sprite_id, i, j)
				ModImageSetPixel(corrupted_sprite_id, i, j, color)
			end
		end
	else
		-- Add random lines
		for i = 0, corrupted_sprite_width - 1 do
			if Random(0, 100) < 30 then
				for j = 0, corrupted_sprite_height - 1 do
					local color = ModImageGetPixel(original_sprite_id, i, j)
					ModImageSetPixel(corrupted_sprite_id, i, j, color)
				end
			end
		end
	end
end

-- Main script execution
local TMTRAINER_INDEX = 0
local filter = dofile_once("mods/noita.fairmod/files/content/tmtrainer/files/scripts/slur_filter.lua")
-- Function to create a new TMTRAINER action
local function create_tmtrainer_action(action_type, index)
	local added_actions = {}
	local twitch_events = {}
	local seed_offset = 1

	-- Always add an action of the current action_type
	local primary_action = get_random_action(action_type)
	if primary_action then table.insert(added_actions, primary_action) end

	SetRandomSeed(TMTRAINER_INDEX, seed_offset)

	-- Randomly add 1 to 3 more actions or twitch events
	local num_additional = Random(1, 3)
	for _ = 1, num_additional do
		local mix_types = {
			ACTION_TYPE_MODIFIER,
			ACTION_TYPE_DRAW_MANY,
			ACTION_TYPE_MATERIAL,
			ACTION_TYPE_UTILITY,
			ACTION_TYPE_PASSIVE,
			ACTION_TYPE_OTHER,
			action_type,
			"twitch_event",
		}

		local mix_type = mix_types[Random(1, #mix_types)]
		if mix_type == "twitch_event" then
			local twitch_event = streaming_events[Random(1, #streaming_events)]
			if twitch_event then table.insert(twitch_events, twitch_event) end
		else
			local action_info = get_random_action(mix_type)
			if action_info then table.insert(added_actions, action_info) end
		end
	end

	-- Variables to build the new action
	local name_parts = {}
	local description_parts = {}
	local functions = {}
	local mana = 0
	local max_uses = -1
	local price = 0
	local spawn_level = ""
	local spawn_probability = ""
	local sprite = "mods/noita.fairmod/files/content/tmtrainer/files/spell_icons/" .. index .. ".png"
	local custom_xml_file = nil
	local recursive = false
	local ai_never_uses = false

	for i, added_action in ipairs(added_actions) do
		local id = added_action.id

		-- if id starts with RANDOM_ we ignore it
		if string.sub(id, 1, 7) == "RANDOM_" then goto continue end

		if(added_action.ai_never_uses) then ai_never_uses = true end
		if(added_action.recursive) then recursive = true end

		if not reflecting then
			local added_name = GameTextGetTranslatedOrNot(added_action.name) or ""
			local added_description = GameTextGetTranslatedOrNot(added_action.description) or ""

			-- Build name and description from random chunks
			local max_iterations = 30
			local function try_update_name(chars, iteration)
				iteration = iteration or 0

				table.insert(name_parts, get_random_chunk(added_name, chars))

				if filter.contains_slur(table.concat(name_parts)) then
					table.remove(name_parts)
					if iteration < max_iterations and (chars - 1 > 0) then try_update_name(chars - 1, iteration + 1) end
				end
			end

			local function try_update_description(chars, iteration)
				iteration = iteration or 0

				table.insert(description_parts, get_random_chunk(added_description, chars))

				if filter.contains_slur(table.concat(description_parts)) then
					table.remove(description_parts)
					if iteration < max_iterations and (chars - 1 > 0) then try_update_description(chars - 1, iteration + 1) end
				end
			end

			try_update_name(4, 0)
			try_update_description(10, 0)
		end

		-- Collect action functions
		table.insert(functions, added_action.action)

		-- Accumulate mana cost
		mana = mana + (added_action.mana or 0)
		if i > 1 then mana = mana / 2 end

		-- Accumulate max uses
		if added_action.max_uses and added_action.max_uses ~= -1 then
			if max_uses == -1 then
				max_uses = added_action.max_uses
			else
				max_uses = max_uses + added_action.max_uses
			end
		end

		-- Accumulate price
		price = price + (added_action.price or 0)
		if i > 1 then price = price / 2 end

		-- Use spawn_level and spawn_probability from the first action
		if i == 1 then
			spawn_level = added_action.spawn_level or ""
			spawn_probability = added_action.spawn_probability or ""
		end

		generate_image(index, added_action.sprite, i == 1)

		-- Determine custom_xml_file
		if added_action.custom_xml_file and added_action.custom_xml_file ~= "" and (i == 1 or Random(0, 100) > 50 or not custom_xml_file) then
			custom_xml_file = added_action.custom_xml_file
		end

		::continue::
	end

	for i, twitch_event in ipairs(twitch_events) do
		local added_name = GameTextGetTranslatedOrNot(twitch_event.ui_name) or ""
		local added_description = GameTextGetTranslatedOrNot(twitch_event.ui_description) or ""

		-- Build name and description from random chunks
		table.insert(name_parts, get_random_chunk(added_name, 6))
		table.insert(description_parts, get_random_chunk(added_description, 10))
	end

	-- Combine name and description parts
	local name = table.concat(name_parts)
	local description = table.concat(description_parts)

	-- Define the action function
	local function action_function(recursion_level, iteration)
		-- Store original projectile functions in local variables
		local original_add_projectile = add_projectile
		local original_add_projectile_trigger_timer = add_projectile_trigger_timer
		local original_add_projectile_trigger_hit_world = add_projectile_trigger_hit_world
		local original_add_projectile_trigger_death = add_projectile_trigger_death

		local has_projectile = nil

		-- Define intercepted functions
		local function intercepted_add_projectile(entity_filename, ...)
			if not has_projectile or has_projectile == entity_filename then
				has_projectile = entity_filename
				original_add_projectile(entity_filename, ...)
			else
				c.extra_entities = c.extra_entities .. entity_filename .. ","
			end
		end

		local function intercepted_add_projectile_trigger_timer(entity_filename, ...)
			if not has_projectile or has_projectile == entity_filename then
				has_projectile = entity_filename
				original_add_projectile_trigger_timer(entity_filename, ...)
			else
				c.extra_entities = c.extra_entities .. entity_filename .. ","
			end
		end

		local function intercepted_add_projectile_trigger_hit_world(entity_filename, ...)
			if not has_projectile or has_projectile == entity_filename then
				has_projectile = entity_filename
				original_add_projectile_trigger_hit_world(entity_filename, ...)
			else
				c.extra_entities = c.extra_entities .. entity_filename .. ","
			end
		end

		local function intercepted_add_projectile_trigger_death(entity_filename, ...)
			if not has_projectile or has_projectile == entity_filename then
				has_projectile = entity_filename
				original_add_projectile_trigger_death(entity_filename, ...)
			else
				c.extra_entities = c.extra_entities .. entity_filename .. ","
			end
		end

		-- Create a new environment that includes our intercepted functions
		local env = {
			add_projectile = intercepted_add_projectile,
			add_projectile_trigger_timer = intercepted_add_projectile_trigger_timer,
			add_projectile_trigger_hit_world = intercepted_add_projectile_trigger_hit_world,
			add_projectile_trigger_death = intercepted_add_projectile_trigger_death,
		}

		-- Set the metatable's __index to the global environment
		setmetatable(env, { __index = _G })

		-- Now, execute each function in the 'functions' table within the new environment
		for i, func in ipairs(functions) do
			if func then
				setfenv(func, env)

				seed_offset = seed_offset + 1
				SetRandomSeed(TMTRAINER_INDEX, seed_offset)

				func(recursion_level, iteration)
			end
		end

		-- Add extra entities
		c.extra_entities = c.extra_entities .. "mods/noita.fairmod/files/content/tmtrainer/files/entities/spawn.xml,"

		-- Run twitch events if not reflecting
		if not reflecting then
			for _, twitch_event in ipairs(twitch_events) do
				seed_offset = seed_offset + 1
				SetRandomSeed(TMTRAINER_INDEX, seed_offset)
				local caster = EntityGetRootEntity(GetUpdatedEntityID())
				if EntityHasTag(caster, "player_unit") or EntityHasTag(caster, "polymorphed_player") then _streaming_run_event(twitch_event.id) end
			end
		end
	end

	-- Create the new action
	local new_action = {
		id = "TMTRAINER_" .. tostring(index),
		name = name,
		description = description,
		sprite = sprite,
		type = action_type,
		spawn_level = spawn_level,
		spawn_probability = spawn_probability,
		price = price,
		mana = mana,
		max_uses = max_uses,
		ai_never_uses = ai_never_uses,
		recursive = recursive,
		custom_xml_file = custom_xml_file,
		tm_trainer = true,
		action = function(recursion_level, iteration)
			action_function(recursion_level, iteration)
		end,
	}

	return new_action
end

SetRandomSeed(TMTRAINER_INDEX, 1)

-- Iterate over each action type and create new TMTRAINER actions
for action_type, action_list in pairs(action_info_map) do
	-- Ensure randomness is consistent

	for _ = 1, #action_list do
		if Random(1, 100) < 40 then
			local new_action = create_tmtrainer_action(action_type, TMTRAINER_INDEX)
			table.insert(actions, new_action)
			TMTRAINER_INDEX = TMTRAINER_INDEX + 1
		end
	end
end
