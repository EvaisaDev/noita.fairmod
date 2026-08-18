---@type nxml
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")

for xml in nxml.edit_file("data/entities/props/physics_ragdoll_part.xml") do
	xml:set("tags", "no_spiders,ragdoll")
end
