if GlobalsGetValue("SPEEDRUN_SPLIT_WORK", "--") == "--" then
	GlobalsSetValue("SPEEDRUN_SPLIT_WORK", tostring(GameGetFrameNum()))
end
