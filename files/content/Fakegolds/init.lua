---@type nxml
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")

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
	for content in nxml.edit_file("data/biome/gold.xml") do
		content:first_of("Materials"):first_of("MaterialComponent"):set("material_name", mats[Random(1, #mats)])
	end
end

return thegold

-- beer, whiskey (alcohol), molten gold, shit, radiation gold (medium ending), piss
