function item_pickup()
	if GlobalsGetValue("SPEEDRUN_SPLIT_SAMPO", "--") == "--" then GlobalsSetValue("SPEEDRUN_SPLIT_SAMPO", tostring(GameGetFrameNum())) end
end
