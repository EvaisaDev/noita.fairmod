local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

local nuggets = {
	"data/entities/items/pickup/goldnugget.xml",
	"data/entities/items/pickup/goldnugget_x.xml",
	"data/entities/items/pickup/goldnugget_10.xml",
	"data/entities/items/pickup/goldnugget_50.xml",
	"data/entities/items/pickup/goldnugget_200.xml",
	"data/entities/items/pickup/goldnugget_1000.xml",
	"data/entities/items/pickup/goldnugget_10000.xml",
	"data/entities/items/pickup/goldnugget_200000.xml",
}

local luacomp = nxml.new_element("LuaComponent", {
	execute_every_n_frame = -1,
	script_source_file = "mods/noita.fairmod/files/content/evil_nuggets/nugget_evilifier.lua",
	execute_on_added = true
})

for _,nugget in ipairs(nuggets) do
	for xml in nxml.edit_file(nugget) do
		xml:add_child(luacomp)
	end
end