for i = 1, #status_effects do
	local status = status_effects[i]
	if status.effect_entity == "data/entities/misc/effect_trip_03.xml" then status.min_threshold_normalized = 0 end
end
