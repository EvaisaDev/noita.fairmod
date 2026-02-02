dofile("data/scripts/perks/perk_list.lua")

local filter = dofile_once("mods/noita.fairmod/files/content/tmtrainer/files/scripts/slur_filter.lua")

local perk_pool = {}
for _, perk in ipairs(perk_list) do
	if not perk.not_in_default_perk_pool and not perk.no_tmt then 
		table.insert(perk_pool, perk) 
	end
end

local function get_random_perk()
	if #perk_pool == 0 then return nil end
	return perk_pool[Random(1, #perk_pool)]
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

local function generate_icon(index, original_icon, is_first, icon_type)
	local icon_dir = "mods/noita.fairmod/files/content/tmtrainer/files/perk_icons/"
	local new_icon_path = icon_dir .. icon_type .. "_" .. index .. ".png"

	if not ModImageDoesExist(original_icon) or not ModImageDoesExist(new_icon_path) then
		return
	end
	
	if ModImageWhoSetContent(original_icon) == "" or ModImageWhoSetContent(new_icon_path) == "" then
		return
	end

	local original_icon_id, original_icon_width, original_icon_height = ModImageIdFromFilename(original_icon)
	local new_icon_id, new_icon_width, new_icon_height = ModImageIdFromFilename(new_icon_path)

	if original_icon_width == nil or original_icon_height == nil or new_icon_width == nil or new_icon_height == nil then
		return
	end

	if is_first then
		for i = 0, original_icon_width - 1 do
			for j = 0, original_icon_height - 1 do
				local color = ModImageGetPixel(original_icon_id, i, j)
				ModImageSetPixel(new_icon_id, i, j, color)
			end
		end
	else
		local guaranteed_part_count = 3
		local guaranteed_parts = {}
		local indexes_available = {}
		for i = 0, original_icon_width - 1 do
			table.insert(indexes_available, i)
		end

		for i = 1, guaranteed_part_count do
			if #indexes_available > 0 then
				local idx = Random(1, #indexes_available)
				guaranteed_parts[indexes_available[idx]] = true
				table.remove(indexes_available, idx)
			end
		end

		for i = 0, original_icon_width - 1 do
			if Random(0, 100) < 30 or guaranteed_parts[i] then
				for j = 0, original_icon_height - 1 do
					local color = ModImageGetPixel(original_icon_id, i, j)
					ModImageSetPixel(new_icon_id, i, j, color)
				end
			end
		end
	end
end

local world_seed = tonumber(StatsGetValue("world_seed")) or 1
local TMTRAINER_INDEX = 0

SetRandomSeed(TMTRAINER_INDEX, 0)

local output = {}

table.insert(output, [[
dofile_once("data/scripts/streaming_integration/alt_event_utils.lua")

local function _tmt_get_perk_by_id(perk_id)
	for _, perk in ipairs(perk_list) do
		if perk.id == perk_id then
			return perk
		end
	end
	return nil
end
]])

for i = 1, #perk_pool do

	if Random(1, 100) < 40 then
		local perk_ids = {}
		local ui_name_parts = {}
		local ui_description_parts = {}
		local game_effect = nil
		local particle_effect = nil
		local usable_by_enemies = true
		local stackable = true

		for j = 1, 2 do
			local perk = get_random_perk()
			if perk then
				table.insert(perk_ids, perk.id)
				
				local added_name = GameTextGetTranslatedOrNot(perk.ui_name) or ""
				local added_description = GameTextGetTranslatedOrNot(perk.ui_description) or ""

				local max_iterations = 30
				local function try_update_name(chars, iteration)
					iteration = iteration or 0
					table.insert(ui_name_parts, get_random_chunk(added_name, chars))
					if filter.contains_slur(table.concat(ui_name_parts)) then
						table.remove(ui_name_parts)
						if iteration < max_iterations and (chars - 1 > 0) then try_update_name(chars - 1, iteration + 1) end
					end
				end

				local function try_update_description(chars, iteration)
					iteration = iteration or 0
					table.insert(ui_description_parts, get_random_chunk(added_description, chars))
					if filter.contains_slur(table.concat(ui_description_parts)) then
						table.remove(ui_description_parts)
						if iteration < max_iterations and (chars - 1 > 0) then try_update_description(chars - 1, iteration + 1) end
					end
				end

				try_update_name(4, 0)
				try_update_description(10, 0)

				if perk.usable_by_enemies == false then usable_by_enemies = false end
				if perk.stackable == false then stackable = false end

				SetRandomSeed(TMTRAINER_INDEX, 1)
				if perk.game_effect and perk.game_effect ~= "" then
					if game_effect == nil or Random(0, 100) > 50 then 
						game_effect = perk.game_effect 
					end
				end

				if perk.particle_effect and perk.particle_effect ~= "" then
					if particle_effect == nil or Random(0, 100) > 50 then 
						particle_effect = perk.particle_effect 
					end
				end
				
				if perk.ui_icon then
					generate_icon(i, perk.ui_icon, j == 1, "ui_icon")
				end
				if perk.perk_icon then
					generate_icon(i, perk.perk_icon, j == 1, "perk_icon")
				end
			end
		end

		local ui_name = table.concat(ui_name_parts)
		local ui_description = table.concat(ui_description_parts)

		local perk_ids_parts = {"{"}
		for idx, id in ipairs(perk_ids) do
			table.insert(perk_ids_parts, escape_string(id))
			if idx < #perk_ids then table.insert(perk_ids_parts, ", ") end
		end
		table.insert(perk_ids_parts, "}")
		local perk_ids_str = table.concat(perk_ids_parts)

		local perk_entry = {
			"table.insert(perk_list, {\n",
			"\tnot_in_default_perk_pool = false,\n",
			"\tid = \"TMTRAINER_", tostring(i), "\",\n",
			"\tui_name = ", escape_string(ui_name), ",\n",
			"\tui_description = ", escape_string(ui_description), ",\n",
			"\tui_icon = \"mods/noita.fairmod/files/content/tmtrainer/files/perk_icons/ui_icon_", tostring(i), ".png\",\n",
			"\tperk_icon = \"mods/noita.fairmod/files/content/tmtrainer/files/perk_icons/perk_icon_", tostring(i), ".png\",\n",
			"\tusable_by_enemies = ", tostring(usable_by_enemies), ",\n",
			"\tstackable = ", tostring(stackable), ",\n",
			"\tgame_effect = ", escape_string(game_effect), ",\n",
			"\tparticle_effect = ", escape_string(particle_effect), ",\n",
			"\ttmtrainer = true,\n",
			"\tfunc = function(entity_perk_item, entity_who_picked, item_name, pickup_count)\n",
			"\t\tlocal _perk_ids = ", perk_ids_str, "\n",
			"\t\tfor _, pid in ipairs(_perk_ids) do\n",
			"\t\t\tlocal p = _tmt_get_perk_by_id(pid)\n",
			"\t\t\tif p and p.func then p.func(entity_perk_item, entity_who_picked, item_name, pickup_count) end\n",
			"\t\tend\n",
			"\tend,\n",
			"\tfunc_remove = function(entity_perk_item, entity_who_picked, item_name)\n",
			"\t\tlocal _perk_ids = ", perk_ids_str, "\n",
			"\t\tfor _, pid in ipairs(_perk_ids) do\n",
			"\t\t\tlocal p = _tmt_get_perk_by_id(pid)\n",
			"\t\t\tif p and p.func_remove then p.func_remove(entity_perk_item, entity_who_picked, item_name) end\n",
			"\t\tend\n",
			"\tend,\n",
			"\tfunc_enemy = function(entity_perk_item, entity_who_picked)\n",
			"\t\tlocal _perk_ids = ", perk_ids_str, "\n",
			"\t\tfor _, pid in ipairs(_perk_ids) do\n",
			"\t\t\tlocal p = _tmt_get_perk_by_id(pid)\n",
			"\t\t\tif p and p.func_enemy then p.func_enemy(entity_perk_item, entity_who_picked) end\n",
			"\t\tend\n",
			"\tend,\n",
			"})\n\n",
		}
		table.insert(output, table.concat(perk_entry))

		TMTRAINER_INDEX = TMTRAINER_INDEX + 1
	end
end

ModTextFileSetContent("mods/noita.fairmod/files/content/tmtrainer/files/generated/perks.lua", table.concat(output))
print("TMTRAINER: Generated " .. TMTRAINER_INDEX .. " perks")
