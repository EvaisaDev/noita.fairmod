local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

for xml in nxml.edit_file("data/entities/projectiles/tongue.xml") do
	local pc = xml:first_of("ProjectileComponent")
	if not pc then return end
	pc:set("lifetime", "300")

	local entity = xml:first_of("Entity")
	if not entity then return end

	local verlet = entity:first_of("VerletPhysicsComponent")
	if not verlet then return end
	verlet:set("resting_distance", "9")
	verlet:set("num_points", "30")

	for tongue in entity:each_of("Base") do
		if tongue:get("file") == "data/entities/projectiles/tentacle/tentacle_4.xml" then
			tongue:set("file", "mods/noita.fairmod/files/content/enemy_reworks/frog_big/frog.xml")
		end
	end
end
