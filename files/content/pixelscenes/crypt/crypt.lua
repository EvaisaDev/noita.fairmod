local vertical = {
	{
		prob = 0.5,
		material_file = "mods/noita.fairmod/files/content/pixelscenes/snail/snail_v_220_440.png",
		visual_file = "mods/noita.fairmod/files/content/pixelscenes/snail/snail_v_220_440_visual.png",
		background_file = "",
		is_unique = 0,
	},
}

local vertical_index = #g_pixel_scene_03
for i = 1, #vertical do
	g_pixel_scene_03[vertical_index + i] = vertical[i]
end
