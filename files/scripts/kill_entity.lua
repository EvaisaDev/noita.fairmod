local entity = GetUpdatedEntityID()
local dmgcomp = EntityGetComponent(entity, "DamageModelComponent")
if dmgcomp then
    local hp = ComponentGetValue2(dmgcomp[1], "hp")
    EntityInflictDamage(entity, hp * 10, "DAMAGE_PHYSICS_BODY_DAMAGED", "Condemned by the world.", "BLOOD_EXPLOSION", 0, 0)
end

EntityKill(GetUpdatedEntityID())