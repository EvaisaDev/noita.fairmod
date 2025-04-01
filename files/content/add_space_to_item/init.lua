local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") ---@type nxml

local bases = {
	"data/entities/misc/custom_cards/action.xml",
	"data/entities/base_custom_card.xml",
}

local element = nxml.new_element("LuaComponent", {
	_tags = "enabled_in_world,enabled_in_hand",
	script_source_file = "mods/noita.fairmod/files/content/add_space_to_item/set_name.lua",
	remove_after_executed = true,
})

for i = 1, #bases do
	for xml in nxml.edit_file(bases[i]) do
		xml:add_child(element)
	end
end
