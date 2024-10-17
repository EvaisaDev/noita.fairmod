ModMaterialsFileAdd("mods/noita.fairmod/files/content/healthiummimicry/healthiummimic.xml")

local mimichealthium = {}

function mimichealthium.OnPlayerSpawned(player_entity)
  EntitySetDamageFromMaterial(player_entity, "healthiummimic", 0.008)
end

return mimichealthium
