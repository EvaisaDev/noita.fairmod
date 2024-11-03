local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

ModLuaFileAppend("data/scripts/biomes/mountain/mountain_hall.lua", "mods/noita.fairmod/files/content/entrance_cart/mountain_hall_append.lua")

ModMaterialsFileAdd("mods/noita.fairmod/files/content/entrance_cart/bouncy_metal.xml")

for xml in nxml.edit_file("data/entities/props/physics/minecart.xml") do
	local phys = xml:first_of("PhysicsBody2Component")
	if phys ~= nil then
		phys:set("linear_damping", 0)
		phys:set("angular_damping", 0.4)
		phys:set("buoyancy", 2)
	end

	for shape in xml:each_of("PhysicsImageShapeComponent") do
		shape:set("material", "fairmod_metal_rust")
	end
end
