local nxml = dofile("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
nxml.error_handler = function() end



local function visit(element)
	element:set("materials_damage", false)
	element:set("physics_objects_damage", false)

	-- get damage_multipliers 
	local damage_multipliers = element:first_of("damage_multipliers")

	-- if it doesn't exist, create it
	if damage_multipliers == nil then
		damage_multipliers = nxml.new_element("damage_multipliers")
		element:add_child(damage_multipliers)
	end

	damage_multipliers:set("electricity", "0.0")
	damage_multipliers:set("ice", "0.0")
end

local filenames = dofile_once("mods/noita.fairmod/files/content/stronger_bosses/filenames.lua")
for _, filename in ipairs(filenames) do
	for content in nxml.edit_file(filename) do
		local base = content:first_of("Base")
		local damage_comp = base and base:first_of("DamageModelComponent")
			or content:first_of("DamageModelComponent")
		if damage_comp then visit(damage_comp) end
	end
end
