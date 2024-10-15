
local old_init = init
init = function (x, y, w, h)
	-- Underground jungle holy mountain
	if y > 6000 and y < 7000 then
		EntityLoad("data/entities/props/root_grower.xml", x + 200, y + 550)
	end
	old_init(x, y, w, h)
end
