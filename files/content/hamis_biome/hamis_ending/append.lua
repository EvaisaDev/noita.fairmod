local file = "data/entities/animals/boss_centipede/ending/sampo_start_ending_sequence.lua"

local content = ModTextFileGetContent(file)
local new_content = [[--hi
if GameHasFlagRun("fairmod_longest_hamis_interacted") then
	dofile("mods/noita.fairmod/files/content/hamis_biome/hamis_ending/ending_hamis.lua")
	return
end
]]

ModTextFileSetContent(file, new_content .. content)
