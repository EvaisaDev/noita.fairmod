--stylua: ignore start
local pos_x = 40
local pos_y = 31
if ModIsEnabled("Apotheosis") == true then
    pos_x = 56
    pos_y = 32
end
local size_x = 2
local size_y = 2

for x=1,size_y do
    for y=1,size_y do
        BiomeMapSetPixel( x + pos_x - 1, y + pos_y - 1, 0xff83cd35 )
    end
end
--stylua: ignore end