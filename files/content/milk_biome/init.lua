--stylua: ignore start
--[[
--Conga: This commented out code inserts the milk biome on the right side of the vault
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")

for content in nxml.edit_file("data/biome/_biomes_all.xml") do
    content:add_child(nxml.new_element("Biome", {
        biome_filename = "mods/noita.fairmod/files/content/milk_biome/milk_biome.xml", 
        height_index = 0,
        color = "ff83cd35"
    }))
end

ModLuaFileAppend("data/scripts/biome_map.lua","mods/noita.fairmod/files/content/milk_biome/scripts/biome_map_appends.lua")
]]--

--Generate global spawns
local opts = {
    --"wizardcave",
    "coalmine",
    "desert",
    --"crypt",
    --"pyramid",
    --"fungicave",
    "coalmine_alt",
    --"pyramid_hallway",
    "excavationsite",
    --"fungiforest",
    --"snowcave",
    --"wandcave",
    --"sandcave",
    --"winter",
    "rainforest",
    --"rainforest_dark",
    --"liquidcave",
    "snowcastle",
    "vault",
}

for k=1,#opts do
    ModLuaFileAppend(table.concat({ "data/scripts/biomes/", opts[k], ".lua" }),"mods/noita.fairmod/files/content/milk_biome/scripts/global_milk_man_populator.lua")
end
--stylua: ignore end
