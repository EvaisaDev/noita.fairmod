-- convert_to_box2d_material

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local material_file = "data/materials.xml"
local materials = nxml.parse(ModTextFileGetContent(material_file))

for _, data in ipairs({ "CellData", "CellDataChild" }) do
	for material in materials:each_of(data) do
		local attr = material.attr
		if attr.convert_to_box2d_material or attr.solid_break_to_type or attr.cell_type == "solid" then
			if attr.tags then
				attr.tags = attr.tags .. ",[NO_FUNGAL_SHIFT]"
			else
				attr.tags = "[NO_FUNGAL_SHIFT]"
			end
		end
	end
end

ModTextFileSetContent(material_file, tostring(materials))
