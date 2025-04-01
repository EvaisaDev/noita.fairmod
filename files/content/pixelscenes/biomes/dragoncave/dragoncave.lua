function init(x, y, w, h)
	LoadPixelScene(
		"mods/noita.fairmod/files/content/pixelscenes/biomes/dragoncave/scene/scene.png",
		"mods/noita.fairmod/files/content/pixelscenes/biomes/dragoncave/scene/scene_visual.png",
		x,
		y,
		"",
		true
	)
	EntityLoad("mods/noita.fairmod/files/content/pixelscenes/biomes/dragoncave/entity/egg.xml", x + 300, y + 310)
end
