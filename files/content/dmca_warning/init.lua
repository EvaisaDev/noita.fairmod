local M = {}

local persistent_key = "fairmod_dmca_warning_shown"

function M.OnPlayerSpawned(player)
  -- Show this only once on first startup
  if not HasFlagPersistent(persistent_key) then
    local x, y = EntityGetTransform(player)
    EntityLoad("mods/noita.fairmod/files/content/dmca_warning/warning.xml", x, y)
    AddFlagPersistent(persistent_key)
  end
end

return M
