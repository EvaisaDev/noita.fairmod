EntityID = GetUpdatedEntityID()
local ui = dofile_once("mods/noita.fairmod/files/content/instruction_booklet/gui.lua") --- @class instruction_booklet_gui

function enabled_changed(entity_id, is_enabled)
	if is_enabled then
		GameAddFlagRun("fairmod_dialog_interacting")
		ui.gui = GuiCreate()
	else
		GameRemoveFlagRun("fairmod_dialog_interacting")
		GuiDestroy(ui.gui)
	end
end

function wake_up_waiting_threads()
	ui:update()
end

function death(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
	GameAddFlagRun("fairmod_booklet_died")
end
