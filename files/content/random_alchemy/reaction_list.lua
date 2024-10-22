--- @class random_alchemy
--- @field input_cell1 string
--- @field input_cell2 string
--- @field output_cell1? string
--- @field output_cell2? string
--- @field probability? string

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
}

return reactions
