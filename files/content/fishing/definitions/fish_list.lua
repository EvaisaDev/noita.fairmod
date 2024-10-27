dofile_once("data/scripts/lib/utilities.lua")
dofile("data/scripts/gun/gun_actions.lua")

fish_list = {
	{
		id = "basic_fish",
		name = "Eväkäs",
		description = "A common fish.",
		drop_fish = false,
		splash_screen = true,
		sizes = { min = 0.2, max = 2.5 },
		price = 10000,
		probability = 100,
		difficulty = 5,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/basic_fish.png",
		func = function(fish, x, y)
			LoadRagdoll("data/ragdolls/fish_01/filenames.txt", x, y, "meat_helpless", 1, 0, 0)
		end,
	},
	{
		id = "basic_fish2",
		name = "Suureväkäs ",
		description = "A large common fish.",
		drop_fish = false,
		splash_screen = true,
		always_discovered = true,
		sizes = { min = 1.0, max = 4.5 },
		price = 10000,
		probability = 100,
		difficulty = 5,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/basic_fish_2.png",
		func = function(fish, x, y)
			LoadRagdoll("data/ragdolls/fish_02/filenames.txt", x, y, "meat_helpless", 1, 0, 0)
		end,
	},
	{
		id = "hamis_fish",
		name = "Aquatic Hämis",
		description = "This hämis seems to have evolved to live in water.",
		drop_fish = false,
		splash_screen = true,
		sizes = { min = 1.0, max = 4.5 },
		price = 10000,
		probability = 80,
		difficulty = 5,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/hamisfish.png",
		func = function(fish, x, y)
			LoadRagdoll("data/ragdolls/longleg/filenames.txt", x, y, "meat_helpless", 1, 0, 0)
		end,
	},
	{
		id = "eel",
		name = "Nahkiainen",
		description = "Seems to be some kind of weird Lamprey",
		drop_fish = false,
		splash_screen = true,
		always_discovered = true,
		sizes = { min = 2.0, max = 9.0 },
		price = 10000,
		probability = 40,
		difficulty = 8,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/eel.png",
		func = function(fish, x, y)
			LoadRagdoll(
				"mods/noita.fairmod/files/content/fishing/ragdolls/worm/filenames.txt",
				x,
				y,
				"meat_helpless",
				1,
				0,
				0
			)
		end,
	},
	{
		id = "squid",
		name = "Pikkuturso",
		description = "A.. squid?",
		drop_fish = false,
		splash_screen = true,
		sizes = { min = 1.5, max = 4.0 },
		price = 10000,
		probability = 40,
		difficulty = 5,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/tentacler.png",
		func = function(fish, x, y)
			LoadRagdoll("data/ragdolls/tentacler_small/filenames.txt", x, y, "meat_helpless", 1, 0, 0)
		end,
	},
	{
		id = "flask",
		name = "Flask",
		description = "A potion flask with some kind of material inside.",
		drop_fish = false,
		splash_screen = true,
		sizes = { min = 0.5, max = 5.0 },
		price = 10000,
		probability = 50,
		difficulty = 5,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/potion.png",
		func = function(fish, x, y)
			_, x, y = RaytraceSurfaces(x, y, x, y + 100)
			EntityLoad("data/entities/items/pickup/potion_starting.xml", x, y)
		end,
	},
	{
		id = "wand",
		name = "Wand",
		description = "You caught a wand! Very cool.",
		drop_fish = false,
		splash_screen = true,
		sizes = { min = 0.5, max = 5.0 },
		price = 10000,
		probability = 30,
		difficulty = 5,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/wand.png",
		func = function(fish, x, y)
			SetRandomSeed(x, y)

			local biomes = {
				[1] = 0,
				[2] = 0,
				[3] = 0,
				[4] = 1,
				[5] = 1,
				[6] = 1,
				[7] = 2,
				[8] = 2,
				[9] = 2,
				[10] = 2,
				[11] = 2,
				[12] = 2,
				[13] = 3,
				[14] = 3,
				[15] = 3,
				[16] = 3,
				[17] = 4,
				[18] = 4,
				[19] = 4,
				[20] = 4,
				[21] = 5,
				[22] = 5,
				[23] = 5,
				[24] = 5,
				[25] = 6,
				[26] = 6,
				[27] = 6,
				[28] = 6,
				[29] = 6,
				[30] = 6,
				[31] = 6,
				[32] = 6,
				[33] = 6,
			}

			local biomepixel = math.floor(y / 512)
			local biomeid = biomes[biomepixel] or 0

			if biomepixel > 35 then biomeid = 7 end

			if biomeid < 1 then biomeid = 1 end
			if biomeid > 6 then biomeid = 6 end

			local item = "data/entities/items/"

			local r = Random(0, 100)
			if r <= 50 then
				item = item .. "wand_level_0"
			else
				item = item .. "wand_unshuffle_0"
			end

			item = item .. tostring(biomeid) .. ".xml"

			biomeid = (0.5 * biomeid) + (0.5 * biomeid * biomeid)

			EntityLoad(item, x, y)
		end,
	},
	{
		id = "spell",
		name = "Spell",
		description = "You caught a spell! Hope it's a good one.",
		drop_fish = false,
		splash_screen = true,
		sizes = { min = 0.5, max = 5.0 },
		price = 10000,
		probability = 40,
		difficulty = 5,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/spell.png",
		func = function(fish, x, y)
			SetRandomSeed(x, y)

			local biomes = {
				[1] = 0,
				[2] = 0,
				[3] = 0,
				[4] = 1,
				[5] = 1,
				[6] = 1,
				[7] = 2,
				[8] = 2,
				[9] = 2,
				[10] = 2,
				[11] = 2,
				[12] = 2,
				[13] = 3,
				[14] = 3,
				[15] = 3,
				[16] = 3,
				[17] = 4,
				[18] = 4,
				[19] = 4,
				[20] = 4,
				[21] = 5,
				[22] = 5,
				[23] = 5,
				[24] = 5,
				[25] = 6,
				[26] = 6,
				[27] = 6,
				[28] = 6,
				[29] = 6,
				[30] = 6,
				[31] = 6,
				[32] = 6,
				[33] = 6,
			}

			local biomepixel = math.floor(y / 512)
			local biomeid = biomes[biomepixel] or 0

			if biomepixel > 35 then biomeid = 7 end

			local item = ""
			local cardcost = 0

			-- Note( Petri ): Testing how much squaring the biomeid for prices affects things
			local level = biomeid
			biomeid = biomeid * biomeid

			item = GetRandomAction(x, y, level, 0)
			cardcost = 0

			for i, thisitem in ipairs(actions) do
				if string.lower(thisitem.id) == string.lower(item) then
					price = math.max(math.floor(((thisitem.price * 0.30) + (70 * biomeid)) / 10) * 10, 10)
					cardcost = price

					if thisitem.spawn_requires_flag ~= nil then
						local flag = thisitem.spawn_requires_flag

						if HasFlagPersistent(flag) == false then
							print(
								"Trying to spawn "
									.. tostring(thisitem.id)
									.. " even though flag "
									.. tostring(flag)
									.. " not set!!"
							)
						end
					end
				end
			end

			CreateItemActionEntity(item, x, y)
		end,
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
		sizes = {min = 3, max = 15.5},
		price = 10000,
		probability = 100,
		difficulty = 5,
		catch_seconds = 3,
		sprite = "mods/noita.fairmod/files/content/fishing/files/fish/sprites/standard_fish.png",
		ui_sprite = "mods/noita.fairmod/files/content/fishing/files/ui/fish/debug_fish.png",
		catch_background = "mods/noita.fairmod/files/content/fishing/files/ui/catch_backgrounds/default.png",
		depth = {min = -1000000, max = 1000000},
		func = function(fish, x, y)

		end
	})
end
]]
