local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")
local pool = dofile_once("mods/noita.fairmod/files/content/corrupted_enemies/projectile_pool.lua")
local ui_rolls = 4
local sprite_rolls = 6
local new_enemy_count = 9
local x_pos = 1
local y_pos = 1
local x_size = 16
local y_size = 16
local year, month, day, hour, minute = GameGetDateAndTimeLocal()
math.randomseed(minute + hour)

do
	local path, csi_enemies = "data/ui_gfx/animal_icons/_list.txt", {}
	for enemy in ModTextFileGetContent(path):gmatch("[^\r\n]+") do
		csi_enemies[#csi_enemies + 1] = enemy
	end
	for k = 1, #csi_enemies do
		ModImageMakeEditable(table.concat({ "data/ui_gfx/animal_icons/", csi_enemies[k], ".png" }), 16, 16)
	end

	for k = 0, new_enemy_count do
		--Generate ui icon
		ModImageMakeEditable(
			table.concat({ "data/ui_gfx/animal_icons/noita.fairmod_enemy_corrupted_0", k, ".png" }),
			16,
			16
		)

		ui_rolls = 4

		for ui_roll = 1, ui_rolls do
			x_pos = math.random(1, 12)
			y_pos = math.random(1, 12)
			x_size = math.random(4, 16)
			y_size = math.random(4, 16)
			local victim_icon = ModImageIdFromFilename(
				table.concat({ "data/ui_gfx/animal_icons/", csi_enemies[math.random(1, #csi_enemies)], ".png" })
			)
			local output_icon = ModImageIdFromFilename(
				table.concat({ "data/ui_gfx/animal_icons/noita.fairmod_enemy_corrupted_0", k, ".png" })
			)
			for x = x_pos, x_size do
				for y = y_pos, y_size do
					local colour = ModImageGetPixel(victim_icon, x, y)
					if colour ~= 0 then ModImageSetPixel(output_icon, x, y, colour) end
				end
			end
		end

		--Generate enemy sprite
		do
			local path = table.concat({
				"mods/noita.fairmod/files/content/corrupted_enemies/gfx/noita.fairmod_enemy_corrupted_0",
				k,
				".xml",
			})
			local content =
				ModTextFileGetContent("mods/noita.fairmod/files/content/corrupted_enemies/gfx/scavenger_smg.xml")
			content = content:gsub(
				'"data/enemies_gfx/scavenger_smg%.png"',
				table.concat({
					'"mods/noita.fairmod/files/content/corrupted_enemies/gfx/noita.fairmod_enemy_corrupted_0',
					k,
					'.png"',
				})
			)
			ModTextFileSetContent(path, content)

			ModImageMakeEditable(
				table.concat({
					"mods/noita.fairmod/files/content/corrupted_enemies/gfx/noita.fairmod_enemy_corrupted_0",
					k,
					".png",
				}),
				120,
				231
			)
			local opts = {
				"scavenger_clusterbomb",
				"scavenger_glue",
				"scavenger_grenade",
				"scavenger_heal",
				"scavenger_invis",
				"scavenger_leader",
				"scavenger_mine",
				"scavenger_poison",
				"scavenger_shield",
				"scavenger_smg",
				"ant",
				"roboguard",
				"roboguard_big",
				"phantom_a",
				"phantom_b",
				"alchemist",
				"ghoul",
				"spitmonster",
				"wizard_wither",
				"zombie",
				"turret",
				"barfer",
				"skullfly",
				"maggot_tiny_head",
			}

			for sprite_roll = 1, sprite_rolls do
				x_pos = math.random(1, 16)
				y_pos = math.random(1, 17)
				x_size = math.random(15, 20)
				y_size = math.random(15, 21)
				local sprite_choice = table.concat({ "data/enemies_gfx/", opts[math.random(1, #opts)], ".png" })
				ModImageMakeEditable(sprite_choice, 300, 400)
				local victim_sprite = ModImageIdFromFilename(sprite_choice)
				local output_sprite = ModImageIdFromFilename(table.concat({
					"mods/noita.fairmod/files/content/corrupted_enemies/gfx/noita.fairmod_enemy_corrupted_0",
					k,
					".png",
				}))

				for grid_x = 1, 6 do
					for grid_y = 1, 11 do
						for x = x_pos, x_size do
							for y = y_pos, y_size do
								local colour =
									ModImageGetPixel(victim_sprite, x + ((grid_x - 1) * 20), y + ((grid_y - 1) * 21))
								if colour ~= 0 then
									ModImageSetPixel(
										output_sprite,
										x + ((grid_x - 1) * 20),
										y + ((grid_y - 1) * 21),
										colour
									)
								end
							end
						end
					end
				end
			end
		end

		--Generate a name
		local adjectives = {
			"Ancient",
			"Brave",
			"Calm",
			"Dark",
			"Eager",
			"Fiery",
			"Golden",
			"Hidden",
			"Icy",
			"Jolly",
			"Keen",
			"Luminous",
			"Mighty",
			"Noble",
			"Proud",
			"Quiet",
			"Radiant",
			"Silent",
			"Thundering",
			"Vast",
			"Wild",
			"Zealous",
			"Glorious",
			"Mystic",
		}
		local nouns = {
			"dragon",
			"phoenix",
			"sword",
			"mountain",
			"river",
			"forest",
			"knight",
			"wolf",
			"lion",
			"storm",
			"shadow",
			"blade",
			"falcon",
			"giant",
			"tiger",
			"whisper",
			"raven",
			"phoenix",
			"hawk",
			"serpent",
			"guardian",
			"flame",
			"warrior",
			"spirit",
		}
		local suffixes = {
			"destruction",
			"slaughter",
			"fury",
			"rage",
			"vengeance",
			"chaos",
			"wrath",
			"conquest",
			"doom",
			"reckoning",
			"havoc",
			"ruin",
			"madness",
			"torment",
			"devastation",
			"annihilation",
			"ascension",
			"rebirth",
			"domination",
			"obliteration",
			"eternity",
			"sorrow",
			"whispers",
			"obliteration",
			"silence",
			"awakening",
			"judgment",
			"shadows",
			"secrets",
			"dawn",
		}

		local suffix = ""
		if math.random(1, 3) == 1 then suffix = table.concat({ " of ", suffixes[math.random(1, #suffixes)] }) end
		local name =
			table.concat({ adjectives[math.random(1, #adjectives)], " ", nouns[math.random(1, #nouns)], suffix })

		--Generate enemy file
		do
			local can_fly = math.random(0, 1)
			--local is_worm = 1 --math.random(1,10)

			local path = table.concat({ "data/entities/animals/noita.fairmod_enemy_corrupted_0", k, ".xml" })
			local content = ModTextFileGetContent("data/entities/animals/scavenger_smg.xml")
			content = content:gsub("$animal_scavenger_smg", name)
			content = content:gsub(
				'"data/entities/projectiles/machinegun_bullet_slower%.xml"',
				table.concat({ '"', pickrandomspell(k, minute), '.xml"' })
			)
			content = content:gsub(
				'attack_ranged_frames_between="24"',
				table.concat({ 'attack_ranged_frames_between="', tostring(math.random(10, 120)), '"' })
			)
			content = content:gsub('hp="1"', table.concat({ 'hp="', tostring(math.random(1, 4)), '"' }))
			content = content:gsub('can_fly="1"', table.concat({ 'can_fly="', tostring(can_fly), '"' }))
			content = content:gsub(
				'"data/enemies_gfx/scavenger_smg%.xml"',
				table.concat({
					'"mods/noita.fairmod/files/content/corrupted_enemies/gfx/noita.fairmod_enemy_corrupted_0',
					k,
					'.xml"',
				})
			)
			content = content:gsub('</Base>', '</Base> <LuaComponent script_source_file="mods/noita.fairmod/files/content/corrupted_enemies/generate_hp.lua" execute_times="1" remove_after_executed="1" > </LuaComponent>')

			-- todo add a 10% chance for a corrupt enemy to be a worm

			ModTextFileSetContent(path, content)
		end
		--Generate spawn file
		do
			local content =
				ModTextFileGetContent("mods/noita.fairmod/files/content/corrupted_enemies/spawnpool_append.lua")
			content = content:gsub("k", k)
			ModTextFileSetContent(
				table.concat({ "mods/noita.fairmod/files/content/corrupted_enemies/spawnpool_append_0", k, ".lua" }),
				content
			)
		end

		--Generate spawn location
		local opts = {
			"wizardcave",
			"coalmine",
			"desert",
			"crypt",
			"pyramid",
			"fungicave",
			"coalmine_alt",
			"pyramid_hallway",
			"excavationsite",
			"fungiforest",
			"snowcave",
			"wandcave",
			"sandcave",
			"winter",
			"rainforest",
			"rainforest_dark",
			"liquidcave",
			"snowcastle",
			"vault",
		}

		local biome = opts[math.random(1, #opts)]

		ModLuaFileAppend(
			table.concat({ "data/scripts/biomes/", biome, ".lua" }),
			table.concat({ "mods/noita.fairmod/files/content/corrupted_enemies/spawnpool_append_0", k, ".lua" })
		)

		--ModLuaFileAppend("data/scripts/biomes/coalmine.lua", table.concat({"mods/noita.fairmod/files/content/corrupted_enemies/spawnpool_append_0",k,".lua"}))
	end
end
