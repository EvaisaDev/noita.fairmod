local old_death = death

death = function()
	old_death()
	GameAddFlagRun("kolmi_killed")
end
