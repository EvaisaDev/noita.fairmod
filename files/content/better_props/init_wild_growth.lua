-- Makes root growers spread a lot more

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local BASEMOD_PREFIX = "mods/noita.fairmod/files/content/better_props/"
--

local ROOTGROWER_FILE = "data/entities/props/root_grower.xml"
local ROOTGROWER_BRANCH_FILE = "data/entities/props/root_grower_branch.xml"

ModLuaFileAppend("data/scripts/props/root_grower_split.lua", BASEMOD_PREFIX .. "root_grower_split_append.lua")
ModLuaFileAppend("data/scripts/props/root_grower_fruit.lua", BASEMOD_PREFIX .. "root_grower_fruit_append.lua")


local function rootgrower_apply_changes(element)
  for comp in element:each_of("LifetimeComponent") do
    -- Go longer
    comp:set("lifetime", 500)
  end

  for comp in element:each_of("LuaComponent") do
    if comp:get("execute_every_n_frame") ~= nil then
      if comp:get("script_source_file") == "data/scripts/props/root_grower_spread.lua" then
        -- Speed of vine spread, lower is better
        comp:set("execute_every_n_frame", 1)
      else
        -- Time between when flowers spawn, lower is more frequent
        -- Too low causes more lag, so increase the duration instead
        comp:set("execute_every_n_frame", tonumber(comp:get("execute_every_n_frame")) * 2)
      end
    end
  end

  -- GIRTHY vines
  for comp in element:each_of("ParticleEmitterComponent") do
    comp:set("count_min", 16)
    comp:set("count_max", 92)
  end
end

local rootgrower_xml = nxml.parse(ModTextFileGetContent(ROOTGROWER_FILE))
rootgrower_apply_changes(rootgrower_xml)
ModTextFileSetContent(ROOTGROWER_FILE, tostring(rootgrower_xml))

local rootgrower_branch_xml = nxml.parse(ModTextFileGetContent(ROOTGROWER_BRANCH_FILE))
rootgrower_apply_changes(rootgrower_branch_xml:first_of("Base"))
ModTextFileSetContent(ROOTGROWER_BRANCH_FILE, tostring(rootgrower_branch_xml))
