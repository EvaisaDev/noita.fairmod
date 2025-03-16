local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local material_file = "data/materials.xml"

local water_to_fuckup = {
	water = true,
	water_static = true,
	water_ice = true,
	water_swamp = true,
	water_salt = true,
	swamp = true,
}

local materials = nxml.parse(ModTextFileGetContent(material_file))

for reaction in materials:each_of("Reaction") do
	local attr = reaction.attr
	local input1, input2 = attr.input_cell1, attr.input_cell2

	if input2 == "radioactive_liquid" and water_to_fuckup[input1] then
		attr.output_cell1, attr.output_cell2 = "cement", "cement"
	elseif water_to_fuckup[input2] then
		if input1 == "[lava]" then
			attr.output_cell1, attr.output_cell2 = "gunpowder_unstable", "rainbow_gas"
		elseif input1 == "magic_liquid_mana_regeneration" then
			attr.output_cell1 = "lava"
		end
	end
end

ModTextFileSetContent(material_file, tostring(materials))
