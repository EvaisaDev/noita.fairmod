local color = 0xff83cd36

local positions = {
	{ 39, 30 },
	{ 40, 30 },
	{ 41, 30 },
	-- { 40, 31 }, -- secret treasure room
	{ 40, 32 },
	{ 41, 31 },
	{ 41, 32 },
	{ 42, 31 },
	{ 43, 31 },
	{ 43, 30 },
	{ 43, 29 },
	{ 42, 32 },
	{ 43, 32 },
	{ 44, 32 },
	{ 45, 32 },
	{ 44, 31 },
	{ 45, 31 },
	{ 44, 30 },
	{ 45, 30 },
	{ 45, 29 },
	{ 46, 29 },
	{ 46, 30 },
	{ 46, 31 },
	{ 46, 32 },
}

for _, position in ipairs(positions) do
	BiomeMapSetPixel(position[1], position[2], color)
end
