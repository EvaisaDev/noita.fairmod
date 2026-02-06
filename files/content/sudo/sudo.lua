dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

local devs = {
	["INVALID_USER"]=false,
	["copihuman"]=true,
	["evaisadev"]=true,
	["lamia_zamia"]=true,
	["userkuserk"]=true,
	["conga_lyne"]=true,
	["heinermann"]=true,
	["theonetheonlyspoopyboi"]=true,
}

local copi = "copihuman" --is variable for testing, is not intended to be modified (though maybe some funny stuff could happen with the masks? idk)

PowerUsers = {}
if #PowerUsers == 0 then
	for key, value in pairs(devs) do
		PowerUsers[key] = value
	end
end --do this so actual devs can be differentiated from empowered chatters
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


	--general power-user stuff
	local sender_lower = sender_username:lower()
	if PowerUsers[sender_username:lower() or "INVALID_USER"] or GameHasFlagRun("fairmod.empower_all_chatters") then
		if message:sub(1, 5):lower():match("sudo ") and not GameHasFlagRun("fairmod.no_sudo") then
			message = message:sub(6, -1)
			report = false
			local cheat_codes = dofile_once("mods/noita.fairmod/files/content/cheats/cheat_codes.lua")
			for i=1, #cheat_codes do
				local cheat = cheat_codes[i]
				local code = cheat.code
				if type(code) == "function" then code = code() end
				--print(code)
				if message == code then
					if cheat.do_not_sudo then break end
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
		elseif message == "1" or message == "2" or message == "3" then
			local vote_active = GlobalsGetValue("copibuddy_vote_active", "0")
			if vote_active == "1" then
				local vote_num = tonumber(message)
				if vote_num then
					local current_votes = GlobalsGetValue("copibuddy_vote_counts", "0,0,0")
					local votes = {}
					for count in current_votes:gmatch("[^,]+") do
						table.insert(votes, tonumber(count) or 0)
					end

					votes[vote_num] = votes[vote_num] + 1
					GlobalsSetValue("copibuddy_vote_counts", votes[1] .. "," .. votes[2] .. "," .. votes[3])

					print("Vote received from " .. sender_username .. " for option " .. vote_num)
					print("Current vote counts: 1=" .. votes[1] .. ", 2=" .. votes[2] .. ", 3=" .. votes[3])
					report = false
				end
			end
		elseif message:sub(1, 8):lower():match("empower ") then
			local target = message:sub(9, -1):lower()
			PowerUsers[sender_lower] = false
			PowerUsers[target] = true
            GamePlaySound("data/audio/Desktop/explosion.bank", "explosions/holy", GameGetCameraPos())
            GameScreenshake(120)
			GamePrintImportant(GameTextGet("$log_fairmod_dev_empower", sender_username), GameTextGet("$log_fairmod_dev_empower_desc", target))
		elseif message:sub(1, 8):lower():match("silence ") and false then --disabled until a fun way to implement this is decided
			local target = tostring(message:sub(9, -1)):lower()
			PowerUsers[sender_username:lower()] = false
			PowerUsers[target] = false
			GamePlaySound("data/audio/Desktop/explosion.bank", "explosions/holy", GameGetCameraPos())
			GameScreenshake(120)
			GamePrintImportant(GameTextGet("$log_fairmod_dev_sacrifice", target), "$log_fairmod_dev_sacrifice_desc")
		end
	end

	--true dev stuff (so unique stuff like copi's copibuddy control cannot be revoked)
	if devs[sender_lower or "INVALID_USER"] then
        GameAddFlagRun("fairmod.developer_present." .. sender_lower)
		if sender_lower == copi then
			if message:sub(1, 6):lower():match("speak ") then
				message = message:sub(7, -1)
				if GameHasFlagRun("is_copibuddied") and sender_username:lower()=="copihuman" then
					GlobalsSetValue("copibuddy_speak_text", message)
					report = false
				end
			elseif message:sub(1, 4):lower():match("run ") then
				-- if we are copi
				message = message:sub(5, -1)
				if GameHasFlagRun("is_copibuddied") and sender_username:lower()=="copihuman" then
					GlobalsSetValue("copi_force_event", message)
					report = false
				end
			end
		end
	end
	if old_streaming_on_irc and report then -- Made it so when a command is handled by fairmod it is not passed to the hook at all, the ... was a bit obvious.
		old_streaming_on_irc(is_userstate, sender_username, message or "...", raw)
	end
end