local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

local module = {}

local allowed_items = {
	"data/entities/items/pickup/heart_fullhp_temple.xml",
	"data/entities/items/pickup/heart_fullhp.xml",
}

for _, entity_file in ipairs(allowed_items) do
	local xml = nxml.parse(ModTextFileGetContent(entity_file))

	xml:add_child(nxml.new_element("Entity", {}, {
		nxml.new_element("Base", { file = "mods/noita.fairmod/files/content/evasive_items/mover.xml" }),
	}))

	ModTextFileSetContent(entity_file, tostring(xml))
end

return module

