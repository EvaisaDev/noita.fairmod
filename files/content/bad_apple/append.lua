local old_spawn_spell_visualizer = spawn_spell_visualizer
function spawn_spell_visualizer(x, y)
	old_spawn_spell_visualizer(x, y)
	EntityLoad("mods/noita.fairmod/files/content/bad_apple/bad_apple.xml", x, y)

	--EntityLoad("mods/noita.fairmod/files/content/bad_apple/bad_apple_audio.xml", x + 78, y + 22)
end
