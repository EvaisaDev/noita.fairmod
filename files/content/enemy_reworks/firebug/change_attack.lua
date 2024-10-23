local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

for xml in nxml.edit_file("data/entities/animals/bigfirebug.xml") do
	local base = xml:first_of("Base")
	if not base then return end
	local aac = base:first_of("AnimalAIComponent")
	if not aac then return end
	aac:set("attack_ranged_entity_file", "data/entities/projectiles/rocket_tank.xml")
end

for xml in nxml.edit_file("data/entities/projectiles/fireball_firebug.xml") do
	local sc = xml:first_of("SpriteComponent")
	if not sc then return end
	sc:set("image_file", "data/enemies_gfx/firebug.xml")
end
