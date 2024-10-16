local old_spawn_hp = spawn_hp
function spawn_hp(x, y)
	old_spawn_hp(x, y)

	EntityLoad("mods/noita.fairmod/files/content/gamblecore/slotmachine.xml", x - 110, y + 41)
end

