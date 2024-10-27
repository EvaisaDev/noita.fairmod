local horizontal = {
	{
		prob = 0.5,
		material_file = "mods/noita.fairmod/files/content/pixelscenes/coalmine/h_01.png",
		visual_file = "mods/noita.fairmod/files/content/pixelscenes/coalmine/h_01_visual.png",
		background_file = "",
		is_unique = 0,
	},
	{
		prob = 0.5,
		material_file = "mods/noita.fairmod/files/content/pixelscenes/snail/snail_h_260_130.png",
		visual_file = "mods/noita.fairmod/files/content/pixelscenes/snail/snail_h_260_130_visual.png",
		background_file = "",
		is_unique = 1,
	},
}

local horizontal_index = #g_pixel_scene_02
for i = 1, #horizontal do
	g_pixel_scene_02[horizontal_index + i] = horizontal[i]
end
