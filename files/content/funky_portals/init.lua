local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

local init = {}
function init.OnMagicNumbersAndWorldSeedInitialized()
	for entity_xml in nxml.edit_file("data/entities/buildings/teleport_liquid_powered.xml") do
		entity_xml:add_child(nxml.new_element("LuaComponent", {
			script_source_file = "mods/noita.fairmod/files/content/funky_portals/portal_handler.lua",
			execute_on_added = "1",
			execute_times = "1",
		}))
	end
end

function init.OnPlayerSpawned(player)
	EntityAddComponent2(player, "LuaComponent", {
		script_source_file = "mods/noita.fairmod/files/content/funky_portals/teleported_find_spot.lua",
		script_teleported = "mods/noita.fairmod/files/content/funky_portals/teleported_find_spot.lua",
		execute_on_added = true,
		execute_every_n_frame = 1,
	})
end

return init
