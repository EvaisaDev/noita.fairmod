ModMaterialsFileAdd("mods/noita.fairmod/files/content/legosfolder/legos.xml")

local function stringsplit(inputstr, sep)
  sep = sep or "%s"
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end
-- Returns a key-value table, where they keys are the material name and the values the damage.
function get_materials_that_damage(entity_id)
  local out = {}
  local damage_model_component = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
  if damage_model_component then
    local materials_that_damage = ComponentGetValue2(damage_model_component, "materials_that_damage")
    materials_that_damage = stringsplit(materials_that_damage, ",")
    local materials_how_much_damage = ComponentGetValue2(damage_model_component, "materials_how_much_damage")
    materials_how_much_damage = stringsplit(materials_how_much_damage, ",")
    for i, v in ipairs(materials_that_damage) do
      out[v] = materials_how_much_damage[i]
    end
    return out
  end
end
-- <materials> should be a key-value table with the keys being the name of the material to change and the value the new damage.
-- For instance: change_materials_that_damage(entity_id, { lava = 0, new_material = 0.004 }) would make the entity immune to lava
-- and the material with name="new_material" would deal 0.004 damage.
function change_materials_that_damage(entity_id, materials)
  -- At the time of writing (1st of September 2020) changes to DamageModelComponent:materials_that_damage
  -- do not take effect. One of the ways to work around that is to remove and re-add the component with
  -- the changes applied and the same old values for everything else
  local damage_model_component = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
  if damage_model_component then
    -- Retrieve and store all old values of the DamageModelComponent
    local old_values = {}
    local old_damage_multipliers = {}
    for k,v in pairs(ComponentGetMembers(damage_model_component)) do
      -- ComponentGetMembers does not return the value for ragdoll_fx_forced, ComponentGetValue2 is necessary
      if k == "ragdoll_fx_forced" then
        v = ComponentGetValue2(damage_model_component, k)
      end
      old_values[k] = v
    end
    for k,_ in pairs(ComponentObjectGetMembers(damage_model_component, "damage_multipliers")) do
      old_damage_multipliers[k] = ComponentObjectGetValue(damage_model_component, "damage_multipliers", k)
    end
    -- Build comma separated string
    old_values.materials_that_damage = ""
    old_values.materials_how_much_damage = ""
    local old_materials_that_damage = get_materials_that_damage(entity_id)
    for material, damage in pairs(materials) do
      old_materials_that_damage[material] = damage
    end
    for material, damage in pairs(old_materials_that_damage) do
      local comma = old_values.materials_that_damage == "" and "" or ","
      old_values.materials_that_damage = old_values.materials_that_damage .. comma .. material
      old_values.materials_how_much_damage = old_values.materials_how_much_damage .. comma .. damage
    end
    EntityRemoveComponent(entity_id, damage_model_component)
    damage_model_component = EntityAddComponent(entity_id, "DamageModelComponent", old_values)
    ComponentSetValue2(damage_model_component, "ragdoll_fx_forced", old_values.ragdoll_fx_forced)
    for k, v in pairs(old_damage_multipliers) do
      ComponentObjectSetValue(damage_model_component, "damage_multipliers", k, v)
    end
  end
end


function OnPlayerSpawned(player_entity)
  change_materials_that_damage(player_entity, { mat_legos = 0.004 })
end
