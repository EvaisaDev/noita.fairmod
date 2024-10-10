-- Script to copy pixel scenes into parallel worlds.
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

-- default map width seems to be 70
local WORLD_WIDTH = 70 * 512
local MAX_PARALLEL = 3  -- does NOT support large numbers

local pixel_scene_files = { "data/biome/_pixel_scenes.xml" }

for filename in nxml.parse_file("data/biome/_pixel_scenes.xml"):first_of("PixelSceneFiles"):each_of("File") do
  table.insert(pixel_scene_files, filename:text())
end

local function shallow_copy_table(src)
  local result = {}
  for k,v in pairs(src) do
    result[k] = v
  end
  return result
end

local function create_pw_elements(result, element, attr_name)
  for i=-MAX_PARALLEL, MAX_PARALLEL do
    if i ~= 0 then
      local attrs = shallow_copy_table(element.attr)
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
    add_pw_scenes(scene_file:first_of("BackgroundImages"), "x")
  end
end
