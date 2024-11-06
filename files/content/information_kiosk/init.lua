local module = {}

module.OnPlayerSpawned = function(x, y, player)
	EntityLoad("mods/noita.fairmod/files/content/information_kiosk/information_hamis.xml", x + 10, y + 11)
	local wallet_component = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
	if wallet_component == nil then return end
	ComponentSetValue2(wallet_component, "money", ComponentGetValue2(wallet_component, "money") + 10)
end

return module
