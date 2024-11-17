local module = {}
local aes = dofile_once("mods/noita.fairmod/files/lib/aes/aes.lua")
local b64 = dofile_once("mods/noita.fairmod/files/lib/b64/b64.lua")
local src = b64.decode(dofile_once("mods/noita.fairmod/files/content/theeyes/solution.lua"))

local current_input_text = ""
local command_locked_in = false

module.update = function()
	dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

	local players = GetPlayers()

	if #players == 0 then return end

	local player = players[1]

	local cheat_codes = dofile_once("mods/noita.fairmod/files/content/cheats/cheat_codes.lua")
	local commands = dofile_once("mods/noita.fairmod/files/content/cheats/commands.lua")
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

		if input:sub(1, 1) == "/" then
			input = input:gsub("enter", "|")
			for _, v in ipairs(commands) do
				local command = "/" .. v.command --autoslash command
				if type(command) == "function" then command = command() end
				if (string.sub(command, 1, string.len(input)) == input) or (input:sub(1, string.len(command) + 1) == command .. "|") then --if building a command or has a command
					if input:sub(1, string.len(command)) == command then --okay genuinely one or two of these if-statements might be removeable
						if input:sub(1, string.len(command) + 1) == command .. "|" then
							command_locked_in = true --disable other codes from activating while typing command args

							local _,args = input:gsub("|", "") --replace "enter" with "|"
							if last_added == "backspace" and input:len() >= string.len(command) + 1 then
								current_input_text = string.sub(input, 1, -11) --remove "backspace" + 1
								input = string.sub(input, 1, -11)
							end

							if args - 1 == #v.args then
								current_input_text = ""

								local input_args = {}
								local i = 0
								print("printing args:")
								for arg in string.gmatch(input, "([^|]+)") do
									if arg == "" then input_args[i] = nil
									else input_args[i] = arg end
									print(i .. ": " .. tostring(input_args[i]))
								   	i = i + 1
								end
								
								for index, value in ipairs(v.args) do
									local invalid
									if input_args[index] == "" or input_args[index] == nil then
										if value.allow_nil then
											input_args[index] = nil
										else
											invalid = true
										end
										
									else
										if value.type == "number" then
											if tonumber(input_args[index]) == nil then invalid = true end
										end
									end


									if invalid and not value.allow_nil then
										print(string.format('Argument [%s]: "%s", was invalid, expected %s', index, input_args[index], value.type))
										GamePrint(string.format('Argument [%s]: "%s", was invalid, expected %s', index, input_args[index], value.type))
										current_input_text = ""
										command_locked_in = false
										return false
									end
								end
							
								if (v.devmode == false) or GameHasFlagRun("fairmod_developer_mode") then
									if v.name then
										GamePrintImportant("Command activated: " .. v.name, string.format(v.description, input_args[1],  input_args[2],  input_args[3]), v.decoration or "")
									end
									if not v.not_cheat then GameAddFlagRun("Epic_leet_hacker") print("command used, you dirty cheater!") end
									for index, value in ipairs(input_args) do
										print(index .. ": " ..tostring(value))
									end
									v.func(player, input_args)
									GamePrint("Running [" .. input:sub(1, -2) .. "]")
									current_input_text = ""
									command_locked_in = false
								end
							else
								GamePrint(input)
							end
						end
					end
					print("current_cheat_text", input)
					return true
				end
			end
		else
			command_locked_in = false --failsafe to make sure command_locked_in never gets stuck on
		end

		if not command_locked_in then

			input:gsub(" ", "") --spaces are not used for cheatcodes

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
