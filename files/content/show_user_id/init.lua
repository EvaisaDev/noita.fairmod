local show_user_id = {}

local gui = GuiCreate()
local show_for_n_frames = 0

function show_user_id.OnPausedChanged(is_paused, is_inventory_pause)
	if is_paused then
		show_for_n_frames = 8
	else
		show_for_n_frames = 0
	end
end

function show_user_id.OnPausePreUpdate()
	if show_for_n_frames <= 0 then
		return
	end

	show_for_n_frames = show_for_n_frames - 1

	GuiStartFrame(gui)
	local user_id = ModSettingGet("user_seed")
	if user_id then
		GuiColorSetForNextWidget(gui, 1, 1, 1, 0.05)
		GuiText(gui, 10, 10, user_id:sub(1, 10))
	end
end

return show_user_id
