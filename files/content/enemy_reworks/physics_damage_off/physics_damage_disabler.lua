-- disables physics damage for steve and skoude

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local list = dofile("mods/noita.fairmod/files/content/enemy_reworks/physics_damage_off/enemy_list.lua")

for k, v in ipairs(list) do
	local file = "data/entities/animals/" .. v
	for xml in nxml.edit_file(file) do
		local damage_model = xml:first_of("DamageModelComponent")

		if not damage_model then
			local base = xml:first_of("Base")
			if base then damage_model = base:first_of("DamageModelComponent") end
		end

		if damage_model then damage_model:set("physics_objects_damage", false) end
	end
end
