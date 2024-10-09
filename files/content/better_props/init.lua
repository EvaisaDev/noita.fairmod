-- Improved props by Heinermann
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

local BASEMOD_PREFIX = "mods/noita.fairmod/files/content/better_props/"


-- ###################################################
-- Temple vase
-- ###################################################
local HAMIS_FILE = "data/entities/animals/longleg.xml"

local hamis_xml = nxml.parse(ModTextFileGetContent(HAMIS_FILE))
hamis_xml.attr["tags"] = tostring(hamis_xml.attr["tags"] or "") .. ",no_hamis_bullet"
ModTextFileSetContent(HAMIS_FILE, tostring(hamis_xml))

ModLuaFileAppend("data/scripts/props/physics_vase_damage.lua", BASEMOD_PREFIX .. "physics_vase_damage_append.lua")


-- ###################################################
-- Drain pipe
-- ###################################################
-- TODO: just do this for ALL files instead :shrug:

local DRAINPIPE_FILE = "data/entities/buildings/biome_modifiers/drain_pipe.xml"

local drainpipe_xml = nxml.parse(ModTextFileGetContent(DRAINPIPE_FILE))
local drainpipe_particle = drainpipe_xml:first_of("ParticleEmitterComponent")
if drainpipe_particle ~= nil then
  drainpipe_particle.attr["count_min"] = "15"
  drainpipe_particle.attr["count_max"] = "30"
  drainpipe_particle.attr["emission_interval_max_frames"] = "3"
end
ModTextFileSetContent(DRAINPIPE_FILE, tostring(drainpipe_xml))


-- ###################################################
-- Vault apparatus
-- ###################################################
-- TODO


-- ###################################################
-- Hamis nest
-- ###################################################
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

-- ###################################################
-- Cocoon
-- ###################################################
ModLuaFileAppend("data/scripts/buildings/worm_cocoon.lua", BASEMOD_PREFIX .. "worm_cocoon_append.lua")

-- ###################################################
-- Root grower
-- ###################################################
ModLuaFileAppend("data/scripts/props/root_grower_split.lua", BASEMOD_PREFIX .. "root_grower_split_append.lua")
ModLuaFileAppend("data/scripts/props/root_grower_fruit.lua", BASEMOD_PREFIX .. "root_grower_fruit_append.lua")

-- ###################################################
-- Other stuff
-- ###################################################

-- TODO
