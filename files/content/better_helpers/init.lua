-- Make helpers/minions much more better
-- So helpful they can carry stuff for you
-- definitely will be very helpful and not hinder you in any way :)
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

-- true = needs controls
local minion_files = {
	["data/entities/misc/perks/angry_ghost.xml"] = true,
	["data/entities/misc/perks/hungry_ghost.xml"] = true,
	["data/entities/misc/homunculus.xml"] = false,
	["data/entities/misc/perks/lukki_minion.xml"] = true,
	["data/entities/base_helpless_animal.xml"] = false,
}

for file, needs_controls in pairs(minion_files) do
	for xml in nxml.edit_file(file) do
		if needs_controls then
			xml:add_child(
				nxml.new_element("ControlsComponent", { enabled = 0 })
			)
		end

		xml:add_child(
			nxml.new_element("ItemPickUpperComponent", {
				is_in_npc = 1,
				pick_up_any_item_buggy = 1,
				is_immune_to_kicks = 0,
				drop_items_on_death = 1,
			})
		)
	end
end
