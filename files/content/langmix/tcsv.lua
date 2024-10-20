-- Noita Translations CSV Reader. Copied from Component Explorer

local tcsv = {}

---@class LineReader
---@field content string
---@field char_index integer
local LineReader = {}
LineReader.__index = LineReader

function LineReader.new(content)
	return setmetatable({
		content = content,
		char_index = 1,
	}, LineReader)
end

---@return string?
---@nodiscard
function LineReader:next()
	local idx = self.char_index

	if idx > #self.content then
		-- Reached EOF
		return nil
	end

	local start = idx

	while true do
		local chr = self.content:sub(idx, idx)
		if chr == "\n" then
			-- Put char_index after the newline
			self.char_index = idx + 1
			idx = idx - 1
			break
		end

		if idx == #self.content then
			self.char_index = idx + 1
			break
		end

		idx = idx + 1
	end

	local line = self.content:sub(start, idx)
	line = line:gsub("\r", "")

	return line
end

---@param line string
---@param filename string
---@param line_nr integer
---@return string[] fields
---@return string[] warnings
---@nodiscard
local function parse_csv_line(line, filename, line_nr)
	local ret = {}
	local warnings = {}
	local idx = 1
	local field_start = 1

	local in_quote = false

	while idx <= #line do
		local chr = line:sub(idx, idx)
		if chr == '"' then
			if idx < #line and line:sub(idx + 1, idx + 1) == '"' then
				idx = idx + 1
				goto continue
			end

			in_quote = not in_quote
			if in_quote then
				idx = idx + 1
				field_start = idx
			else
				table.insert(ret, line:sub(field_start, idx - 1))

				if idx < #line and line:sub(idx + 1, idx + 1) ~= "," then
					table.insert(
						warnings,
						table.concat({
							"Text -",
							filename,
							"on line",
							line_nr,
							"expected a ',' at around",
							idx + 1,
						}, " ")
					)
				end

				field_start = idx + 2
				idx = idx + 1
			end
		elseif not in_quote and chr == "," then
			table.insert(ret, line:sub(field_start, idx - 1))
			field_start = idx + 1
		end

		::continue::
		idx = idx + 1
	end

	return ret, warnings
end

---@class CSV
---@field warnings string[]
---@field langs string[]
---@field rows string[][]

---@param content string
---@param filename string
---@param is_mod_translation boolean
---@return CSV
---@nodiscard
function tcsv.parse(content, filename, is_mod_translation)
	local line_reader = LineReader.new(content)
	local line = line_reader:next()
	local line_nr = 1

	local num_langs
	local first_row_columns

	local langs = {}
	local warnings = {}
	local rows = {}

	while line ~= nil and line ~= "" do
		local values, line_warns = parse_csv_line(line, filename, line_nr)
		for _, lw in ipairs(line_warns) do
			table.insert(warnings, lw)
		end

		if line_nr == 1 then
			first_row_columns = #values

			if is_mod_translation then
				num_langs = 1
			else
				for i = 2, #values do
					if values[i] == "" then
						num_langs = i - 2
						break
					end
				end
				if num_langs == nil then
					table.insert(
						warnings,
						table.concat({
							"There should be an empty value on the header",
							"row after the last language",
						}, " ")
					)

					num_langs = math.max(1, #values - 1)
				end
			end

			for i = 2, num_langs + 1 do
				if i <= #values then
					table.insert(langs, values[i])
				else
					table.insert(langs, "#lang" .. i - 1)
				end
			end
		else
			if #values == 0 then
				table.insert(
					warnings,
					table.concat({
						"Incomplete CSV row on line",
						line_nr,
						"(missing comma?)",
					}, " ")
				)
				goto continue
			end

			if #values < num_langs + 1 then
				table.insert(
					warnings,
					table.concat({
						"Missing values on line",
						line_nr,
						"expected",
						num_langs + 1,
						"values but got",
						#values,
					}, " ")
				)
			elseif #values >= 2 * (num_langs + 1) and #values > first_row_columns then
				table.insert(
					warnings,
					table.concat({
						"Found two or more times the expected values on line",
						line_nr .. ".",
						"Number of values:",
						#values,
						"(missing newline?)",
					}, " ")
				)
			end

			for i = 2, math.min(num_langs + 1, #values) do
				values[i] = values[i]:gsub("\\n", "\n")
			end

			local row = {}
			for i = 1, num_langs + 1 do
				table.insert(row, values[i] or "")
			end
			table.insert(rows, row)
		end

		::continue::
		line_nr = line_nr + 1
		line = line_reader:next()
	end

	while line == "" do
		local stopped_nr = line_nr

		line = line_reader:next()
		line_nr = line_nr + 1

		if line ~= nil and line ~= "" then
			table.insert(
				warnings,
				table.concat({
					"CSV reader stopped on line",
					stopped_nr,
					"because there was an empty line, but",
					"there's more content on line",
					line_nr,
				}, " ")
			)
			break
		end
	end

	return {
		warnings = warnings,
		langs = langs,
		rows = rows,
	}
end

return tcsv
