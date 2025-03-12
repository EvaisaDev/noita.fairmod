
local cheese_ending_replacements = {
	["data/entities/animals/boss_centipede/ending/midas_walls.xml"] = true,
	["data/entities/animals/boss_centipede/ending/midas.xml"] = true,
	["data/entities/animals/boss_centipede/ending/midas_radioactive.xml"] = true,
}

local old_EntityLoad = EntityLoad
function EntityLoad(filename, pos_x, pos_y)
	if GameHasFlagRun("Epic_leet_hacker") and cheese_ending_replacements[filename] then
		filename = "mods/noita.fairmod/files/content/cheese_finish/midas_cheese.xml"
	end
	return old_EntityLoad(filename, pos_x or 0, pos_y or 0)
end

