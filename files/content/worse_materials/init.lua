local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

local modifications = {
	["magic_liquid_protection_all"] = function(celldata)
		celldata:set("status_effects", "PROTECTION_NONE")
	end
}

for materials in nxml.edit_file("data/materials.xml") do
	for celldata in materials:each_of("CellData") do
		local name = celldata.attr.name
		if modifications[name] then modifications[name](celldata) end
	end
end

ModLuaFileAppend("data/scripts/status_effects/status_list.lua", "mods/noita.fairmod/files/content/worse_materials/append_status_list.lua")