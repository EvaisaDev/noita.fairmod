local slurs = {}

local content = ModTextFileGetContent("mods/noita.fairmod/files/content/tmtrainer/files/scripts/bad_words.txt")
-- remove first line
content = content:gsub("^[^\n]*\n", "")
-- base64 decode
local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
function base64_decode(data)
	data = string.gsub(data, "[^" .. b .. "=]", "")
	return (
		data:gsub(".", function(x)
			if x == "=" then return "" end
			local r, f = "", (b:find(x) - 1)
			for i = 6, 1, -1 do
				r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0")
			end
			return r
		end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
			if #x ~= 8 then return "" end
			local c = 0
			for i = 1, 8 do
				c = c + (x:sub(i, i) == "1" and 2 ^ (8 - i) or 0)
			end
			return string.char(c)
		end)
	)
end

content = base64_decode(content)

for line in content:gmatch("[^\r\n]+") do
	table.insert(slurs, line)
end

local module = {}

module.contains_slur = function(str)
	for _, slur in ipairs(slurs) do
		if string.find(str, slur) then return true end
	end
	return false
end

return module
