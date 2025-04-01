local tcsv = dofile_once("mods/noita.fairmod/files/content/language_tomfoolery/tcsv.lua")
local filename = "data/translations/common.csv"
local csv_parsed = tcsv.parse(ModTextFileGetContent(filename), filename)

local LANG_INDEX_MAP = {
	["English"] = 2,
	["русский"] = 3,
	["Português (Brasil)"] = 4,
	["Español"] = 5,
	["Deutsch"] = 6,
	["Français"] = 7,
	["Italiano"] = 8,
	["Polska"] = 9,
	["简体中文"] = 10,
	["日本語"] = 11,
	["한국어"] = 12,
}

local LANGMIX_CHANGE_CHANCE = 0.08
local BUTTS_CHANGE_CHANCE = 0.2
local WORDS_SHUFFLE_CHANCE = 0.1

local IDX_SWAP_MIN = 2
local IDX_SWAP_MAX = 9 -- Not swapping with Asian languages because of font complications

local language = GameTextGetTranslatedOrNot("$current_language")
local idx = LANG_INDEX_MAP[language]

-- Unsupported language
if not idx then return end

local function split_into_syllables(str)
	local syllables = {}
	for part in string.gmatch(str, "[^aeiouyAEIOUY]*[aeiouyAEIOUY]+[^aeiouyAEIOUY]*") do
		table.insert(syllables, part)
	end
	return syllables
end

local function replace_syllables_with_butt(syllables)
	for i = 1, #syllables do
		if math.random() > 0.95 then -- 5% chance to replace a syllable
			syllables[i] = "butt"
		end
	end
end

local function join_syllables(syllables)
	return table.concat(syllables, "")
end

local function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function format_csv_row(row)
	local escaped = {}
	for _, v in ipairs(row) do
		if v:find(",") then v = '"' .. v .. '"' end
		v = v:gsub("\n", [[\n]])
		escaped[#escaped + 1] = v
	end
	return table.concat(escaped, ",") .. ","
end

local function mix_language_row(row)
	local swap_max = IDX_SWAP_MAX
	if idx <= swap_max then
		-- Current language in swap region. Subtract one so we don't
		-- swap with self. (Relies on swap_idx adjustment after math.random
		swap_max = swap_max - 1
	end

	local swap_idx = math.random(IDX_SWAP_MIN, swap_max)
	if swap_idx >= idx then swap_idx = swap_idx + 1 end

	if row[swap_idx] ~= "" then
		row[idx], row[swap_idx] = row[swap_idx], row[idx]
	end
end

local function buttsify_row(row)
	for i, v in ipairs(row) do
		if i == 1 then
			-- Skip the first column
			goto continue
		end
		local syllables = split_into_syllables(v)

		replace_syllables_with_butt(syllables)

		local new_str = join_syllables(syllables)

		if trim(new_str) ~= "" then row[i] = new_str end

		::continue::
	end
end

local function shuffle_words(input)
	local words = {}
	local separators = {}

	-- Pattern to capture word + optional punctuation and any trailing spaces
	local separator_pat = '.()/!:?" \t\n-'
	for word, separator in input:gmatch("([^" .. separator_pat .. "]*)([" .. separator_pat .. "]*)") do
		if word ~= "" or separator ~= "" then
			words[#words + 1] = word
			separators[#separators + 1] = separator
		end
	end

	-- Shuffle the words table
	for i = #words, 2, -1 do
		local j = math.random(i)
		words[i], words[j] = words[j], words[i]
	end

	-- Rebuild the string with correct spaces and punctuation
	local result = ""
	for i = 1, #words do
		result = result .. words[i] .. separators[i]
	end

	return result
end

local function shuffle_row_words(row)
	for i = 2, #row do
		row[i] = shuffle_words(row[i])
	end
end

SetRandomSeed(1, 1)

local output = {}

if Random(0, 1000) <= 1 then
	for _, row in ipairs(csv_parsed.rows) do
		for i = 2, #row do
			row[i] = "file was changed in the watch folder"
		end
		output[#output + 1] = format_csv_row(row)
	end
else
	for _, row in ipairs(csv_parsed.rows) do
		if math.random() < LANGMIX_CHANGE_CHANCE then mix_language_row(row) end
		if math.random() < BUTTS_CHANGE_CHANCE then buttsify_row(row) end
		if math.random() < WORDS_SHUFFLE_CHANCE then shuffle_row_words(row) end
		output[#output + 1] = format_csv_row(row)
	end
end

local result = [[,en,ru,pt-br,es-es,de,fr-fr,it,pl,zh-cn,jp,ko,,NOTES – use \n for newline,max length,,,,,,,,,,]]
	.. "\n"
	.. table.concat(output, "\n")
ModTextFileSetContent(filename, result)
