local content = ModTextFileGetContent("data/biome/gold.xml")
local thegold = {}

local mats = {
	"beer",
	"poo",
	"gold_molten",
	"gold_radioactive",
	"urine",
	"alcohol",
	"fungi",
	"magic_gas_hp_regeneration",
	"milk",
	"molut",
	"rock_hard_border",
	"templeslab_static",
}
function thegold.OnMagicNumbersAndWorldSeedInitialized()
	content = content:gsub('"gold"', '"' .. mats[Random(1, #mats)] .. '"')
	ModTextFileSetContent("data/biome/gold.xml", content)
end

return thegold

-- beer, whiskey (alcohol), molten gold, shit, radiation gold (medium ending), piss
