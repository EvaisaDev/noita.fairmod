dofile_once("data/scripts/perks/perk.lua")

return {
	spawn_wand = function(player, x, y)
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
	spawn_spell = function(player, x, y)
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
	spawn_potion = function(player, x, y)
		_, x, y = RaytraceSurfaces(x, y, x, y + 100)
		EntityLoad("data/entities/items/pickup/potion_starting.xml", x, y)
	end,
	spawn_perk = function(player, x, y)
		local pid = perk_spawn_random( x, y )
		perk_pickup( pid, player, "", true, false )
	end,
}