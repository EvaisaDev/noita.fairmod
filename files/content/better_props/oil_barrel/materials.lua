---@class barrel_random_liquids
---@field probability number probability from 0 to 1
---@field materials string[] a list of materials (all of them will be added), blood will be set to first
---@field quantity number amount of liquid

---@type barrel_random_liquids[]
local materials = {
	{ probability = 1.0, materials = { "oil" }, quantity = 900 },
	{ probability = 1.0, materials = { "radioactive_liquid" }, quantity = 2250 },
	{ probability = 0.5, materials = { "acid" }, quantity = 300 },
	{ probability = 0.1, materials = { "fairmod_minecartium" }, quantity = 200 },
	{ probability = 0.1, materials = { "fairmod_hamisium" }, quantity = 100 },
	{ probability = 0.1, materials = { "fairmod_propanium" }, quantity = 100 },
	{ probability = 0.1, materials = { "fairmod_tntinium" }, quantity = 200 },
	{ probability = 0.3, materials = { "liquid_fire", "lava" }, quantity = 200 },
	{ probability = 0.3, materials = { "gunpowder_unstable" }, quantity = 300 },
	{ probability = 0.3, materials = { "cc_deceleratium" }, quantity = 500 },
	{ probability = 0.3, materials = { "cc_heftium" }, quantity = 500 },
	{ probability = 0.2, materials = { "cc_stillium" }, quantity = 500 },
	{ probability = 0.1, materials = { "t_giga_slicing_liquid" }, quantity = 500 },
}

return materials
