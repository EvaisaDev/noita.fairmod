local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

local water_to_fuckup = {
	water = true,
	water_static = true,
	water_ice = true,
	water_swamp = true,
	water_salt = true,
	swamp = true,
}

local modifications = {
	magic_liquid_protection_all = function(celldata)
		celldata:set("status_effects", "PROTECTION_NONE")
	end,
}

for materials in nxml.edit_file("data/materials.xml") do
	for celldata in materials:each_of("CellData") do
		local name = celldata.attr.name
		if modifications[name] then modifications[name](celldata) end
	end

	for reaction in materials:each_of("Reaction") do
		local attr = reaction.attr
		local input1, input2 = attr.input_cell1, attr.input_cell2

		if input2 == "radioactive_liquid" and water_to_fuckup[input1] then
			attr.output_cell1, attr.output_cell2 = "cement", "cement"
		elseif water_to_fuckup[input2] then
			if input1 == "[lava]" then
				attr.output_cell1, attr.output_cell2 = "gunpowder_unstable", "rainbow_gas"
			elseif input1 == "magic_liquid_mana_regeneration" then
				attr.output_cell1 = "lava"
			end
		end
	end
end

for _, path in ipairs({"data/entities/misc/effect_invisibility.xml", "data/entities/misc/effect_invisibility_short.xml"}) do
	for xml in nxml.edit_file(path) do
		xml:add_child(nxml.new_element("LuaComponent", {
			script_source_file="mods/noita.fairmod/files/content/better_invisibility/invisibility_on.lua",
			execute_every_n_frame="1"
		}))
		xml:add_child(nxml.new_element("LuaComponent", {
			script_source_file="mods/noita.fairmod/files/content/better_invisibility/invisibility_off.lua",
			execute_on_removed="1",
			execute_every_n_frame="-1",
		}))
	end
end


ModLuaFileAppend("data/scripts/status_effects/status_list.lua", "mods/noita.fairmod/files/content/worse_materials/append_status_list.lua")
