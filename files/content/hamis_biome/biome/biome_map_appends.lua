local color = 0xff83cd36

local positions = {
	{ 39, 30 },
	{ 40, 30 },
	{ 41, 30 },
	{ 40, 31 },
	{ 40, 32 },
	{ 41, 31 },
	{ 41, 32 },
	{ 42, 31 },
	{ 43, 31 },
	{ 43, 30 },
	{ 43, 29 },
}

for _, position in ipairs(positions) do
	BiomeMapSetPixel(position[1], position[2], color)
end
