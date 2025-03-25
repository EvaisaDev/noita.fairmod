local horizontal = {
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

local vertical = {
	{
		prob = 0.5,
		material_file = "mods/noita.fairmod/files/content/pixelscenes/longest_leg/longest_v_130_260.png",
		visual_file = "mods/noita.fairmod/files/content/pixelscenes/longest_leg/longest_v_130_260_visual.png",
		background_file = "mods/noita.fairmod/files/content/pixelscenes/longest_leg/longest_v_130_260_background.png",
		is_unique = 1,
	},
}

local vertical_index = #g_pixel_scene_01
for i = 1, #vertical do
	g_pixel_scene_01[vertical_index + i] = vertical[i]
end

RegisterSpawnFunction(0xff523160, "spawn_longest")

function spawn_longest(x, y)
	if GameHasFlagRun("fairmod_longest_spawned") then return end
	GameAddFlagRun("fairmod_longest_spawned")
	EntityLoad("mods/noita.fairmod/files/content/pixelscenes/longest_leg/longest.xml", x, y)
end
