local file = "data/entities/animals/fish.xml"
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

for xml in nxml.edit_file(file) do
	local dmc = xml:first_of("DamageModelComponent")
	if dmc then
		dmc:set("materials_how_much_damage", "")
		dmc:set("materials_that_damage", "")
	end
	local luacomponent = nxml.new_element("LuaComponent", {
		script_death = "mods/noita.fairmod/files/content/enemy_reworks/fish/regular_fish_death.lua",
	})
	xml:add_child(luacomponent)
end
