local player = GetUpdatedEntityID()
local x, y = EntityGetTransform(player)

if ModSettingGet("noita.fairmod.arachnophilia_mode") then
	local spider_chance = 50

	local spider_list = {
		{
			path = "data/entities/animals/longleg.xml", -- hämis
			weight = 100,
			required_mountains = 0, -- how many mountains does the player need to have visited
		},
		{
			path = "data/entities/animals/lukki/lukki_tiny.xml", -- hämis
			weight = 60,
			required_mountains = 1, -- how many mountains does the player need to have visited
		},
		{
			path = "data/entities/animals/lukki/lukki.xml", -- hämis
			weight = 40,
			required_mountains = 3, -- how many mountains does the player need to have visited
		},
		{
			path = "data/entities/animals/lukki/lukki_longleg.xml", -- hämis
			weight = 30,
			required_mountains = 4, -- how many mountains does the player need to have visited
		},
		{
			path = "data/entities/animals/lukki/lukki_creepy_long.xml", -- hämis
			weight = 2,
			required_mountains = 6, -- how many mountains does the player need to have visited
		},
		{
			path = "data/entities/animals/lukki/lukki_dark.xml", -- hämis
			weight = 1,
			required_mountains = 7, -- how many mountains does the player need to have visited
		},
	}

	function PickSpider()
		local holy_mountain_count = tonumber(GlobalsGetValue("HOLY_MOUNTAIN_VISITS", "0")) or 0
		local total_weight = 0
		local available_spiders = {}

		-- Collect spiders that meet the required mountain visits
		for _, spider in ipairs(spider_list) do
			if spider.required_mountains <= holy_mountain_count then
				table.insert(available_spiders, spider)
				total_weight = total_weight + spider.weight
			end
		end

		-- Return nil if no spiders are available
		if total_weight == 0 then return nil end

		-- Randomly select a spider based on weight
		local random_pick = Random(1, total_weight)
		local accumulated_weight = 0

		for _, spider in ipairs(available_spiders) do
			accumulated_weight = accumulated_weight + spider.weight
			if accumulated_weight >= random_pick then return spider end
		end

		return nil
	end

	local enemies = EntityGetInRadiusWithTag(x, y, 256, "enemy") or {}

	for i, enemy in ipairs(enemies) do
		if Random(1, 100) > spider_chance then
			EntityAddTag(enemy, "spider_check_finished")
			goto continue
		end
		if not EntityHasTag(enemy, "spider_check_finished") then
			local genome_comp = EntityGetFirstComponent(enemy, "GenomeDataComponent")

			if genome_comp ~= nil then
				local genome = HerdIdToString(ComponentGetValue2(genome_comp, "herd_id"))
				if genome == "spider" then
					EntityAddTag(enemy, "spider_check_finished")
					goto continue
				end
			end

			local ex, ey = EntityGetTransform(enemy)
			EntityKill(enemy)

			local spider = PickSpider()
			if spider ~= nil then
				local enemy = EntityLoad(spider.path, ex, ey)

				EntityAddTag(enemy, "spider_check_finished")
			end
		end
		::continue::
	end
end
