ModMaterialsFileAdd("mods/noita.fairmod/files/content/legosfolder/legos.xml")

function OnPlayerSpawned(player_entity)
  EntitySetDamageFromMaterial(player_entity, "mat_legos", 0.004)
end
