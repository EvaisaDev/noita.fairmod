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

local full_data = {} --- @type {[string]:element}

local function is_solid_type(attr)
	if attr.convert_to_box2d_material or attr.solid_break_to_type or attr.cell_type == "solid" then
		return true
	elseif attr._parent then
		return is_solid_type(full_data[attr._parent].attr)
	end
	return false
end

--- Parses an cell element
--- @param element element
local function parse_element(element)
	local attr = element.attr
	if catastrophicMaterials[attr.name] then
		attr.tags = attr.tags and attr.tags .. ",[catastrophic],[NO_FUNGAL_SHIFT]" or "[catastrophic],[NO_FUNGAL_SHIFT]"
		print("Fairmod: Added tag [catastrophic] to " .. attr.name)
	elseif is_solid_type(attr) then
		attr.tags = attr.tags and attr.tags .. ",[NO_FUNGAL_SHIFT]" or "[NO_FUNGAL_SHIFT]"
	end
end

--- Parses a file elements
--- @param xml element
local function parse_file(xml)
	for _, element_name in ipairs({ "CellData", "CellDataChild" }) do
		for elem in xml:each_of(element_name) do
			parse_element(elem)
		end
	end
end

--- Writes a data to temporary table
--- @param element element
local function write_data(element)
	for _, element_name in ipairs({ "CellData", "CellDataChild" }) do
		for elem in element:each_of(element_name) do
			full_data[elem:get("name")] = elem
		end
	end
end

-- Parsing first time to gather data of all cells
local files = ModMaterialFilesGet()
local parsed_files = {} --- @type {[string]:element}
for i = 1, #files do
	local file = files[i]
	local success, result = pcall(nxml.parse, ModTextFileGetContent(file))
	if success then
		parsed_files[file] = result
		write_data(result)
	else
		print("couldn't parse material file " .. file)
	end
end

--  Parsing second time to apply fixes
for file, xml in pairs(parsed_files) do
	parse_file(xml)
	ModTextFileSetContent(file, tostring(xml))
end
