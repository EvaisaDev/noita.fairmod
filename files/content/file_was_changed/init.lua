local tcsv = dofile_once("mods/noita.fairmod/files/content/langmix/tcsv.lua")

function format_csv_row(row)
	local escaped = {}
	for _, v in ipairs(row) do
		if v:find(",") then v = '"' .. v .. '"' end
		v = v:gsub("\n", [[\n]])
		escaped[#escaped + 1] = v
	end
	return table.concat(escaped, ",") .. ","
end

function file_was_changed(filename)
	-- Seed with system time
	local tv = { GameGetDateAndTimeUTC() }
	local seed = tv[6] + tv[5] * 60 + tv[4] * 60 * 60
	math.randomseed(seed)

	local content = ModTextFileGetContent(filename)
	local csv = tcsv.parse(content, filename)

	local outrows = {
		[[,en,ru,pt-br,es-es,de,fr-fr,it,pl,zh-cn,jp,ko,,NOTES – use \n for newline,max length,,,,,,,,,,]],
	}

	for _, row in ipairs(csv.rows) do

		-- replace all columns with ""file was changed in the watch folder"" except the first one
		for i = 2, #row do
			row[i] = "file was changed in the watch folder"
		end
	
		outrows[#outrows + 1] = format_csv_row(row)
	end

	ModTextFileSetContent(filename, table.concat(outrows, "\n"))
end

SetRandomSeed(1, 1)

if(Random(0, 1000) <= 1)then
	file_was_changed("data/translations/common.csv")
end
