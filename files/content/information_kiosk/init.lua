local module = {}

module.spawn_kiosk = function(x, y)
	EntityLoad("mods/noita.fairmod/files/content/information_kiosk/information_hamis.xml", x + 10, y + 11)
end

return module
