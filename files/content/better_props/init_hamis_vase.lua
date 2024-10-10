-- Temple vase that spawns hamis

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local BASEMOD_PREFIX = "mods/noita.fairmod/files/content/better_props/"
--

local HAMIS_FILE = "data/entities/animals/longleg.xml"

local hamis_xml = nxml.parse(ModTextFileGetContent(HAMIS_FILE))
hamis_xml.attr["tags"] = tostring(hamis_xml.attr["tags"] or "") .. ",no_hamis_bullet"
ModTextFileSetContent(HAMIS_FILE, tostring(hamis_xml))

ModLuaFileAppend("data/scripts/props/physics_vase_damage.lua", BASEMOD_PREFIX .. "physics_vase_damage_append.lua")

