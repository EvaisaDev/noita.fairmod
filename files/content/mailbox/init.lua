local module = {}

local function get_mail()
	local mail_str = ModSettingGet("noita.fairmod.mail") or ""

	-- split mail by comma
	local mail = {}
	for str in string.gmatch(mail_str, "([^,]+)") do
		table.insert(mail, str)
	end
	return mail
end

local function clear_duplicates()
	local mail_list = dofile("mods/noita.fairmod/files/content/mailbox/mail_list.lua")
	local mail = get_mail()
	local mail_set = {}
	local new_mail = {}
	for i, mail_id in ipairs(mail) do
		if not mail_set[mail_id] and mail_list[mail_id] then
			mail_set[mail_id] = true
			table.insert(new_mail, mail_id)
		end
	end
	ModSettingSet("noita.fairmod.mail", table.concat(new_mail, ",")..",")
end


module.spawn = function(x, y)
	-- surely random
	local a, b, c, d, e, f = GameGetDateAndTimeUTC()
	SetRandomSeed(x + a + b * c + d + e * f, y)

	if Random(1,100)==1 and HasFlagPersistent("fairmod_first_time_mailbox") then
		if(not HasFlagPersistent("fairmod_gamebro_letter"))then
			AddFlagPersistent("fairmod_gamebro_letter")
			ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "gamebro,")
		end
	end

	if Random(1,3)==1 and HasFlagPersistent("fairmod_first_time_mailbox") then
		if(not HasFlagPersistent("fairmod_copi_evil_letter"))then
			if not HasFlagPersistent("fairmod_evil_letter_buffer") then
				ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "copi_evil,")
				AddFlagPersistent("fairmod_evil_letter_buffer")
			end
		end
	end

	if(not HasFlagPersistent("fairmod_first_time_mailbox"))then
		AddFlagPersistent("fairmod_first_time_mailbox")
		ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "welcome,")
	end

	if Random(1,75)==1 and HasFlagPersistent("fairmod_first_time_mailbox") then
		if not HasFlagPersistent("fairmod_soma_prime_letter") then
			ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "soma_prime,")
			AddFlagPersistent("fairmod_soma_prime_letter")
		end
	end

	if( Random(0, 1000) <= 20)then
		ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "nokia,")
	end

	if( Random(0, 1000) <= 20)then
		ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "zipbomb,")
	end

	if( Random(0, 1000) <= 20) and HasFlagPersistent("fairmod_first_time_mailbox") then
		ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "hampill,")
	end

	if(HasFlagPersistent("should_wear_hardhat"))then
		ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "hardhat,")
		RemoveFlagPersistent("should_wear_hardhat")
	end

	EntityLoad("mods/noita.fairmod/files/content/mailbox/mailbox.xml", x + 110, y - 15)

	-- clear duplicates
	clear_duplicates()
end

return module