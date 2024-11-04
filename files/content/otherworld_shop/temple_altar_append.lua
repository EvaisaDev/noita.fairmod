local old_spawn_hp = spawn_hp
function spawn_hp(x, y)
	old_spawn_hp(x, y)

	EntityLoad("mods/noita.fairmod/files/content/otherworld_shop/shop.xml", x + 303, y + 33)
end
