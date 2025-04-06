if not ModSettingGet("noita.fairmod.reset_progress") then return end

dofile_once("mods/noita.fairmod/files/content/achievements/achievements.lua")

for i = 1, #achievements do
	local achievement = achievements[i]
	RemoveFlagPersistent(achievement.flag)
end

RemoveFlagPersistent("fairmod_dmca_warning_shown")
RemoveFlagPersistent("fairmod_spawned_superchest")
RemoveFlagPersistent("fairmod_noitillionare_winner")
RemoveFlagPersistent("crashed_by_wizard")
ModSettingRemove("fairmod_win_count")
ModSettingRemove("fairmod.death_locations")
ModSettingRemove("fairmod.radios_activated_highscore")
ModSettingRemove("noita.fairmod.reset_progress")
RemoveFlagPersistent("fairmod_touched_minecart_trigger")
ModSettingRemove("fairmod.deaths")
ModSettingRemove("noita.fairmod.cpand_tmtrainer_chance")
