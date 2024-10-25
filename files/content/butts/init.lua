-- stole your code dexter :3

function split_into_syllables(str)
	local syllables = {}
	for part in string.gmatch(str, "[^aeiouyAEIOUY]*[aeiouyAEIOUY]+[^aeiouyAEIOUY]*") do
		table.insert(syllables, part)
	end
	return syllables
end

function replace_syllables_with_butt(syllables)
	for i = 1, #syllables do
		if math.random() > 0.9 then -- 10% chance to replace a syllable
			syllables[i] = "butt"
		end
	end
end

function join_syllables(syllables)
	return table.concat(syllables, "")
end

local function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

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

local CHANGE_CHANCE = 0.2

local function buttsify(filename)
	local content = ModTextFileGetContent(filename)
	local csv = tcsv.parse(content, filename)

	local outrows = {
		[[,en,ru,pt-br,es-es,de,fr-fr,it,pl,zh-cn,jp,ko,,NOTES – use \n for newline,max length,,,,,,,,,,]],
	}

	for _, row in ipairs(csv.rows) do
		if math.random() < CHANGE_CHANCE then
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
		outrows[#outrows + 1] = format_csv_row(row)
	end

	ModTextFileSetContent(filename, table.concat(outrows, "\n"))
end

buttsify("data/translations/common.csv")
