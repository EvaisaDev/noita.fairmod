dofile_once("mods/noita.fairmod/files/content/enemy_reworks/hamis_reworked/hamis_reworked.lua")
dofile_once("mods/noita.fairmod/files/content/enemy_reworks/firemage/replace_water.lua")
dofile_once("mods/noita.fairmod/files/content/enemy_reworks/fish/regular_fish.lua")

local append_after = {
	["data/scripts/animals/giantshooter_death.lua"] = "mods/noita.fairmod/files/content/enemy_reworks/giant_shooter/death_script.lua",
	["data/scripts/biomes/temple_altar.lua"] = "mods/noita.fairmod/files/content/enemy_reworks/fish/spawn_fish.lua"
}

for file, append in pairs(append_after) do
	local content = ModTextFileGetContent(file)
	content = content .. "\n" .. "dofile_once(\"" .. append .. "\")\n"
	ModTextFileSetContent(file, content)
end
