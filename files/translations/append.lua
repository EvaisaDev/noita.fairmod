local game_translation_file = "data/translations/common.csv"
local append_list = {
	"mods/noita.fairmod/files/translations/content/rat_wand.csv",
	"mods/noita.fairmod/files/translations/content/general.csv",
	"mods/noita.fairmod/files/translations/content/chemical_horror.csv",
}

local translation = ModTextFileGetContent(game_translation_file)
for i = 1, #append_list do
	translation = translation .. ModTextFileGetContent(append_list[i]) .. "\n"
end

translation = translation:gsub("\r", ""):gsub("\n\n+", "\n")

ModTextFileSetContent(game_translation_file, translation)
