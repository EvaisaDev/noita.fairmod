local input_delay = {}

function input_delay.OnWorldPreUpdate()
	local player = EntityGetWithTag("player_unit")[1] or EntityGetWithTag("polymorphed_player")[1]
	if not player then return end

	local controls_comp = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")
	if not controls_comp then return end

	local amplitude = math.min(math.floor(GameGetFrameNum() / (60 * 60 * 2)), 31)
	local middle = amplitude / 2
	local wave = math.sin(GameGetFrameNum() / (60 * 60))
	local delay = math.max(0, math.min(middle + math.sin(wave) * middle, 31))

	ComponentSetValue2(controls_comp, "input_latency_frames", delay)

end

return input_delay
