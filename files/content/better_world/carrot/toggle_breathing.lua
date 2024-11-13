-- Toggle breathing, according to are we using the carrot or not.
-- Always reset breath when changing carrot in/out.
function enabled_changed(entity, is_enabled)
  local players = EntityGetWithTag( "player_unit" )
  if players == nil then return end

  local dmg_comps = EntityGetComponent(players[1], "DamageModelComponent")
  if dmg_comps == nil then return end

  local dmg_comp = dmg_comps[1]
  ComponentSetValue2(dmg_comp, "air_needed", not is_enabled)
  ComponentSetValue2(dmg_comp, "air_in_lungs", 7)
end
