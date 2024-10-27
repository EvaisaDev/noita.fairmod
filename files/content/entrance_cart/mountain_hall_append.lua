local old_init = init
init = function(x, y, w, h)
	old_init(x, y, w, h)

	EntityLoad("mods/noita.fairmod/files/content/entrance_cart/ghost_minecart_spawner.xml", x + 520, y + 610)
end
