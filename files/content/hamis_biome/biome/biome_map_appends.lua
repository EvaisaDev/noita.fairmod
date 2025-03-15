local color = 0xff83cd36

local positions = {
	{ 40, 31 },
	{ 41, 31 },
	{ 42, 31 },
	{ 43, 31 },
	{ 43, 30 },
	{ 43, 29 },
}

for _, position in ipairs(positions) do
	BiomeMapSetPixel(position[1], position[2], color)
end
