local nxml = dofile("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

for xml in nxml.edit_file("data/entities/animals/boss_alchemist/boss_alchemist.xml") do
	xml:add_child(nxml.new_element("LuaComponent", {
		script_source_file = "mods/noita.fairmod/files/content/stronger_bosses/alchemist/on_spawn.lua",
		remove_after_executed = true,
	}))
end
