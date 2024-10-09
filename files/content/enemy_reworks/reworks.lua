--- maybe i won't need it, idk
local strmanip = dofile_once("mods/noita.fairmod/files/lib/stringmanip.lua") --- @type StringManip

dofile_once("mods/noita.fairmod/files/content/enemy_reworks/hamis_reworked/hamis_reworked.lua")

local append_after = {
	["data/scripts/animals/giantshooter_death.lua"] = "mods/noita.fairmod/files/content/enemy_reworks/giant_shooter/death_script.lua"
}

for file, append in pairs(append_after) do
	local content = ModTextFileGetContent(file)
	content = content .. "\n" .. "dofile_once(\"" .. append .. "\")\n"
	ModTextFileSetContent(file, content)
end
