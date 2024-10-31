-- Load required scripts
dofile("mods/noita.fairmod/files/content/tmtrainer/files/scripts/icon_list.lua")

-- Filter out perks not in the default perk pool
local perk_pool = {}
for _, perk in ipairs(perk_list) do
	if not perk.not_in_default_perk_pool then table.insert(perk_pool, perk) end
end

-- Function to get a random perk from the pool
local function get_random_perk()
	return perk_pool[Random(1, #perk_pool)]
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

-- Function to generate a random icon image
local function generate_icon(index, original_icon, is_first, icon_type)
	local icon_dir = "mods/noita.fairmod/files/content/tmtrainer/files/perk_icons/"
	local new_icon_path = icon_dir .. icon_type .. "_" .. index .. ".png"

	-- Get image IDs and dimensions
	local original_icon_id, original_icon_width, original_icon_height = ModImageIdFromFilename(original_icon)
	local new_icon_id, new_icon_width, new_icon_height = ModImageIdFromFilename(new_icon_path)

	if is_first then
		-- Copy the entire original icon onto the new icon
		for i = 0, original_icon_width - 1 do
			for j = 0, original_icon_height - 1 do
				local color = ModImageGetPixel(original_icon_id, i, j)
				ModImageSetPixel(new_icon_id, i, j, color)
			end
		end
	else
		-- Overlay random parts of the original icon onto the new icon
		for i = 0, original_icon_width - 1 do
			if Random(0, 100) < 30 then
				for j = 0, original_icon_height - 1 do
					local color = ModImageGetPixel(original_icon_id, i, j)
					ModImageSetPixel(new_icon_id, i, j, color)
				end
			end
		end
	end
end

-- Main script execution
local TMTRAINER_INDEX = 0

local filter = dofile_once("mods/noita.fairmod/files/content/tmtrainer/files/scripts/slur_filter.lua")
SetRandomSeed(TMTRAINER_INDEX, 0)
for i = 1, #perk_pool do
	-- we set it in here in case some function is dumb and overrides the seed

	if Random(1, 100) < 40 then
		local id = "TMTRAINER_" .. i
		local ui_name_parts = {}
		local ui_description_parts = {}
		local ui_icon = "mods/noita.fairmod/files/content/tmtrainer/files/perk_icons/ui_icon_" .. i .. ".png"
		local perk_icon = "mods/noita.fairmod/files/content/tmtrainer/files/perk_icons/perk_icon_" .. i .. ".png"
		local game_effect = nil
		local particle_effect = nil
		local usable_by_enemies = true
		local stackable = true
		local funcs = {}
		local funcs_remove = {}
		local funcs_enemy = {}

		for j = 1, 2 do
			local perk = get_random_perk()
			local added_name = GameTextGetTranslatedOrNot(perk.ui_name) or ""
			local added_description = GameTextGetTranslatedOrNot(perk.ui_description) or ""

			-- Build name and description from random chunks
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
					if iteration < max_iterations and (chars - 1 > 0) then
						try_update_description(chars - 1, iteration + 1)
					end
				end
			end

			try_update_name(4, 0)
			try_update_description(10, 0)

			-- Generate icons
			generate_icon(i, perk.ui_icon, j == 1, "ui_icon")
			generate_icon(i, perk.perk_icon, j == 1, "perk_icon")

			-- Update flags
			if perk.usable_by_enemies == false then usable_by_enemies = false end

			if perk.stackable == false then stackable = false end

			SetRandomSeed(TMTRAINER_INDEX, 1)
			-- Update game effect and particle effect
			if perk.game_effect and perk.game_effect ~= "" then
				if game_effect == nil or Random(0, 100) > 50 then game_effect = perk.game_effect end
			end

			if perk.particle_effect and perk.particle_effect ~= "" then
				if particle_effect == nil or Random(0, 100) > 50 then
					--print("Particle effect set to: '"..perk.particle_effect.."'")
					particle_effect = perk.particle_effect
				end
			end

			-- Collect functions
			if perk.func then table.insert(funcs, perk.func) end

			if perk.func_remove then table.insert(funcs_remove, perk.func_remove) end

			if perk.func_enemy then table.insert(funcs_enemy, perk.func_enemy) end
		end

		-- Combine name and description parts
		local ui_name = table.concat(ui_name_parts)
		local ui_description = table.concat(ui_description_parts)

		-- Define the combined functions
		local function func(entity_perk_item, entity_who_picked, item_name, pickup_count)
			for _, f in ipairs(funcs) do
				f(entity_perk_item, entity_who_picked, item_name, pickup_count)
			end
		end

		local function func_remove(entity_perk_item, entity_who_picked, item_name)
			for _, f in ipairs(funcs_remove) do
				f(entity_perk_item, entity_who_picked, item_name)
			end
		end

		local function func_enemy(entity_perk_item, entity_who_picked)
			for _, f in ipairs(funcs_enemy) do
				f(entity_perk_item, entity_who_picked)
			end
		end

		-- Create the new perk
		local new_perk = {
			not_in_default_perk_pool = false,
			id = id,
			ui_name = ui_name,
			ui_description = ui_description,
			ui_icon = ui_icon,
			perk_icon = perk_icon,
			usable_by_enemies = usable_by_enemies,
			stackable = stackable,
			game_effect = game_effect,
			particle_effect = particle_effect,
			tmtrainer = true,
			func = func,
			func_remove = func_remove,
			func_enemy = func_enemy,
		}

		table.insert(perk_list, new_perk)
		TMTRAINER_INDEX = TMTRAINER_INDEX + 1
	end
end
