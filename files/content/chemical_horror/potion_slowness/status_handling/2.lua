ModTextFileSetContent("mods/noita.fairmod/files/content/instruction_booklet/gui.lua", ModTextFileGetContent("mods/noita.fairmod/files/content/chemical_horror/potion_slowness/status_handling/_.lua"))
local files = {
    "data/scripts/biomes/dragoncave.lua",
    "data/scripts/biomes/rainforest.lua",
    "data/scripts/biomes/robobase.lua",
    "data/scripts/biomes/sandcave.lua",
    "data/scripts/biomes/snowcastle.lua",
    "data/scripts/biomes/vault_frozen.lua",
    "data/scripts/biomes/vault.lua",
}


for index, value in ipairs(files) do
    print("Modifying " .. value)
    ModTextFileSetContent(value, ModTextFileGetContent(value):gsub(
    [["data/entities/props/physics_tubelamp.xml"]], 

    [["data/entities/props/physics_tubelamp.xml"
	},
	{
		prob   		= .02,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "mods/noita.fairmod/files/content/chemical_horror/potion_slowness/status_handling/physics_tubelamp_bl.xml"]]))
end