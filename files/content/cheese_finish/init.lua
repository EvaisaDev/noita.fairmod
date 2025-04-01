local original_ending_seq = ModTextFileGetContent("data/entities/animals/boss_centipede/ending/sampo_start_ending_sequence.lua")
local ending_seq_prepends = ModTextFileGetContent("mods/noita.fairmod/files/content/cheese_finish/ending_sequence_prepend.lua")

ModTextFileSetContent(
	"data/entities/animals/boss_centipede/ending/sampo_start_ending_sequence.lua",
	ending_seq_prepends .. original_ending_seq
)
