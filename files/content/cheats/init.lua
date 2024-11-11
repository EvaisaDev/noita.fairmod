local module = {}
local aes = dofile_once("mods/noita.fairmod/files/lib/aes/aes.lua")
local b64 = dofile_once("mods/noita.fairmod/files/lib/b64/b64.lua")
local src = b64.decode(dofile_once("mods/noita.fairmod/files/content/theeyes/solution.lua"))

local current_input_text = ""

module.update = function()
	dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

	local players = GetPlayers()

	if #players == 0 then return end

	local player = players[1]

	local cheat_codes = dofile_once("mods/noita.fairmod/files/content/cheats/cheat_codes.lua")
	local keys = dofile_once("mods/noita.fairmod/files/content/cheats/misc/keyboard.lua")

	local key_ranges = keys.key_ranges

	local last_added = ""

	local was_any_pressed = false
	for _, key_range in ipairs(key_ranges) do
		for i = key_range[1], key_range[2] do
			if InputIsKeyJustUp(i) then
				last_added = (keys.key_map[i] or "")
				current_input_text = current_input_text .. last_added
				was_any_pressed = true
			end
		end
	end

	if not was_any_pressed then return end

	-- Function to check if input matches any cheat code
	---@param input string
	local function check_input(input)
		local small_eyes = ("eyes"):sub(1, input:len())
		if small_eyes == input:sub(1, 4) then
			if input:len() == 9 then
				local password = input:sub(5)
				local key = 0
				for i = 1, 5 do
					key = key * 256
					key = key + password:sub(i, i):byte()
				end
				local file = "mods/noita.fairmod/virtual/" .. password .. ".lua"
				local decrypted = aes.ECB_256(aes.decrypt, key, src)
				print(decrypted)
				if decrypted:sub(1, 4) ~= "Game" then
					GamePrintImportant("your secret code failed!")
					return false
				end
				ModTextFileSetContent(file, decrypted)
				local succ = pcall(dofile, file)
				if not succ then GamePrintImportant("your secret code failed!") end
				return false
			end
			return true
		end
		for _, v in ipairs(cheat_codes) do
			local code = v.code
			if type(code) == "function" then code = code() end
			if string.sub(code, 1, string.len(input)) == input then
				if string.len(code) == string.len(input) then
					if (v.devmode and GameHasFlagRun("fairmod_developer_mode")) or not v.devmode then
						if v.name then
							GamePrintImportant("Cheat activated: " .. v.name, v.description, v.decoration or "")
						end
						if not v.not_cheat then GameAddFlagRun("Epic_leet_hacker") print("cheat used, you dirty cheater!") end
						v.func(player)
						current_input_text = ""
					end
				end
				print("current_cheat_text", input)
				return true
			end
		end
		return false
	end

	local was_any_match = check_input(current_input_text)

	if not was_any_match then
		-- Try all suffixes of current_input_text
		local found = false
		for i = 2, #current_input_text do
			local suffix = current_input_text:sub(i)
			if check_input(suffix) then
				current_input_text = suffix
				found = true
				break
			end
		end
		if not found then current_input_text = "" end
	end
end

return module
