-- Improved props by Heinermann
local BETTER_PROPS_PREFIX = "mods/noita.fairmod/files/content/better_props/"

dofile_once(BETTER_PROPS_PREFIX .. "init_hamis_vase.lua")
dofile_once(BETTER_PROPS_PREFIX .. "init_modify_all_props.lua")
dofile_once(BETTER_PROPS_PREFIX .. "init_hamis_nest_launcher.lua")
dofile_once(BETTER_PROPS_PREFIX .. "vines/init_wild_growth.lua")
dofile_once(BETTER_PROPS_PREFIX .. "oil_barrel/init_modify.lua")

ModMaterialsFileAdd("mods/noita.fairmod/files/content/better_props/material_overrides.xml")

-- Makes cocoons spawn (m)any worms
ModLuaFileAppend("data/scripts/buildings/worm_cocoon.lua", BETTER_PROPS_PREFIX .. "worm_cocoon_append.lua")

-- Replace worm crystal with ghost crystal in temple of the art HM
ModLuaFileAppend("data/scripts/biomes/temple_altar.lua", BETTER_PROPS_PREFIX .. "temple_altar_append.lua")

