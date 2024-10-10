-- Temple vase that spawns hamis

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local BETTER_PROPS_PREFIX = "mods/noita.fairmod/files/content/better_props/"
--

for hamis_xml in nxml.edit_file("data/entities/animals/longleg.xml") do
  hamis_xml.attr["tags"] = tostring(hamis_xml.attr["tags"] or "") .. ",no_hamis_bullet"
end

ModLuaFileAppend("data/scripts/props/physics_vase_damage.lua", BETTER_PROPS_PREFIX .. "physics_vase_damage_append.lua")

