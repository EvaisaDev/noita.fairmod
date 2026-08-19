


local old_init = init
function init( x, y, w, h )
	old_init(x, y, w, h)
	EntityLoad("mods/noita.fairmod/files/content/entrance_cart/chasm_minecart_spawner.xml", x + w / 2, y + h / 2)
end
