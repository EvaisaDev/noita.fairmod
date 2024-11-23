
local old_spawn_worm_deflector = spawn_worm_deflector
spawn_worm_deflector = function(x, y)
	if y > 10500 and y <= 11000 then
		EntityLoad("data/entities/buildings/ghost_crystal.xml", x, y)
	else
		old_spawn_worm_deflector(x, y)
	end
end
