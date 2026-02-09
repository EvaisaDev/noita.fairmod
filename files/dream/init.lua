function OnPlayerSpawned(player)
	local x,y = EntityGetTransform(player)
	EntityLoad("mods/noita.fairmod/files/dream/empty_kiosk.xml", x + 10, y + 11)
end