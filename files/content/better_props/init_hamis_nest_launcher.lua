-- Hamis nest launches hamis as projectiles and drops more hamis

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local BASEMOD_PREFIX = "mods/noita.fairmod/files/content/better_props/"
--


local SPIDERNEST_FILE = "data/entities/buildings/spidernest.xml"

-- This is NOT working, it only appends to the first load of spidernest.lua and does not run after that
ModLuaFileAppend("data/scripts/buildings/spidernest.lua", BASEMOD_PREFIX .. "spidernest_append.lua")

local spidernest_xml = nxml.parse(ModTextFileGetContent(SPIDERNEST_FILE))
-- This is NOT working, but does occasionally revenge-fire
spidernest_xml:add_child(nxml.new_element("AnimalAIComponent", {
  attack_ranged_enabled="1",
  attack_ranged_entity_file=BASEMOD_PREFIX.."projectile_hamis.xml",
  attack_ranged_frames_between="100",
  attack_ranged_offset_y="12",
  needs_food="0",
  can_fly="0",
  can_walk="0",
  attack_melee_enabled="0",
  creature_detection_range_x="400",
  creature_detection_range_y="400",
  sense_creatures="0",
  eye_offset_x="0",
  eye_offset_y="16",
  escape_if_damaged_probability="0",
  attack_ranged_max_distance="300",
}))
-- This is the workaround for the above not-working things
spidernest_xml:add_child(nxml.new_element("LuaComponent", {
  _enabled="1",
  execute_every_n_frame="60",
  execute_times="-1",
  remove_after_executed="0",
  script_source_file=BASEMOD_PREFIX .. "spidernest_append.lua",
}))
ModTextFileSetContent(SPIDERNEST_FILE, tostring(spidernest_xml))
