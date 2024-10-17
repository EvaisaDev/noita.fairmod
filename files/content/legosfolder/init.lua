ModMaterialsFileAdd("mods/noita.fairmod/files/content/legosfolder/legos.xml")

local M = {}

function M.OnPlayerSpawned(player_entity)
  EntitySetDamageFromMaterial(player_entity, "mat_legos", 0.004)
end
