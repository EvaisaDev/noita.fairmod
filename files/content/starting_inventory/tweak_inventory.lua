local strmanip = dofile_once("mods/noita.fairmod/files/lib/stringmanip.lua") --- @type StringManip

local starting_wand = strmanip:new("data/scripts/gun/procedural/starting_wand.lua")
starting_wand:AppendBefore(
	[[local bullshit_spells = { "GRENADE_ANTI", "GRENADE_LARGE", "RUBBER_BALL", "BOUNCY_ORB", "ARROW", "CURSED_ORB", "LIGHT_BULLET", "BURST_2", "CHAINSAW" }]]
)
starting_wand:ReplaceLine("AddGunAction(", [[AddGunAction(entity_id, get_random_from(bullshit_spells))]])
starting_wand:WriteAndClose()

local starting_bomb_wand = strmanip:new("data/scripts/gun/procedural/starting_bomb_wand.lua")
starting_bomb_wand:AppendBefore(
	[[local bullshit_spells = { "BOMB", "DYNAMITE", "MINE", "ROCKET", "GRENADE", "BLACK_HOLE_DEATH_TRIGGER", "GRENADE_TRIGGER","LASER_LUMINOUS_DRILL", "TORCH", "PEBBLE", "TNTBOX_BIG" }]]
)
starting_bomb_wand:ReplaceLine("AddGunAction(", [[AddGunAction(entity_id, get_random_from(bullshit_spells))]])
starting_bomb_wand:WriteAndClose()

ModTextFileSetContent(
	"data/scripts/items/potion_starting.lua",
	ModTextFileGetContent("mods/noita.fairmod/files/content/starting_inventory/potion_starting_lib.lua")
)
ModLuaFileAppend(
	"data/scripts/items/potion_starting.lua",
	"mods/noita.fairmod/files/content/starting_inventory/potion_append.lua"
)

local potion_starting = "data/scripts/items/potion_starting.lua"
local content = ModTextFileGetContent(potion_starting)
content = content .. '\ndofile_once("mods/noita.fairmod/files/content/starting_inventory/potion_append.lua")'
ModTextFileSetContent(potion_starting, content)

--- Split abgr
--- @param abgr_int integer
--- @return number red, number green, number blue, number alpha
local function color_abgr_split(abgr_int)
	local r = bit.band(abgr_int, 0xFF)
	local g = bit.band(bit.rshift(abgr_int, 8), 0xFF)
	local b = bit.band(bit.rshift(abgr_int, 16), 0xFF)
	local a = bit.band(bit.rshift(abgr_int, 24), 0xFF)

	return r, g, b, a
end

--- Merge rgb
--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return integer color
local function color_abgr_merge(r, g, b, a)
	return bit.bor(
		bit.band(r, 0xFF),
		bit.lshift(bit.band(g, 0xFF), 8),
		bit.lshift(bit.band(b, 0xFF), 16),
		bit.lshift(bit.band(a, 0xFF), 24)
	)
end

--- Blend colors
--- @private
--- @param color1 integer
--- @param color2 integer
--- @return integer
local function blend_colors(color1, color2)
	-- Extract RGBA components
	local s_r, s_g, s_b, s_a = color_abgr_split(color1)
	local d_r, d_g, d_b, d_a = color_abgr_split(color2)

	-- Normalize source alpha and compute inverse alpha once
	local alpha = s_a / 255
	local inv_alpha = 1 - alpha

	-- Blend each component using direct calculations
	local r = alpha * s_r + inv_alpha * d_r
	local g = alpha * s_g + inv_alpha * d_g
	local b = alpha * s_b + inv_alpha * d_b

	-- Merge the final color with full opacity
	return color_abgr_merge(r, g, b, 255)
end

SetRandomSeed(1, 1)
for _, gun in ipairs({ "data/items_gfx/handgun.png", "data/items_gfx/bomb_wand.png" }) do
	local wand_png, wand_w, wand_h = ModImageMakeEditable(gun, 0, 0)
	for i = 0, wand_w do
		for j = 0, wand_h do
			local pixel = ModImageGetPixel(wand_png, i, j)
			local _, _, _, a = color_abgr_split(pixel)
			if a > 0 then
				local random = color_abgr_merge(Random(0, 255), Random(0, 255), Random(0, 255), Random(70, 200))
				local color = blend_colors(random, pixel)
				ModImageSetPixel(wand_png, i, j, color)
			end
		end
	end
end
