-- stole your code ~~dexter~~ eba :3

local tcsv = dofile_once("mods/noita.fairmod/files/content/langmix/tcsv.lua")

local function format_csv_row(row)
	local escaped = {}
	for _, v in ipairs(row) do
		if v:find(",") then v = '"' .. v .. '"' end
		v = v:gsub("\n", [[\n]])
		escaped[#escaped + 1] = v
	end
	return table.concat(escaped, ",") .. ","
end


local function shuffle_words(input)
    local words = {}
    local separators = {}

    -- Pattern to capture word + optional punctuation and any trailing spaces
    for word, separator in input:gmatch("(%a+)([^%a]*)") do
        table.insert(words, word)
        table.insert(separators, separator)
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



local CHANGE_CHANCE = 0.15

local function not_buttsify(filename)
	local content = ModTextFileGetContent(filename)
	local csv = tcsv.parse(content, filename)

	local outrows = {
		[[,en,ru,pt-br,es-es,de,fr-fr,it,pl,zh-cn,jp,ko,,NOTES – use \n for newline,max length,,,,,,,,,,]],
	}

	for _, row in ipairs(csv.rows) do

		if math.random() < CHANGE_CHANCE then
			for i=2, #row do
				row[i] = shuffle_words(row[i])
			end
		end

		outrows[#outrows + 1] = format_csv_row(row)
	end

	ModTextFileSetContent(filename, table.concat(outrows, "\n"))
end

not_buttsify("data/translations/common.csv")
