local x, y = EntityGetTransform(GetUpdatedEntityID())
SetRandomSeed(x, y)
if Random() < 0.333 then
	EntityLoad("mods/noita.fairmod/files/content/wizard_crash/enemy.xml", x, y)
end

