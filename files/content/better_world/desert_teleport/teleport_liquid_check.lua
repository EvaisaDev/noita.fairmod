dofile_once("data/scripts/lib/utilities.lua")


function material_area_checker_failed( pos_x, pos_y )
	EntitySetComponentsWithTagEnabled(GetUpdatedEntityID(), "enabled_by_liquid", false)
end

function material_area_checker_success( pos_x, pos_y )
    if not HasFlagPersistent("fairmod_desert_shortcut_found") then
        AddFlagPersistent("fairmod_desert_shortcut_found")
        GamePrintImportant("A shortcut has opened up", "The modders have at least some mercy...")
    end
	EntitySetComponentsWithTagEnabled(GetUpdatedEntityID(), "enabled_by_liquid", true)
end
