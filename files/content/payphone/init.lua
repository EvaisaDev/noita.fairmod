ModLuaFileAppend("data/scripts/biomes/temple_altar.lua", "mods/noita.fairmod/files/content/payphone/append_hm.lua")
ModLuaFileAppend("data/scripts/biomes/boss_arena.lua", "mods/noita.fairmod/files/content/payphone/append_hm.lua")

local larpa = dofile("mods/noita.fairmod/files/content/payphone/content/larpa/larpa.lua")

local module = {}

function module.update()

	larpa.update()

	local teleporting_end = tonumber(GlobalsGetValue("teleporting_end", "0"))
	if teleporting_end >= 0 then
		teleporting_end = teleporting_end - 0.1
		GlobalsSetValue("teleporting_end", tostring(teleporting_end))
		-- if over 0.5, find current value by range from 0.5 to 1, scaled to 0 to 1
		if teleporting_end > 0.5 then
			local value = 1 - (teleporting_end - 0.5) * 2

			GameSetPostFxParameter("END_OVERRIDE", value, 0, 0, 0)
			print("value: " .. value)
		elseif teleporting_end == 0.5 then
			BiomeMapLoad_KeepPlayer(MagicNumbersGetValue("BIOME_MAP"), "data/biome/_pixel_scenes")
		elseif teleporting_end < 0.5 then
			local value = teleporting_end * 2

			GameSetPostFxParameter("END_OVERRIDE", value, 0, 0, 0)

			print("value: " .. value)
		end

		if teleporting_end <= 0 then
			local players = EntityGetWithTag("player_unit") or {}

			if players == nil or #players == 0 then return end

			local player = players[1]

			local x, y = EntityGetTransform(player)

			EntityLoad("mods/noita.fairmod/files/content/payphone/content/rift/fake_portal.xml", x + 100, y)

			EntityLoad("data/entities/particles/teleportation_source.xml", x + 100, y)
		end
	end
end

return module
