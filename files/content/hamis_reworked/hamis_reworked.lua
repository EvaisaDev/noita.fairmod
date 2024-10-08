local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local hamis_file = "data/entities/animals/longleg.xml"

local hamis_xml = nxml.parse(ModTextFileGetContent(hamis_file))

for base in hamis_xml:each_of("Base") do
	for damagemodel in base:each_of("DamageModelComponent") do
		damagemodel.attr.ragdoll_fx_forced = "NO_RAGDOLL_FILE"
	end
end

hamis_xml:add_child(nxml.new_element("ExplosionComponent", {
	trigger = "ON_DEATH"
}))

ModTextFileSetContent(hamis_file, tostring(hamis_xml))
