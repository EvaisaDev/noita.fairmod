---@type nxml
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")
---@param path string
local function do_sniper(path)
	for xml in nxml.edit_file(path) do
		local ai = xml:first_of("Base"):first_of("AnimalAIComponent")
		if not ai then error("sniper has no brain :(") end
		ai:set("attack_ranged_use_laser_sight", false)
		local kill = nil
		for sprite in xml:each_of("SpriteComponent") do
			local tags = sprite:get("_tags") or ""
			if tags:find("laser") then
				kill = sprite
				break
			end
		end
		if kill then xml:remove_child(kill) end
	end
end

do_sniper("data/entities/animals/sniper.xml")
do_sniper("data/entities/animals/sniper_hell.xml")
do_sniper("data/entities/animals/turret_right.xml")
do_sniper("data/entities/animals/tank_rocket.xml")
do_sniper("data/entities/animals/missilecrab.xml")
