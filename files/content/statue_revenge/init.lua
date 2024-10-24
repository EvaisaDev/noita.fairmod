-- HM statues don't fly very far, they rotate and kick you instead
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml


local statues = {
	"data/entities/props/temple_statue_01.xml",
	"data/entities/props/temple_statue_01_green.xml",
	"data/entities/props/temple_statue_02.xml",
}

for _, file in ipairs(statues) do
	for xml in nxml.edit_file(file) do
		local physics = xml:first_of("PhysicsBody2Component")
		if physics ~= nil then
			physics:set("hax_fix_going_through_ground", 1)
			physics:set("linear_damping", 10)
			physics:set("angular_damping", -1)
		end
	end
end
