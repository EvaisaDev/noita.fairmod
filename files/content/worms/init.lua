---@type nxml
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")

for xml in nxml.edit_file("data/entities/buildings/physics_worm_deflector_crystal.xml") do
	xml:first_of("WormAttractorComponent"):set("direction", 1)
end
