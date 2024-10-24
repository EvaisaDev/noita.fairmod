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
	["ahundredsnailsplease"] = {
        name = "A hundred snails",
        description = "Are you sure about this??",
        func = function(player)
			local x, y = EntityGetTransform(player)

            for i = 1, 100 do
				-- get a random angle radian
				local angle = math.rad(Random(0, 360))
				-- get a random direction vector
				local dx = math.cos(angle)
				local dy = math.sin(angle)

				local distance = Random(100, 250)

				local target_x = x + (dx * distance)
				local target_y = y + (dy * distance)

				local hit = RaytracePlatforms(target_x, target_y, target_x, target_y - 5)

				if(not hit)then
					EntityLoad("mods/noita.fairmod/files/content/immortal_snail/entities/snail.xml", target_x, target_y)
				end
			end
        end,
    },
	["dingus"] = {
        name = "Dingus",
        description = "He looks so polite!!",
        func = function(player)
			local x, y = EntityGetTransform(player)

			EntityLoad("mods/noita.fairmod/files/content/dingus/dingus.xml", x, y)
        end,
    },
}