if ModIsEnabled("meta_leveling") then dofile_once("mods/noita.fairmod/files/content/mod_compat/meta_leveling/init.lua") end

---@class fairmod_mod_compat
local compat = {}

function compat.on_world_initialized()
	if ModIsEnabled("kae_waypoint") then dofile_once("mods/noita.fairmod/files/content/mod_compat/kae_waypoint/init.lua") end
end

return compat
