dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

Devs = {
	["INVALID_USER"]=false,
	["copihuman"]=true,
	["evaisadev"]=true,
	["lamia_zamia"]=true,
	["userkuserk"]=true,
	["conga_lyne"]=true,
	["heinermann"]=true,
	["theonetheonlyspoopyboi"]=true,
	-- Add yourselves
}
--print("HOLY SHIT DOES THIS WORK") yes; it does, now shut up.

-- monkey patch message recieved callback
local old_streaming_on_irc = _streaming_on_irc
function _streaming_on_irc( is_userstate, sender_username, message, raw )
	local report = true
	--[[
		print(sender_username:lower())
		print(tostring(devs[sender_username:lower() or "INVALID_USER"]))
		print(tostring(message:sub(1, 5):lower():match("sudo ")))
		print(tostring(message:sub(6, -1)))
	]]

	--[[
	if message:sub(1, 4) == "TEST" then
		for dev, power in pairs(Devs or {}) do
			print(tostring(dev) .. " = " .. tostring(power))
		end
	end--]]
	if Devs[sender_username:lower() or "INVALID_USER"] then
		if message:sub(1, 5):lower():match("sudo ") then
			message = message:sub(6, -1)
			report = false
			local cheat_codes = dofile_once("mods/noita.fairmod/files/content/cheats/cheat_codes.lua")
			for i=1, #cheat_codes do
				local cheat = cheat_codes[i]
				local code = cheat.code
				if type(code) == "function" then code = code() end
				--print(code)
				if message == code then
					if cheat.name then GamePrintImportant("Cheat activated: " .. cheat.name, cheat.description, cheat.decoration or "") end
					cheat.func(EntityGetWithTag("player_unit")[1])
				end
			end
		elseif message:sub(1, 6):lower():match("print ") then
			message = message:sub(7, -1)
			GamePrintImportant(message, "From:" ..sender_username, "mods/noita.fairmod/files/content/sudo/3piece_meta.png")
			report = true
		elseif message:sub(1, 5):lower():match("mail ") then
			message = message:sub(6, -1)

			print("sudo_mail", message)

			GlobalsSetValue("noita.fairmod.sudo_mail", GlobalsGetValue("noita.fairmod.sudo_mail", "")..sender_username.."\n"..message .."\n")
			report = false
		elseif message:sub(1, 8):lower():match("empower ") then
			Devs[sender_username:lower()] = false
			Devs[message:sub(9, -1):lower()] = true

            local player = GetPlayers()[1]
            local x,y = 0,0
            if player then x,y = EntityGetTransform(player) end
            GamePlaySound("data/audio/Desktop/explosion.bank", "explosions/holy", x, y)
            GameScreenshake(120)
			GamePrintImportant(GameTextGet("$log_fairmod_dev_empower", sender_username), "$log_fairmod_dev_empower_desc")
			--[[actually im considering making it a point-based system, but that would be annoying to code here so ill leave it fn -k]]
			--[[also if i did, id rework it so that if 4 devs sacrifice their power, everyone gains power -k]]
		elseif message:sub(1, 8):lower():match("silence ") then
			local target = tostring(message:sub(9, -1)):lower()
			Devs[sender_username:lower()] = false
			Devs[target] = false
            
            local player = GetPlayers()[1]
            local x,y = 0,0
            if player then x,y = EntityGetTransform(player) end
            GamePlaySound("data/audio/Desktop/explosion.bank", "explosions/holy", x, y)
            GameScreenshake(120)
			GamePrintImportant(GameTextGet("$log_fairmod_dev_sacrifice", target), "$log_fairmod_dev_sacrifice_desc")
		end
	end
	if old_streaming_on_irc then
		old_streaming_on_irc(is_userstate, sender_username, report and message or "...", raw)
	end
end