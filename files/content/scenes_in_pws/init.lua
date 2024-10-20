-- Script to copy pixel scenes into parallel worlds.
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

-- default map width seems to be 70
local WORLD_WIDTH = 70 * 512
local MAX_PARALLEL = 2 -- does NOT support large numbers

local pixel_scene_files = {
	"data/biome_impl/spliced/lavalake2.xml",
	"data/biome_impl/spliced/lavalake_pit_bottom.xml",
	"data/biome_impl/spliced/mountain_lake.xml",
	"data/biome_impl/spliced/tree.xml",
}

local function create_pw_elements(result, element, attr_name)
	for i = -MAX_PARALLEL, MAX_PARALLEL do
		if i ~= 0 then
			local attrs = MergeTables(element.attr)
			attrs[attr_name] = tonumber(attrs[attr_name]) + WORLD_WIDTH * i

			table.insert(result, nxml.new_element(element.name, attrs))
		end
	end
end

local function add_pw_scenes(elem, attr_name)
	if elem == nil then return end

	local new_elems = {}
	for scene in elem:each_child() do
		create_pw_elements(new_elems, scene, attr_name)
	end
	elem:add_children(new_elems)
end

for _, filename in ipairs(pixel_scene_files) do
	for scene_file in nxml.edit_file(filename) do
		add_pw_scenes(scene_file:first_of("mBufferedPixelScenes"), "pos_x")
	end
end

-- BUT ALSO, get rid of east/west indicators
local csv = ModTextFileGetContent("data/translations/common.csv")
csv = csv:gsub("\nbiome_east,[^\n]+", "\nbiome_east,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,")
csv = csv:gsub("\nbiome_west,[^\n]+", "\nbiome_west,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,")
ModTextFileSetContent("data/translations/common.csv", csv)
