local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") ---@type nxml

for xml in nxml.edit_file("data/entities/buildings/teleport_liquid_powered.xml") do
	xml:add_child(nxml.new_element("LuaComponent", {
		_tags = "mimicspawner",
		_enabled = "1",
		execute_on_added = "1",
		script_source_file = "mods/noita.fairmod/files/content/hm_portal_mimic/do_i_spawn.lua",
	}))
end
