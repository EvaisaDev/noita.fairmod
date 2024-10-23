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
	},
	["athousandsnailsplease"] = {
        name = "A thousand snails",
        description = "Are you sure about this??",
        func = function(player)
			local x, y = EntityGetTransform(player)
			SetRandomSeed(x, y)
            for i = 1, 1000 do
				-- get a random angle radian
				local angle = math.rad(Random(0, 360))
				-- get a random direction vector
				local dx = math.cos(angle)
				local dy = math.sin(angle)

				local distance = Random(100, 150)

				EntityLoad("mods/noita.fairmod/files/content/immortal_snail/entities/snail.xml", x + (dx * distance), y + (dy * distance))
			end
        end,
    },
}