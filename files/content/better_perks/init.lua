ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noita.fairmod/files/content/better_perks/append.lua")


---@type nxml
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")

for xml in nxml.edit_file("data/entities/misc/greed_curse/greed.xml") do
    local remove = {}
    for elem in xml:each_of("LuaComponent") do
        remove[#remove+1] = elem
    end
    for _, elem in ipairs(remove) do
        xml:remove_child(elem)
    end
end