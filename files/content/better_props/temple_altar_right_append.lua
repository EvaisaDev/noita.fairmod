local old_init = init
init = function(x, y, w, h)
	-- Underground jungle holy mountain
	if y > 6000 and y < 7000 then
		EntityLoad("mods/noita.fairmod/files/content/better_props/vines/root_grower_jungle_troll_trigger.xml", x + 190, y + 560)
	end
	old_init(x, y, w, h)
end
