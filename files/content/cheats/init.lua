local module = {}

local current_input_text = ""

module.update = function()
	dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

	local players = GetPlayers()
	
	if #players == 0 then return end
	
	local player = players[1]

	local cheat_codes = dofile_once("mods/noita.fairmod/files/content/cheats/cheat_codes.lua")
	local keys = dofile_once("mods/noita.fairmod/files/content/cheats/misc/keyboard.lua")

	local key_ranges = keys.key_ranges

	local was_any_pressed = false
	for _, key_range in ipairs(key_ranges) do
		for i = key_range[1], key_range[2] do
			if InputIsKeyJustUp(i) then
				current_input_text = current_input_text .. (keys.key_map[i] or "")
				was_any_pressed = true
			end
		end
	end
	
	if not was_any_pressed then return end

	-- check if current input is at the beginning of any cheat code
	local was_any_match = false
	for k, v in pairs(cheat_codes) do
		if string.sub(k, 1, string.len(current_input_text)) == current_input_text then
			if string.len(k) == string.len(current_input_text) then
				GamePrintImportant("Cheat activated: " .. v.name,  v.description)
				v.func(player)
				current_input_text = ""
			end
			was_any_match = true
		end
	end

	if not was_any_match then
		current_input_text = ""
	end

end

return module