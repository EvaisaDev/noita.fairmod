--- @class random_alchemy
--- @field input_cell1? string
--- @field input_cell2? string
--- @field output_cell1? string
--- @field output_cell2? string
--- @field probability? string
--- @field [string] string

--- @type random_alchemy[]
local reactions = {
	{
		input_cell1 = "[fire]",
		input_cell2 = "water",
		probability = "60",
	},
	{
		input_cell1 = "urine",
		input_cell2 = "wood_static",
	},
	{
		input_cell1 = "poo",
		input_cell2 = "wood_static",
	},
	{
		input_cell1 = "poo",
		input_cell2 = "urine",
	},
	{
		input_cell1 = "fire",
		input_cell2 = "wood_static",
	},
	{
		input_cell1 = "grass",
		input_cell2 = "blood",
		output_cell1 = "material_rainbow",
	},
	{
		input_cell1 = "coal",
		input_cell2 = "[water]",
	},
	{
		input_cell1 = "steel_static",
		input_cell2 = "[fire]",
	},
	{
		input_cell1 = "sand_static",
		input_cell2 = "[lava]",
	},
	{
		input_cell1 = "[lava]",
		input_cell2 = "urine",
	},
	{
		output_cell1 = "fungi",
		output_cell2 = "blood_fungi",
	},
	{
		output_cell1 = "air",
		output_cell2 = "air",
	},
	{
		direction = "top",
	},
	{
		direction = "bottom",
	},
	{
		direction = "left",
	},
	{
		direction = "right",
	},
	{
		input_cell1 = "rock_hard",
	},
	{
		input_cell1 = "rock_static_radioactive",
	},
	{
		input_cell1 = "sand_static_rainforest",
	},
	{
		input_cell1 = "cement",
	},
	{
		input_cell1 = "oil",
	},
	{
		input_cell1 = "slime",
	},
	{
		input_cell1 = "peat",
	},
	{
		input_cell1 = "water_swamp",
	},
	{
		output_cell1 = "void_liquid",
		output_cell2 = "void_liquid",
	},
	{
		input_cell1 = "blood_worm",
	},
	{
		input_cell1 = "material_confusion",
	},
	{
		output_cell1 = "magic_liquid_polymorph",
	},
	{
		output_cell1 = "magic_liquid_unstable_teleportation",
	},
	{
		input_cell1 = "smoke",
		input_cell2 = "[fire]",
	},
	{
		input_cell1 = "smoke",
		input_cell2 = "[earth]",
	},
	{
		input_cell1 = "urine",
		input_cell2 = "radioactive_liquid",
		output_cell1 = "urine",
		output_cell2 = "urine",
	},
	{
		input_cell1 = "poo",
		input_cell2 = "radioactive_liquid",
		output_cell1 = "poo",
		output_cell2 = "poo",
		direction = "top",
	},
	{
		input_cell1 = "poison",
		input_cell2 = "air",
		output_cell1 = "slime",
		output_cell2 = "slime",
	},
	{
		input_cell1 = "[meat]",
		input_cell2 = "magic_liquid_worm_attractor",
		output_cell1 = "air",
		output_cell2 = "air",
		probability = "0.01",
		entity = "data/entities/animals/worm_tiny.xml",
	},
	{
		input_cell1 = "[meat]",
		input_cell2 = "air",
		output_cell1 = "air",
		output_cell2 = "air",
		probability = "0.01",
		entity = "mods/noita.fairmod/files/content/random_alchemy/hamis_spawner_limited.xml",
	},
	{
		input_cell1 = "blood",
		input_cell2 = "poo",
		output_cell1 = "magic_liquid_hp_regeneration",
		output_cell2 = "poo",
	},
	{
		input_cell1 = "gunpowder_explosive",
		input_cell2 = "[fire]",
		output_cell1 = "fairmod_tntinium",
		output_cell2 = "[fire]",
	},
	{
		input_cell1 = "metal_rust",
		input_cell2 = "air",
		probability = "0.01",
		output_cell1 = "fairmod_minecartium",
		output_cell2 = "air",
	},
}

return reactions
