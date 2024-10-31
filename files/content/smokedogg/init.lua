ModMaterialsFileAdd("mods/noita.fairmod/files/content/smokedogg/materials.xml")
ModLuaFileAppend(
	"data/scripts/status_effects/status_list.lua",
	"mods/noita.fairmod/files/content/smokedogg/status_effects_append.lua"
)

local M = {}

local function condition_check()
	local year, month, day, hour, minute, second = GameGetDateAndTimeLocal()
	if hour == 16 and (minute >= 20 and minute <= 21) then return true end
	return false
end

function M.update()
	if condition_check() and not GameHasFlagRun("fairmod_smokedogg_spawned") then
		GameAddFlagRun("fairmod_smokedogg_spawned")
		local smokedogg = EntityLoad("mods/noita.fairmod/files/content/smokedogg/smokedogg.xml")

		EntityAddComponent2(smokedogg, "AudioLoopComponent", {
			file = "mods/noita.fairmod/fairmod.bank",
			event_name = ModSettingGet("noita.fairmod.streamer_mode") and "smokedogg/loop_streamer" or "smokedogg/loop",
			auto_play = true,
		})
	end
end

return M
