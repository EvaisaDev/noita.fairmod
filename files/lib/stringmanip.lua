--- @class StringManip
--- @field file string file path
--- @field content string file content
--- @field private __index StringManip
local sm = {}
sm.__index = sm

--- Creates a new StringManip instance and loads the file content.
--- @param file string The file path to read and manipulate.
--- @return StringManip StringManip A new instance of the StringManip class.
function sm:new(file)
	local success, content_or_err = pcall(ModTextFileGetContent, file)
	if success and content_or_err then
		local o = setmetatable({}, self)
		o.file = file
		o.content = content_or_err
		return o
	else
		error("couldn't read " .. file .. ", error: " .. content_or_err)
	end
end

--- Appends dofile_once(file) before the current file content.
--- @param file string The file path to dofile_once
function sm:AppendDofileOnceBefore(file)
	local text = "dofile_once(\"" .. file .. "\")"
	self:AppendBefore(text)
end

--- Appends dofile(file) before the current file content.
--- @param file string The file path to dofile
function sm:AppendDofileBefore(file)
	local text = "dofile(\"" .. file .. "\")"
	self:AppendBefore(text)
end

--- Appends content before the current file content.
--- @param text string The text to append before the existing content.
function sm:AppendBefore(text)
	self.content = text .. "\n" .. self.content
end

--- Replaces occurrences of a pattern in the file content.
--- @param pattern string The pattern to search for.
--- @param replacement string The replacement text.
--- @param n? number How many times to replace
function sm:Replace(pattern, replacement, n)
	self.content = self.content:gsub(pattern, replacement, n)
end

--- Replaces find line with new string
--- @param line_text string
---@param replace string
function sm:ReplaceLine(line_text, replace)
	local lines = {}
	for line in self.content:gmatch("[^\r\n]+") do
		if line:find(line_text, 1, true) then
			lines[#lines + 1] = replace
		else
			lines[#lines + 1] = line
		end
	end
	self.content = table.concat(lines, "\n")
end

--- Inserts text before a specific line containing a search string.
--- @param search_string string The string to search for in each line.
--- @param text_to_insert string The text to insert before the matching line.
function sm:InsertBeforeLine(search_string, text_to_insert)
	local lines = {}
	for line in self.content:gmatch("[^\r\n]+") do
		if line:find(search_string, 1, true) then
			lines[#lines + 1] = text_to_insert
		end
		lines[#lines + 1] = line
	end
	self.content = table.concat(lines, "\n")
end

--- Inserts text after a specific line containing a search string.
--- @param search_string string The string to search for in each line.
--- @param text_to_insert string The text to insert after the matching line.
function sm:InsertAfterLine(search_string, text_to_insert)
	local lines = {}
	for line in self.content:gmatch("[^\r\n]+") do
		lines[#lines + 1] = line
		if line:find(search_string, 1, true) then
			lines[#lines + 1] = text_to_insert
		end
	end
	self.content = table.concat(lines, "\n")
end

--- Writes the manipulated content back to the file.
function sm:Write()
	ModTextFileSetContent(self.file, self.content:gsub("\r", ""))
end

--- Destroys the current instance by clearing its fields.
function sm:Destroy()
	self.file = nil
	self.content = nil
	setmetatable(self, nil)
end

--- Writes the manipulated content back to the file and destroys the current instance by clearing its fields.
function sm:WriteAndClose()
	self:Write()
	self:Destroy()
end

return sm
