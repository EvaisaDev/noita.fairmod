local vertical = {
	{
		prob = 0.5,
		material_file = "mods/noita.fairmod/files/content/pixelscenes/snail/snail_v_220_440.png",
		visual_file = "mods/noita.fairmod/files/content/pixelscenes/snail/snail_v_220_440_visual.png",
		background_file = "",
		is_unique = 1,
	},
}

local more_bullshit_traps =
{
	total_prob = 0,
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/crystal_red.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/crystal_pink.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/crystal_green.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/physics_vase.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/props/physics_vase_longleg.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/animals/mimic_physics.xml"
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

function spawn_scorpions(x, y)
	spawn(g_scorpions, x, y)
	spawn(more_bullshit_traps, x, y - 12, 0, 0)
end

function spawn_statues(x, y)
	spawn(g_statues, x - 4, y)
	spawn(more_bullshit_traps, x, y - 12, 0, 0)
end
