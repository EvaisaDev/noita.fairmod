local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") ---@type nxml
local file = "mods/noita.fairmod/vfs/magic_numbers.xml"

local tv = { GameGetDateAndTimeUTC() }
local seed = tv[6] + tv[5] * 60 + tv[4] * 60 * 60
math.randomseed(seed)

local hp_mult = math.random(20, 26)
if math.random(1, 4) > 3 then
	hp_mult = hp_mult * 10
elseif math.random(1, 100) < 3 then
	hp_mult = 1
end

local xml = nxml.new_element("MagicNumbers", {
	UI_PAUSE_MENU_LAYOUT_TOP_EDGE_PERCENTAGE = math.random(-15, 15),
	REPORT_DAMAGE_SCALE = 1+math.random(),
	GUI_HP_MULTIPLIER = hp_mult,
	UI_WOBBLE_AMOUNT_DEGREES = math.random(15, 25),
})

ModTextFileSetContent(file, tostring(xml))
ModMagicNumbersFileAdd(file)
