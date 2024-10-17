local old = {
	perk_pickup = perk_pickup
}

perk_pickup = function (...)
	GameAddFlagRun("picked_perk_acheev")
	old.perk_pickup(...)
end