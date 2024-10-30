if not ModSettingGet("noita.fairmod.reset_progress") then return end

dofile_once("mods/noita.fairmod/files/content/achievements/achievements.lua")

for i = 1, #achievements do
	local achievement = achievements[i]
	local flag = "fairmod_" .. achievement.flag or ("achievement_" .. achievement.name)
	RemoveFlagPersistent(flag)
end
ModSettingRemove("fairmod_win_count")
ModSettingRemove("fairmod.death_locations")
ModSettingRemove("noita.fairmod.reset_progress")
