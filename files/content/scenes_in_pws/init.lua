-- Puts pixel scenes in parallel worlds so we can add trolls to the scenes
-- and extra convince players they are in the main world.

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

-- default map width seems to be 70
--local map_w, map_h = BiomeMapGetSize()  -- this crashes
--print_error("WID: " .. tostring(map_w))
local pw_x_offset = 70 * 512

-- Specifically only the PWs the mod sends you to
local parallel_world_offsets = {
  pw_x_offset * -3, pw_x_offset * -2, pw_x_offset * -1, pw_x_offset * 1, pw_x_offset * 2, pw_x_offset * 3
}

-- Could be more fancy and grab these programmatically from _pixel_scenes.xml, but no point
local pixel_scene_files = {
  "data/biome_impl/spliced/lavalake2.xml",
  "data/biome_impl/spliced/skull_in_desert.xml",
  "data/biome_impl/spliced/boss_arena.xml",
  "data/biome_impl/spliced/tree.xml",
  "data/biome_impl/spliced/watercave.xml",
  "data/biome_impl/spliced/mountain_lake.xml",
  "data/biome_impl/spliced/lake_statue.xml",
  "data/biome_impl/spliced/moon.xml",
  "data/biome_impl/spliced/moon_dark.xml",
  "data/biome_impl/spliced/lavalake_pit_bottom.xml",
  "data/biome_impl/spliced/gourd_room.xml",
  "data/biome_impl/spliced/skull.xml",
  "data/biome/_pixel_scenes.xml",
}


local function shallow_copy_table(src)
  local result = {}
  for k,v in pairs(src) do
    result[k] = v
  end
  return result
end


for _, filename in ipairs(pixel_scene_files) do
  for scene_file in nxml.edit_file(filename) do
    local new_elems = {}

    for scene in scene_file:first_of("mBufferedPixelScenes"):each_of("PixelScene") do
      for _, offset in ipairs(parallel_world_offsets) do
        local attrs = shallow_copy_table(scene.attr)
        attrs["pos_x"] = tonumber(attrs["pos_x"]) + offset

        table.insert(new_elems, nxml.new_element("PixelScene", attrs))
      end
    end

    scene_file:first_of("mBufferedPixelScenes"):add_children(new_elems)
  end
end

