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
		probability = "5",
		entity = "data/entities/animals/longleg.xml",
		output_cell1 = "air",
		output_cell2 = "air",
	},
	{
		probability = "5",
		entity = "data/entities/animals/worm.xml",
		output_cell1 = "air",
		output_cell2 = "air",
	},
	{
		probability = "5",
		entity = "data/entities/animals/fish.xml",
		output_cell1 = "air",
		output_cell2 = "air",
	},
	{
		probability = "5",
		entity = "mods/noita.fairmod/files/content/enemy_reworks/fish/fish.xml",
		output_cell1 = "air",
		output_cell2 = "air",
	},
	{
		probability = "5",
		entity = "data/entities/animals/rat.xml",
		output_cell1 = "air",
		output_cell2 = "air",
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
}

return reactions
