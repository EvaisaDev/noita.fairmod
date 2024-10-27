local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml


local new_elem = nxml.new_element("AudioLoopComponent", {
	file = "mods/noita.fairmod/fairmod.bank",
	event_name = ModSettingGet("noita.fairmod.streamer_mode") and "spooky/skeleton_streamer" or "spooky/skeleton",
	auto_play = "1",
})

local list = { "data/entities/animals/necromancer_shop.xml", "data/entities/animals/necromancer_super.xml" }

for i = 1, #list do
	for xml in nxml.edit_file(list[i]) do
		xml:add_child(new_elem)
	end
end
