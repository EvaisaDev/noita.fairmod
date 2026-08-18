if not ModSettingGet("noita.fairmod.reset_progress") then return end

dofile_once("mods/noita.fairmod/files/content/achievements/achievements.lua")

for i = 1, #achievements do
	local achievement = achievements[i]
	RemoveFlagPersistent(achievement.flag)
end

local settings = {
	"fairmod_win_count",
	"fairmod.death_locations",
	"fairmod.radios_activated_highscore",
	"noita.fairmod.reset_progress",
	"fairmod.deaths",
	"noita.fairmod.cpand_tmtrainer_chance",
}

local persistent_flags = {
	"fairmod_dmca_warning_shown",
	"fairmod_spawned_superchest",
	"fairmod_noitillionare_winner",
	"crashed_by_wizard",
	"fairmod_touched_minecart_trigger",
	"fairmod_won_lovely_dream",
	"fairmod_saw_jungle_once",
}

for _,setting in ipairs(settings) do
	ModSettingRemove(setting)
end

for _,flag in ipairs(persistent_flags) do
	RemoveFlagPersistent(flag)
end

local cheats = dofile_once("mods/noita.fairmod/files/content/cheats/cheat_codes.lua")
for _,cheat in ipairs(cheats) do ModSettingRemove("fairmod.cheat_executed." .. (cheat.progress_id or "")) end