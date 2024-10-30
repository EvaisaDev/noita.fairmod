local vertical = {
	{
		prob = 0.5,
		material_file = "mods/noita.fairmod/files/content/pixelscenes/snail/snail_v_220_440.png",
		visual_file = "mods/noita.fairmod/files/content/pixelscenes/snail/snail_v_220_440_visual.png",
		background_file = "",
		is_unique = 1,
	},
}

local vertical_index = #g_pixel_scene_03
for i = 1, #vertical do
	g_pixel_scene_03[vertical_index + i] = vertical[i]
end

function spawn_unique_enemy(x, y)
	for i = 1, 12 do
		spawn(g_unique_enemy, x - 1, y - 60 + i * 10, 0, 0)
	end
end

function spawn_large_enemies(x, y)
	for i = 1, 12 do
		spawn(g_large_enemies, x - 1, y - 60 + i * 10, 0, 0)
	end
end
