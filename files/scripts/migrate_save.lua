if ModSettingGet("fairmod_touched_minecart_trigger") then
	ModSettingRemove("fairmod_touched_minecart_trigger")
	AddFlagPersistent("fairmod_touched_minecart_trigger")
end
