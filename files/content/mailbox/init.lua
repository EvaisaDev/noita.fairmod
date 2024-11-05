local module = {}

module.spawn = function(x, y)
	if(not HasFlagPersistent("fairmod_first_time_mailbox"))then
		AddFlagPersistent("fairmod_first_time_mailbox")
		ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "welcome,")
	end

	EntityLoad("mods/noita.fairmod/files/content/mailbox/mailbox.xml", x + 110, y - 15)
end

return module