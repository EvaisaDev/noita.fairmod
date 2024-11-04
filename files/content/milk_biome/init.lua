--stylua: ignore start
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") ---@type nxml

local milk = {}


ModMaterialsFileAdd("mods/noita.fairmod/files/content/milk_biome/materials.xml")


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


-- Update the vanilla milk potion to be a milk jar
for xml in nxml.edit_file("data/entities/items/pickup/potion_milk.xml") do
    local base = xml:first_of("Base")

    base:add_children({
        nxml.new_element("AbilityComponent", {
            ui_name="$fairmod_item_jar_with_material"
        }),
        nxml.new_element("PhysicsImageShapeComponent", {
            image_file="mods/noita.fairmod/files/content/milk_biome/entities/items/pickup/milk_jar_normals.png"
        }),
        nxml.new_element("DamageModelComponent", {
            hp=1    -- milk jars are stronger than potion bottles tbh
        }),
        nxml.new_element("SpriteComponent", {
            image_file="mods/noita.fairmod/files/content/milk_biome/entities/items/pickup/milk_jar_world.png",
			offset_y=5
        }),
        nxml.new_element("ItemComponent", {
            item_name="$fairmod_item_jar",
			ui_sprite="mods/noita.fairmod/files/content/milk_biome/entities/items/pickup/milk_jar_inventory.png"
        })
    })
end


function milk.OnMagicNumbersAndWorldSeedInitialized()
    --Conga: This commented out code inserts the milk biome on the right side of the vault
    for content in nxml.edit_file("data/biome/_biomes_all.xml") do
        content:add_child(nxml.new_element("Biome", {
            biome_filename = "mods/noita.fairmod/files/content/milk_biome/milk_biome.xml", 
            height_index = 0,
            color = "ff83cd35"
        }))
    end

    ModLuaFileAppend("data/scripts/biome_map.lua","mods/noita.fairmod/files/content/milk_biome/scripts/biome_map_appends.lua")
end

return milk
--stylua: ignore end
