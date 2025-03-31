local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

local props = {
	"data/entities/props/physics_barrel_radioactive.xml",
	"data/entities/props/physics_barrel_oil.xml",
	"data/entities/props/suspended_tank_radioactive.xml",
}

local component = nxml.new_element("LuaComponent", {
	script_source_file = "mods/noita.fairmod/files/content/better_props/oil_barrel/init_script.lua",
	remove_after_executed = true,
})

for _, prop in ipairs(props) do
	for xml in nxml.edit_file(prop) do
		xml:add_child(component)
	end
end
