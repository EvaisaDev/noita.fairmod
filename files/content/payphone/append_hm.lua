local old_spawn_hp = spawn_hp
function spawn_hp(x, y)
	old_spawn_hp(x, y)

	EntityLoad("mods/noita.fairmod/files/content/payphone/payphone.xml", x - 257, y + 47)
end
