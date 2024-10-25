--- Lamia rewrited this file, sorry

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

local catastrophicMaterials = {
	creepy_liquid = true,
	monster_powder_test = true,
	totallyBogusMaterial = true,
	t_omega_slicing_liquid = true,
	aa_chaotic_pandorium = true,
	aa_unstable_pandorium = true,
} -- Catastrophic Materials list

local function add_tag(tags, tag)
	if not tags then return tag end
	return tags .. "," .. tag
end

--- Parses an xml element
--- @param element element
local function parse_element(element)
	local attr = element.attr
	if catastrophicMaterials[attr.name] then
		attr.tags = add_tag(attr.tags, ",[catastrophic],[NO_FUNGAL_SHIFT]")
		print("Fairmod: Added tag [catastrophic] to " .. attr.name)
	elseif attr.convert_to_box2d_material or attr.solid_break_to_type or attr.cell_type == "solid" then
		attr.tags = add_tag(attr.tags, ",[NO_FUNGAL_SHIFT]")
	end
end

--- Parses a file
--- @param file string
local function parse_file(file)
	local success, result = pcall(nxml.parse, ModTextFileGetContent(file))
	if not success then
		print("couldn't parse material file " .. file)
		return
	end
	local xml = result

	for _, element_name in ipairs({ "CellData", "CellDataChild" }) do
		for elem in xml:each_of(element_name) do
			parse_element(elem)
		end
	end
end

local files = ModMaterialFilesGet()
for i = 1, #files do
	parse_file(files[i])
end
