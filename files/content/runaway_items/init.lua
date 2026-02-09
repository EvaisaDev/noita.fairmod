local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

for book in nxml.edit_file("data/entities/items/books/base_book.xml") do
	book:add_child(nxml.new_element("LuaComponent", {
		_enabled = "1",
		script_source_file = "mods/noita.fairmod/files/content/runaway_items/scared_script_updater.lua",
		execute_every_n_frame = "1",
	}))
end