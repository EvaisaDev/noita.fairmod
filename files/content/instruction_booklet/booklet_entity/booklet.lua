EntityID = GetUpdatedEntityID()
local ui = dofile_once("mods/noita.fairmod/files/content/instruction_booklet/gui.lua") --- @class instruction_booklet_gui

function enabled_changed(entity_id, is_enabled)
	if is_enabled then
		ui.gui = GuiCreate()
	else
		GuiDestroy(ui.gui)
	end
end

function wake_up_waiting_threads()
	ui:update()
end
