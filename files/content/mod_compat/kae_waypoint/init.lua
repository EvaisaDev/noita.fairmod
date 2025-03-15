---@diagnostic disable: undefined-global
dofile_once("mods/kae_waypoint/data/kae/poi.lua")

ModSettingRemove("kae_waypoint._places") -- this is temporary

local locations = {
	["Hamis Biome"] = { 2693, 8785 },
	["Cauldron"] = { 3797, 5287 },
}

for location, coordinates in pairs(locations) do
	add_grouped_poi("Fairmod", location, coordinates[1], coordinates[2])
end
