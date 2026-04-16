---@diagnostic disable: undefined-global
dofile_once("mods/kae_waypoint/data/kae/poi.lua")
local markers = dofile_once("mods/noita.fairmod/files/content/better_world/map_helper.lua")

ModSettingRemove("kae_waypoint._places") -- this is temporary

local locations = {
	["Backrooms"] = { markers.noclip.x, markers.noclip.y },
	["Hämis Biome"] = { markers.hamis_biome.x, markers.hamis_biome.y },
	["Cauldron"] = { markers.cauldron.x, markers.cauldron.y },
}

for location, coordinates in pairs(locations) do
	add_grouped_poi("Fairmod", location, coordinates[1], coordinates[2])
end
