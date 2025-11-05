SetRandomSeed(11, -419)

local improvements = {
    GLASS_CANNON = {
        modifications = {
            func = function( entity_perk_item, entity_who_picked, item_name )
                local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
                if( damagemodels ~= nil ) then
                    for i,damagemodel in ipairs(damagemodels) do
                        local target_hp = (ComponentGetValue2(damagemodel, "max_hp") * 0.5) or 2
                        ComponentSetValue2( damagemodel, "max_hp", target_hp)
                        ComponentSetValue2( damagemodel, "hp", target_hp)
                    end
                end
            end
        }
    },
    BLEED_OIL = {
        probability = .85,
        modifications = {
            ui_name = "$fairmod_perk_bleed_grease",
            ui_description = "$fairmod_perkdesc_bleed_grease",
            ui_icon = "mods/noita.fairmod/files/content/better_perks/grease_blood/ui.png",
            perk_icon = "mods/noita.fairmod/files/content/better_perks/grease_blood/perk.png",
            func = function( entity_perk_item, entity_who_picked, item_name )

                local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
                if( damagemodels ~= nil ) then
                    for i,damagemodel in ipairs(damagemodels) do
                        ComponentSetValue( damagemodel, "blood_material", "fairmod_grease" )
                        ComponentSetValue( damagemodel, "blood_spray_material", "fairmod_grease" )
                        ComponentSetValue( damagemodel, "blood_multiplier", "3.0" )
                        ComponentSetValue( damagemodel, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_oil_$[1-3].xml" )
                        ComponentSetValue( damagemodel, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_oil_$[1-3].xml" )
                    end
                end
            end
        }
    },
}

local userseed = tostring(ModSettingGet("fairmod.user_seed") or "000000000000000000000000000000")
math.randomseed(tonumber(userseed:sub(7, 12)), tonumber(userseed:sub(15, 19)))
for index, perk in ipairs(perk_list) do
    local template = improvements[perk.id]
    if template ~= nil and (not template.probability or math.random() < template.probability) then --if template exists and it doesnt have a probability condition or the probability is met
        for key, value in pairs(improvements[perk.id].modifications) do
            perk[key] = value
        end
    end
end