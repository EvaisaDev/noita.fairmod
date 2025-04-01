local color = 0xff83cd35

local positions = {
	--{ 42, 24 }, -- cauldron entrance
	{ 42, 25 },
	{ 42, 26 },
	{ 42, 27 },
	{ 43, 26 },
	{ 43, 27 },
	{ 43, 28 },
	{ 44, 27 },
	{ 45, 27 },
	{ 45, 28 },
	{ 46, 27 },
	{ 46, 28 },
	{ 47, 27 },
	{ 45, 25 },
	{ 46, 25 },
	{ 47, 25 },
	{ 45, 26 },
	{ 46, 26 },
	{ 47, 26 },
}

for _, position in ipairs(positions) do
	BiomeMapSetPixel(position[1], position[2], color)
end
