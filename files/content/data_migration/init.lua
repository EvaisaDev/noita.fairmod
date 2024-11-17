local function MigrateSetting(to, from)
	if ModSettingGet(from) == nil then
		print("setting [" .. from .. "] simply isnt real")
		return
	end
	local to_setting = ModSettingGet(to)
	local from_setting = ModSettingGet(from)
	if to_setting == nil and from_setting ~= nil then
		ModSettingSet(to, from_setting)
		ModSettingRemove(from)
	end
end

local mod_setting_version = 1

local detected_version = tonumber(ModSettingGet("fairmod.mod_setting_version")) or 0
if detected_version == 0 and (tonumber(ModSettingGet("fairmod.plays")) or 0) > 0 then
	MigrateSetting("fairmod.radios_activated_highscore", "radios_activated_highscore")
	MigrateSetting("fairmod.information_hamis_amount_given", "information_hamis_amount_given")
	MigrateSetting("fairmod.information_hamis_wallet", "information_hamis_wallet")
	MigrateSetting("fairmod.user_seed", "user_seed")
	MigrateSetting("noita.fairmod.cpand_tmtrainer_chance", "noita.fairmod.fairmod.cpand_tmtrainer_chance")
end

ModSettingSet("fairmod.mod_setting_version", mod_setting_version)

