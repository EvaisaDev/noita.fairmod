local init = {}

local alt_event_utils = ModTextFileGetContent("data/scripts/streaming_integration/event_utilities.lua")
ModTextFileSetContent("data/scripts/streaming_integration/alt_event_utils.lua", alt_event_utils)

ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita.fairmod/files/content/tmtrainer/files/scripts/append/gun_actions.lua")
ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noita.fairmod/files/content/tmtrainer/files/scripts/append/perk_list.lua")

local bypasscontent = ModTextFileGetContent("data/scripts/gun/gun_actions.lua")
bypasscontent = 'dofile_once( "data/scripts/gun/gun_enums.lua")\n\n'..bypasscontent
ModTextFileSetContent("data/scripts/gun/gun_actions.lua", bypasscontent)



function findCenteredImagePosition(gui, image_file, scale)
    local width, height = GuiGetScreenDimensions( gui )
    local image_width, image_height = GuiGetImageDimensions( gui, image_file, scale )
    local x = (width - image_width) / 2
    local y = (height - image_height) / 2
    return x, y
end

function init.OnPlayerSpawned(player)
    dofile( "data/scripts/lib/utilities.lua" )
    dofile( "data/scripts/perks/perk.lua" )
    dofile( "data/scripts/perks/perk_list.lua" )

    EntityAddComponent( player, "LuaComponent", {
		execute_every_n_frame="1",
		execute_on_added="1",
		script_source_file="mods/noita.fairmod/files/content/tmtrainer/files/scripts/player_update.lua",
	});
end

return init