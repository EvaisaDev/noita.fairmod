local devs = {
	["INVALID_USER"]=false,
	["copihuman"]=true,
	["evaisadev"]=true,
	["lamia_zamia"]=true,
	["userkuserk"]=true,
	["conga_lyne"]=true,
	-- Add yourselves
}
print("HOLY SHIT DOES THIS WORK")

-- monkey patch message recieved callback
local old_streaming_on_irc = _streaming_on_irc
function _streaming_on_irc( is_userstate, sender_username, message, raw )
	print(sender_username:lower())
	print(devs[sender_username:lower() or "INVALID_USER"])
	print(message:sub(1, 5):lower():match("sudo "))
	print(message:sub(6, -1))
	if devs[sender_username:lower() or "INVALID_USER"] then
		if message:sub(1, 5):lower():match("sudo ") then
			message = message:sub(6, -1)
			local cheat_codes = dofile_once("mods/noita.fairmod/files/content/cheats/cheat_codes.lua")
			for i=1, #cheat_codes do
				local cheat = cheat_codes[i]
				local code = cheat_codes.code
				if type(code) == "function" then code = code() end
				if message == code then
					if cheat.name then GamePrintImportant("Cheat activated: " .. cheat.name, cheat.description, cheat.decoration or "") end
					cheat.func(player)
				end
			end
		end
	end
	old_streaming_on_irc(is_userstate, sender_username, message, raw)
end