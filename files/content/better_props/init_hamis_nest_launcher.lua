-- Hamis nest launches hamis as projectiles and drops more hamis

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
--

for spidernest_xml in nxml.edit_file("data/entities/buildings/spidernest.xml") do
	spidernest_xml:add_child(nxml.new_element("LuaComponent", {
		_enabled = "1",
		execute_every_n_frame = "60",
		execute_times = "-1",
		remove_after_executed = "0",
		script_source_file = "mods/noita.fairmod/files/content/better_props/spidernest_append.lua",
	}))
end
