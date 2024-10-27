local horizontal = {
	{
		prob = 0.5,
		material_file = "mods/noita.fairmod/files/content/pixelscenes/snail/snail_h_400_200.png",
		visual_file = "mods/noita.fairmod/files/content/pixelscenes/snail/snail_h_400_200_visual.png",
		background_file = "",
		is_unique = 1,
	},
}

local horizontal_index = #g_pixel_scene_04
for i = 1, #horizontal do
	g_pixel_scene_04[horizontal_index + i] = horizontal[i]
end
