--[[
--translations
local _, _, days, hours, mins, secs = GameGetDateAndTimeLocal()
math.randomseed(hours * 60 * 60 + mins * 60 + secs)
local defaultText = ModTextFileGetContent("data/translations/common.csv")
local firstLine = true
local newStrings = {}
for line in string.gmatch(defaultText, "[^\n]+") do
    if firstLine then
        newStrings[#newStrings+1] = line
        firstLine = false
    else
        local firstComma = 1
        for i = 1,string.len(line),1 do
            if string.sub(line, i, i) == "," then
                firstComma = i
                break
            end
        end
        local secondComma = firstComma + 1
        for i = secondComma,string.len(line),1 do
            if string.sub(line, i, i) == "," then
                secondComma = i
                break
            end
        end
        local firstPortion = string.sub(line, 1, firstComma)
        local middlePortion = string.sub(line, firstComma + 1, secondComma - 1)
        local rnd = math.random()
        if rnd < 0.01 then middlePortion = "https://github.com/Ramiels/copis_things/" .. middlePortion
        elseif rnd < 0.11 then middlePortion = "Download Copi's Things! - " .. middlePortion end
        local endPortion = string.sub(line, secondComma, string.len(line))

        newStrings[#newStrings+1] = firstPortion .. middlePortion .. endPortion
    end
end
local newFile = table.concat(newStrings, "\n")
ModTextFileSetContent("data/translations/common.csv", newFile) -- disabled tl stuff lmao]]

local popups = {}
local a = OnWorldInitialized
local b = OnPlayerSpawned
popups.OnWorldInitialized = function()
	EntityAddComponent2(
		GameGetWorldStateEntity(),
		"LuaComponent",
		{ script_source_file = "mods/noita.fairmod/virtual/content/popups/files/script.lua", execute_every_n_frame = 1 }
	)
	if a ~= nil then a() end
end
return popups