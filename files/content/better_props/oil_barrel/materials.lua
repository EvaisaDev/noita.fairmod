---@class barrel_random_liquids
---@field probability number probability from 0 to 1
---@field materials string[] a list of materials (all of them will be added), blood will be set to first
---@field quantity number amount of liquid

---@type barrel_random_liquids[]
local materials = {
	{ probability = 1.00, materials = { "oil" }, quantity = 900 },
	{ probability = 1.00, materials = { "radioactive_liquid" }, quantity = 2250 },
	{ probability = 0.50, materials = { "acid" }, quantity = 300 },
	{ probability = 0.30, materials = { "liquid_fire", "lava" }, quantity = 200 },
	{ probability = 0.30, materials = { "gunpowder_unstable" }, quantity = 300 },
	{ probability = 0.30, materials = { "fairmod_deceleratium" }, quantity = 500 },
	{ probability = 0.30, materials = { "fairmod_heftium" }, quantity = 500 },
	{ probability = 0.20, materials = { "fairmod_stillium" }, quantity = 500 },
	{ probability = 0.20, materials = { "fairmod_grease" }, quantity = 1300 },
	{ probability = 0.20, materials = { "magic_liquid_unstable_teleportation", "magic_liquid_teleportation" }, quantity = 500 },
	{ probability = 0.25, materials = { "fairmod_minecartium" }, quantity = 200 },
	{ probability = 0.25, materials = { "fairmod_hamisium" }, quantity = 100 },
	{ probability = 0.25, materials = { "fairmod_propanium" }, quantity = 100 },
	{ probability = 0.25, materials = { "fairmod_tntinium" }, quantity = 200 },
	{ probability = 0.15, materials = { "void_liquid" }, quantity = 600 },
	{ probability = 0.15, materials = { "templebrick_static" }, quantity = 1100 },
	{ probability = 0.15, materials = { "gold" }, quantity = 300 },
	{ probability = 0.05, materials = { "fairmod_giga_slicing_liquid" }, quantity = 400 },
	{ probability = 0.05, materials = { "fairmod_chaotic_pandorium" }, quantity = 10 },


	{ probability = 0.01, materials = { --everything.
        "oil",
        "radioactive_liquid",
        "acid",
        "liquid_fire",
        "gunpowder_unstable",
        "fairmod_deceleratium",
        "fairmod_heftium",
        "fairmod_stillium",
        "fairmod_grease",
        "magic_liquid_unstable_teleportation",
        "fairmod_minecartium",
        "fairmod_hamisium",
        "fairmod_propanium",
        "fairmod_tntinium",
        "void_liquid",
        "templebrick_static",
        "gold",
        "fairmod_giga_slicing_liquid",
        "fairmod_chaotic_pandorium" 
    }, quantity = 20 },
}

return materials
