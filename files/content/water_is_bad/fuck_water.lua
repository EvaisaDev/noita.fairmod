local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local material_file = "data/materials.xml"

local water_to_fuckup = { "water", "water_static", "water_ice", "water_swamp", "water_salt", "swamp" }

local function is_water(name)
	for i = 1, #water_to_fuckup do
		if name == water_to_fuckup[i] then return true end
	end
	return false
end

local materials = nxml.parse(ModTextFileGetContent(material_file))

for reaction in materials:each_of("Reaction") do
	local attr = reaction.attr

	if attr.input_cell2 == "radioactive_liquid" and is_water(attr.input_cell1) then
		attr.output_cell1 = "cement"
		attr.output_cell2 = "cement"
	end

	if is_water(attr.input_cell2) then
		if attr.input_cell1 == "[lava]" then
			attr.output_cell1 = "gunpowder_unstable"
			attr.output_cell2 = "rainbow_gas"
		end
		if attr.input_cell1 == "magic_liquid_mana_regeneration" then
			attr.output_cell1 = "lava"
		end
	end
end

-- for celldata in materials:each_of("CellData") do
-- 	if is_water(celldata.attr.name) then
-- 		local graphics = celldata:first_of("Graphics")
-- 		if graphics then
-- 			graphics.attr.texture_file = "mods/noita.fairmod/files/content/water_is_bad/concrete_wet.png"
-- 		else
-- 			celldata:add_child(nxml.new_element("Graphics",
-- 				{ texture_file = "mods/noita.fairmod/files/content/water_is_bad/concrete_wet.png" }))
-- 		end
-- 	end
-- end

ModTextFileSetContent(material_file, tostring(materials))
