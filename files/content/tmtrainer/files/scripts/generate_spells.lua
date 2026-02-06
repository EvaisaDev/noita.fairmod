dofile("data/scripts/gun/gun_enums.lua")
dofile("data/scripts/gun/gun_actions.lua")
dofile("data/scripts/streaming_integration/event_utilities.lua")
dofile("data/scripts/streaming_integration/event_list.lua")

local filter = dofile_once("mods/noita.fairmod/files/content/tmtrainer/files/scripts/slur_filter.lua")

local action_info_map = {}

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

for _, action_type in ipairs(action_types) do
	action_info_map[action_type] = {}
end

for _, action in ipairs(actions) do
	local action_type = action.type
	if action_type ~= nil then
		if not action_info_map[action_type] then action_info_map[action_type] = {} end
		table.insert(action_info_map[action_type], action)
	end
end

local function get_random_action(action_type)
	local action_list = action_info_map[action_type]
	if not action_list or #action_list == 0 then return nil end
	return action_list[Random(1, #action_list)]
end

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

local function escape_string(s)
	if s == nil then return "nil" end
	s = tostring(s)
	s = s:gsub("\\", "\\\\")
	s = s:gsub("\"", "\\\"")
	s = s:gsub("\n", "\\n")
	s = s:gsub("\r", "\\r")
	s = s:gsub("\t", "\\t")
	return "\"" .. s .. "\""
end

local function generate_image(index, original_sprite, was_first)
	local corrupted_sprite = "mods/noita.fairmod/files/content/tmtrainer/files/spell_icons/" .. index .. ".png"

	if not ModImageDoesExist(original_sprite) or not ModImageDoesExist(corrupted_sprite) then
		return
	end
	
	if ModImageWhoSetContent(original_sprite) == "" or ModImageWhoSetContent(corrupted_sprite) == "" then
		return
	end

	local original_sprite_id, original_sprite_width, original_sprite_height = ModImageIdFromFilename(original_sprite)
	local corrupted_sprite_id, corrupted_sprite_width, corrupted_sprite_height = ModImageIdFromFilename(corrupted_sprite)

	if original_sprite_width == nil or original_sprite_height == nil or corrupted_sprite_width == nil or corrupted_sprite_height == nil then
		return
	end

	if was_first then
		for i = 0, corrupted_sprite_width - 1 do
			for j = 0, corrupted_sprite_height - 1 do
				local color = ModImageGetPixel(original_sprite_id, i, j)
				ModImageSetPixel(corrupted_sprite_id, i, j, color)
			end
		end
	else
		local guaranteed_part_count = 3
		local guaranteed_parts = {}
		local indexes_available = {}
		for i = 0, original_sprite_width - 1 do
			table.insert(indexes_available, i)
		end

		for i = 1, guaranteed_part_count do
			if #indexes_available > 0 then
				local idx = Random(1, #indexes_available)
				guaranteed_parts[indexes_available[idx]] = true
				table.remove(indexes_available, idx)
			end
		end

		for i = 0, original_sprite_width - 1 do
			if Random(0, 100) < 30 or guaranteed_parts[i] then
				for j = 0, original_sprite_height - 1 do
					local color = ModImageGetPixel(original_sprite_id, i, j)
					ModImageSetPixel(corrupted_sprite_id, i, j, color)
				end
			end
		end
	end
end

local world_seed = tonumber(StatsGetValue("world_seed")) or 1
local TMTRAINER_INDEX = 0

SetRandomSeed(TMTRAINER_INDEX, 1)

local output = {}

table.insert(output, [[
dofile_once("data/scripts/streaming_integration/event_list.lua")
dofile_once("data/scripts/streaming_integration/alt_event_utils.lua")

local _tmt_recursion_depth = 0
local _tmt_max_recursion = 10

local function _tmt_get_action_by_id(action_id)
	for _, action in ipairs(actions) do
		if action.id == action_id and not action.tm_trainer then
			return action
		end
	end
	return nil
end
]])

local action_func_body = [[
		if _tmt_recursion_depth >= _tmt_max_recursion then return end
		_tmt_recursion_depth = _tmt_recursion_depth + 1
		local orig_add_proj = add_projectile
		local orig_add_proj_timer = add_projectile_trigger_timer
		local orig_add_proj_hit = add_projectile_trigger_hit_world
		local orig_add_proj_death = add_projectile_trigger_death
		local has_proj = nil
		local function int_add_proj(ef, ...)
			if not has_proj or has_proj == ef then has_proj = ef; orig_add_proj(ef, ...) else c.extra_entities = c.extra_entities .. ef .. "," end
		end
		local function int_add_proj_timer(ef, ...)
			if not has_proj or has_proj == ef then has_proj = ef; orig_add_proj_timer(ef, ...) else c.extra_entities = c.extra_entities .. ef .. "," end
		end
		local function int_add_proj_hit(ef, ...)
			if not has_proj or has_proj == ef then has_proj = ef; orig_add_proj_hit(ef, ...) else c.extra_entities = c.extra_entities .. ef .. "," end
		end
		local function int_add_proj_death(ef, ...)
			if not has_proj or has_proj == ef then has_proj = ef; orig_add_proj_death(ef, ...) else c.extra_entities = c.extra_entities .. ef .. "," end
		end
		local env = {add_projectile=int_add_proj, add_projectile_trigger_timer=int_add_proj_timer, add_projectile_trigger_hit_world=int_add_proj_hit, add_projectile_trigger_death=int_add_proj_death}
		setmetatable(env, {__index = _G})
		local seed_off = 1
		for _, aid in ipairs(_action_ids) do
			local act = _tmt_get_action_by_id(aid)
			if act and act.action then
				setfenv(act.action, env)
				seed_off = seed_off + 1
				SetRandomSeed(_idx, seed_off)
				act.action(recursion_level, iteration)
			end
		end
		c.extra_entities = c.extra_entities .. "mods/noita.fairmod/files/content/tmtrainer/files/entities/spawn.xml,"
		if not reflecting then
			for _, eid in ipairs(_twitch_ids) do
				seed_off = seed_off + 1
				SetRandomSeed(_idx, seed_off)
				local caster = EntityGetRootEntity(GetUpdatedEntityID())
				if EntityHasTag(caster, "player_unit") or EntityHasTag(caster, "polymorphed_player") then _streaming_run_event(eid) end
			end
		end
		_tmt_recursion_depth = _tmt_recursion_depth - 1
]]

for action_type, action_list in pairs(action_info_map) do
	for _ = 1, #action_list do
		local seed_offset = 1
		
		local added_action_ids = {}
		local twitch_event_ids = {}
		
		local primary_action = get_random_action(action_type)
		if primary_action then 
			table.insert(added_action_ids, primary_action.id)
		end

		SetRandomSeed(TMTRAINER_INDEX, seed_offset)

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
				if streaming_events and #streaming_events > 0 then
					local twitch_event = streaming_events[Random(1, #streaming_events)]
					if twitch_event then table.insert(twitch_event_ids, twitch_event.id) end
				end
			else
				local action_info = get_random_action(mix_type)
				if action_info then table.insert(added_action_ids, action_info.id) end
			end
		end

		local name_parts = {}
		local description_parts = {}
		local mana = 0
		local max_uses = -1
		local price = 0
		local custom_xml_file = nil
		local recursive = false
		local ai_never_uses = false

		for i, action_id in ipairs(added_action_ids) do
			local added_action = nil
			for _, a in ipairs(actions) do
				if a.id == action_id then
					added_action = a
					break
				end
			end
			
			if added_action then
				if string.sub(action_id, 1, 7) ~= "RANDOM_" then
					if added_action.ai_never_uses then ai_never_uses = true end
					if added_action.recursive then recursive = true end

					local added_name = GameTextGetTranslatedOrNot(added_action.name) or ""
					local added_description = GameTextGetTranslatedOrNot(added_action.description) or ""

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

					try_update_name(Random(4, 8), 0)
					try_update_description(Random(8, 14), 0)

					mana = mana + (added_action.mana or 0)
					if i > 1 then mana = mana / 2 end

					if added_action.max_uses and added_action.max_uses ~= -1 then
						if max_uses == -1 then
							max_uses = added_action.max_uses
						else
							max_uses = max_uses + added_action.max_uses
						end
					end

					price = price + (added_action.price or 0)
					if i > 1 then price = price / 2 end

					if added_action.custom_xml_file and added_action.custom_xml_file ~= "" and (i == 1 or Random(0, 100) > 50 or not custom_xml_file) then
						custom_xml_file = added_action.custom_xml_file
					end
					
					if added_action.sprite and string.sub(added_action.sprite, -4) == ".png" then
						generate_image(TMTRAINER_INDEX, added_action.sprite, i == 1)
					end
				end
			end
		end

		for _, twitch_event_id in ipairs(twitch_event_ids) do
			if streaming_events then
				for _, te in ipairs(streaming_events) do
					if te.id == twitch_event_id then
						local added_name = GameTextGetTranslatedOrNot(te.ui_name) or ""
						local added_description = GameTextGetTranslatedOrNot(te.ui_description) or ""
						table.insert(name_parts, get_random_chunk(added_name, 6))
						table.insert(description_parts, get_random_chunk(added_description, 10))
						break
					end
				end
			end
		end

		local name = table.concat(name_parts)
		local description = table.concat(description_parts)

		local action_ids_parts = {"{"}
		for i, id in ipairs(added_action_ids) do
			table.insert(action_ids_parts, escape_string(id))
			if i < #added_action_ids then table.insert(action_ids_parts, ", ") end
		end
		table.insert(action_ids_parts, "}")
		local action_ids_str = table.concat(action_ids_parts)

		local twitch_ids_parts = {"{"}
		for i, id in ipairs(twitch_event_ids) do
			table.insert(twitch_ids_parts, escape_string(id))
			if i < #twitch_event_ids then table.insert(twitch_ids_parts, ", ") end
		end
		table.insert(twitch_ids_parts, "}")
		local twitch_ids_str = table.concat(twitch_ids_parts)

		local spell = {
			"table.insert(actions, {\n",
			"\tid = \"TMTRAINER_", tostring(TMTRAINER_INDEX), "\",\n",
			"\tspawn_requires_flag = \"tmt_do_not_spawn_lmao\",\n",
			"\tname = ", escape_string(name), ",\n",
			"\tdescription = ", escape_string(description), ",\n",
			"\tsprite = \"mods/noita.fairmod/files/content/tmtrainer/files/spell_icons/", tostring(TMTRAINER_INDEX), ".png\",\n",
			"\ttype = ", tostring(action_type), ",\n",
			"\tspawn_level = \"0,0,0,0,0,0,0,0\",\n",
			"\tspawn_probability = \"0,0,0,0,0,0,0,0\",\n",
			"\tprice = ", tostring(price), ",\n",
			"\tmana = ", tostring(mana), ",\n",
			"\tmax_uses = ", tostring(max_uses), ",\n",
			"\tai_never_uses = ", tostring(ai_never_uses), ",\n",
			"\trecursive = ", tostring(recursive), ",\n",
			"\tcustom_xml_file = ", escape_string(custom_xml_file), ",\n",
			"\ttm_trainer = true,\n",
			"\taction = function(recursion_level, iteration)\n",
			"\t\tlocal _action_ids = ", action_ids_str, "\n",
			"\t\tlocal _twitch_ids = ", twitch_ids_str, "\n",
			"\t\tlocal _idx = ", tostring(TMTRAINER_INDEX), "\n",
			action_func_body,
			"\tend,\n",
			"})\n\n",
		}
		table.insert(output, table.concat(spell))

		TMTRAINER_INDEX = TMTRAINER_INDEX + 1
	end
end

ModTextFileSetContent("mods/noita.fairmod/files/content/tmtrainer/files/generated/spells.lua", table.concat(output))
print("TMTRAINER: Generated " .. TMTRAINER_INDEX .. " spells")
