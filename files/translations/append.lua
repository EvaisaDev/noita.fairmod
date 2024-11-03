local game_translation_file = "data/translations/common.csv"
local append_list = {
	"mods/noita.fairmod/files/translations/content/milk_biome.csv",
	"mods/noita.fairmod/files/translations/content/rat_wand.csv",
	"mods/noita.fairmod/files/translations/content/general.csv",
	"mods/noita.fairmod/files/translations/content/chemical_horror.csv",
	"mods/noita.fairmod/files/translations/content/bee_movie.csv",
	"mods/noita.fairmod/files/translations/content/reformatted.csv",
}

local translation = ModTextFileGetContent(game_translation_file)
for i = 1, #append_list do
	translation = translation .. ModTextFileGetContent(append_list[i]) .. "\n"
end

translation = translation:gsub("\r", ""):gsub("\n\n+", "\n")

ModTextFileSetContent(game_translation_file, translation)

--[[ stuff for generating reformatted strings
local function shuffle_words(input)
	local words = {}
	local separators = {}

	-- Pattern to capture word + optional punctuation and any trailing spaces
	for word, separator in input:gmatch("(%a+)([^%a]*)") do
		table.insert(words, word)
		table.insert(separators, separator)
	end

	local function sort_alphabetical(a, b)
		return a:lower() < b:lower()
	end

	-- Shuffle the words table
	table.sort(words, sort_alphabetical)

	-- Rebuild the string with correct spaces and punctuation
	local result = ""
	for i = 1, #words do
		result = result .. words[i] .. separators[i]
	end

	return result:gsub("\n", "\\n")
end



local table_str = {
}
local str = ""
for index, value in ipairs(table_str) do
	str = str .. "\n" .. shuffle_words(value)
end
print(str)
--]]
