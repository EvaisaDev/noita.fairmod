local old_spawn_hp = spawn_hp
function spawn_hp(x, y)
	old_spawn_hp(x, y)

	EntityLoad("mods/noita.fairmod/files/content/loan_shark/loanshark.xml", x - 199, y + 62)
	LoadBackgroundSprite("mods/noita.fairmod/files/content/loan_shark/door_background.png", x - 199 - 23, y + 62 - 53)
end

