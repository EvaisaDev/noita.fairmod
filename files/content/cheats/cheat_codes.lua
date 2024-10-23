return {
	["motherlode"] = {
		name = "Motherlode",
		description = "You got 1000 gold, you filthy cheater.",
		func = function(player)
			local wallet_component = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
			if(wallet_component == nil) then return end	
			ComponentSetValue2(wallet_component, "money", ComponentGetValue2(wallet_component, "money") + 1000)
		end,
	},
	["duplicateme"] = {
        name = "Dupe",
        description = "There are two of you??",
        func = function(player)
            EntitySetTransform(EntityLoad("data/entities/player_rng_items.xml", x, y), EntityGetTransform(player))
        end,
    },
	["upupdowndownleftrightleftrightbaenter"] = {
		name = "Konami Code",
		description = "Wow you know the konami code, very cool.",
		func = function(player)
		end,
	}
}