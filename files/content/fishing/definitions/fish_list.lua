fish_list = {
	{
		id = "basic_fish",
		name = "Eväkäs",
		description = "A common fish.",
		drop_fish = true,
		splash_screen = true,
		always_discovered = true,
		sizes = {min = 0.2, max = 2.5},
		price = 10000,
		probability = 100,
		difficulty = 5,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/basic_fish.png",
		func = function(fish, x, y)

		end
	},
	{
		id = "basic_fish2",
		name = "Suureväkäs ",
		description = "A large common fish.",
		drop_fish = true,
		splash_screen = true,
		always_discovered = true,
		sizes = {min = 1.0, max = 4.5},
		price = 10000,
		probability = 100,
		difficulty = 5,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/basic_fish_2.png",
		func = function(fish, x, y)

		end
	},
	{
		id = "hamis_fish",
		name = "Aquatic Hämis",
		description = "This hämis seems to have evolved to live in water.",
		drop_fish = true,
		splash_screen = true,
		always_discovered = false,
		sizes = {min = 1.0, max = 4.5},
		price = 10000,
		probability = 100,
		difficulty = 5,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/hamisfish.png",
		func = function(fish, x, y)

		end
	},
	{
		id = "eel",
		name = "Nahkiainen",
		description = "Seems to be some kind of weird Lamprey",
		drop_fish = true,
		splash_screen = true,
		always_discovered = true,
		sizes = {min = 2.0, max = 9.0},
		price = 10000,
		probability = 100,
		difficulty = 5,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/eel.png",
		func = function(fish, x, y)

		end
	},
	{
		id = "squid",
		name = "Pikkuturso",
		description = "Seems to be some kind of weird Lamprey",
		drop_fish = true,
		splash_screen = true,
		always_discovered = false,
		sizes = {min = 1.5, max = 4.0},
		price = 10000,
		probability = 100,
		difficulty = 5,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/tentacler.png",
		func = function(fish, x, y)

		end
	},
	{
		id = "flask",
		name = "Flask",
		description = "A potion flask with some kind of material inside.",
		drop_fish = false,
		splash_screen = true,
		always_discovered = false,
		sizes = {min = 0.5, max = 5.0},
		price = 10000,
		probability = 100,
		difficulty = 5,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/potion.png",
		func = function(fish, x, y)
			print("Potion fish caught")
			_, x, y = RaytraceSurfaces(x, y, x, y + 100)
			EntityLoad("data/entities/items/pickup/potion_starting.xml", x, y)
		end
	},
}

--[[
for i = 1, 20 do
	table.insert(fish_list, {
		id = "debug_fish_"..i,
		name = "Debug Fish",
		description = "It seems to be a fish for testing purposes.",
		drop_fish = true,
		splash_screen = true,
		always_discovered = true,
		sizes = {min = 3, max = 15.5},
		price = 10000,
		probability = 100,
		difficulty = 5,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/debug_fish.png",
		catch_background = "mods/noita.fairmod/files/content/fishing/files/ui/catch_backgrounds/default.png",
		log_background = "mods/noita.fairmod/files/content/fishing/files/ui/logbook/log_backgrounds/default.png",
		depth = {min = -1000000, max = 1000000},
		func = function(fish, x, y)

		end
	})
end
]]