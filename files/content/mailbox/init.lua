local module = {}

module.spawn = function(x, y)

	if Random(1,100)==1 and HasFlagPersistent("fairmod_first_time_mailbox") then
		if(not HasFlagPersistent("fairmod_gamebro_letter"))then
			AddFlagPersistent("fairmod_gamebro_letter")
			ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "gamebro,")
		end
	end

	if(not HasFlagPersistent("fairmod_first_time_mailbox"))then
		AddFlagPersistent("fairmod_first_time_mailbox")
		ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "welcome,")
	end


	EntityLoad("mods/noita.fairmod/files/content/mailbox/mailbox.xml", x + 110, y - 15)
end

return module