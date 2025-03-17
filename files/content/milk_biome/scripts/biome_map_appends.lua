local color = 0xff83cd35

local positions = {
	{ 42, 25 },
	{ 42, 26 },
	{ 42, 27 },
	{ 43, 27 },
	{ 43, 28 },
}

for _, position in ipairs(positions) do
	BiomeMapSetPixel(position[1], position[2], color)
end

-- for x=1,size_x do
--     for y=1,size_y do
--         BiomeMapSetPixel( x + pos_x - 1, y + pos_y - 1, color )
--     end
-- end
