local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local hamis_file = "data/entities/animals/longleg.xml"
local hamisits = { "data/ragdolls/longleg/head", "data/ragdolls/longleg/leg1", "data/ragdolls/longleg/foot1",
	"data/ragdolls/longleg/leg2", "data/ragdolls/longleg/foot2", "data/ragdolls/longleg/leg3",
	"data/ragdolls/longleg/foot3" }

local hamis_xml = nxml.parse(ModTextFileGetContent(hamis_file))

hamis_xml:add_child(nxml.new_element("LuaComponent", {
	script_damage_received = "mods/noita.fairmod/files/content/hamis_reworked/hamis_death.lua",
	script_death = "mods/noita.fairmod/files/content/hamis_reworked/hamis_death.lua",
}))

ModTextFileSetContent(hamis_file, tostring(hamis_xml))

local hamis_parts = nxml.parse(ModTextFileGetContent("mods/noita.fairmod/files/content/hamis_reworked/hamis_part.xml"))
local base = hamis_parts:first_of("Base")
if not base then return end

for _, part in ipairs(hamisits) do
	local sprite = base:first_of("SpriteComponent")
	if not sprite then return end
	sprite.attr.image_file = part .. ".png"
	ModTextFileSetContent("mods/noita.fairmod/vfs/hamis/" .. part .. "/longleg.xml", tostring(hamis_parts))
end

-- mods/noita.fairmod/vfs/hamis/data/ragdolls/longleg/head.xml
