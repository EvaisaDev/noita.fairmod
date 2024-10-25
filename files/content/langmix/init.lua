local tcsv = dofile_once("mods/noita.fairmod/files/content/langmix/tcsv.lua")

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

local CHANGE_CHANCE = 0.08
local IDX_SWAP_MIN = 2
local IDX_SWAP_MAX = 9 -- Not swapping with Asian languages because of font complications

local language = GameTextGetTranslatedOrNot("$current_language")
local idx = LANG_INDEX_MAP[language]

-- Unsupported language
if not idx then return end

function format_csv_row(row)
	local escaped = {}
	for _, v in ipairs(row) do
		if v:find(",") then v = '"' .. v .. '"' end
		v = v:gsub("\n", [[\n]])
		escaped[#escaped + 1] = v
	end
	return table.concat(escaped, ",") .. ","
end

function mix_language(filename)
	local content = ModTextFileGetContent(filename)
	local csv = tcsv.parse(content, filename)

	local outrows = {
		[[,en,ru,pt-br,es-es,de,fr-fr,it,pl,zh-cn,jp,ko,,NOTES – use \n for newline,max length,,,,,,,,,,]],
	}

	for _, row in ipairs(csv.rows) do
		if math.random() < CHANGE_CHANCE then
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
		outrows[#outrows + 1] = format_csv_row(row)
	end

	ModTextFileSetContent(filename, table.concat(outrows, "\n"))
end

mix_language("data/translations/common.csv")
