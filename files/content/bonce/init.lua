local nxml = dofile("mods/noita.fairmod/files/lib/nxml.lua")

local function alter(element, field)
    local mult = 1
    local value = tonumber(element:get(field))
    if field == "jump_speed" then
        if value == nil then
            value = 200 -- default value
        end
        mult = 10 --change these values to your liking
    elseif field == "initial_jump_max_distance_x" then
        if value == nil then
            value = 100 -- default value
        end
        mult = 1.5 --change these values to your liking, but too high values lowers fps
    elseif field == "initial_jump_max_distance_y" then
        if value == nil then
            value = 60 -- default value
        end
        mult = 1.5 --change these values to your liking, but too high values lowers fps
    else
        value = 0
    end
    element:set(field, tostring(value * mult))
end
local function visit(element)
    alter(element, "jump_speed")
    alter(element, "initial_jump_max_distance_x")
    alter(element, "initial_jump_max_distance_y")
end

local filenames = dofile_once("mods/noita.fairmod/files/content/bonce/filenames.lua")
for i, filename in ipairs(filenames) do
    filename = "data/entities/animals/" .. filename
    for content in nxml.edit_file(filename) do
        content:expand_base()
        local path_finding_comp = content:first_of("PathFindingComponent")
        if path_finding_comp then
            visit(path_finding_comp)
        end
    end
end