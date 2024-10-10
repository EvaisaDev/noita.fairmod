-- Collection of many props tweaked en mass
--  * Emits 20x more particles
--  * Bleeds 10x more
--  * Anything with a material inventory gets launched when hit
--  * 25x more material dropped on entity death

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local BASEMOD_PREFIX = "mods/noita.fairmod/files/content/better_props/"
--

local prop_files = {
  "data/entities/animals/acidshooter.xml",
  "data/entities/animals/ant.xml",
  "data/entities/animals/assassin.xml",
  "data/entities/animals/bat.xml",
  "data/entities/animals/bigbat.xml",
  "data/entities/animals/bigfirebug.xml",
  "data/entities/animals/bloom.xml",
  "data/entities/animals/firebug.xml",
  "data/entities/animals/firemage.xml",
  "data/entities/animals/fireskull.xml",
  "data/entities/animals/fungus_big.xml",
  "data/entities/animals/fungus_giga.xml",
  "data/entities/animals/fungus_tiny.xml",
  "data/entities/animals/fungus.xml",
  "data/entities/animals/gazer.xml",
  "data/entities/animals/giant.xml",
  "data/entities/animals/giantshooter.xml",
  "data/entities/animals/icemage.xml",
  "data/entities/animals/iceskull.xml",
  "data/entities/animals/lurker.xml",
  "data/entities/animals/miner_hell.xml",
  "data/entities/animals/necrobot_super.xml",
  "data/entities/animals/necrobot.xml",
  "data/entities/animals/pebble_physics.xml",
  "data/entities/animals/shaman.xml",
  "data/entities/animals/shotgunner_hell.xml",
  "data/entities/animals/skygazer.xml",
  "data/entities/animals/slimeshooter_nontoxic.xml",
  "data/entities/animals/slimeshooter.xml",
  "data/entities/animals/sniper_hell.xml",
  "data/entities/animals/spearbot.xml",
  "data/entities/animals/spitmonster.xml",
  "data/entities/animals/tentacler.xml",
  "data/entities/animals/thundermage_big.xml",
  "data/entities/animals/thundermage.xml",
  "data/entities/animals/thunderskull.xml",
  "data/entities/animals/worm_end.xml",
  "data/entities/base_dripping_liquid.xml",
  "data/entities/buildings/biome_modifiers/drain_pipe.xml",
  "data/entities/buildings/biome_modifiers/gas_pipe_floor.xml",
  "data/entities/buildings/biome_modifiers/gas_pipe.xml",
  "data/entities/buildings/cloud_trap.xml",
  "data/entities/buildings/drill_laser.xml",
  "data/entities/buildings/firebugnest.xml",
  "data/entities/buildings/flynest.xml",
  "data/entities/items/pickup/brimstone.xml",
  "data/entities/items/pickup/potion.xml",
  "data/entities/items/pickup/powder_stash.xml",
  "data/entities/misc/effect_curse_cloud_00.xml",
  "data/entities/misc/effect_curse_cloud_01.xml",
  "data/entities/misc/effect_curse_cloud_02.xml",
  "data/entities/misc/effect_curse_rain.xml",
  "data/entities/misc/effect_farts.xml",
  "data/entities/misc/effect_rainbow_farts.xml",
  "data/entities/projectiles/glue_shot.xml",
  "data/entities/projectiles/glue.xml",
  "data/entities/props/dripping_acid_gas.xml",
  "data/entities/props/dripping_oil.xml",
  "data/entities/props/dripping_radioactive.xml",
  "data/entities/props/dripping_water_heavy.xml",
  "data/entities/props/dripping_water.xml",
  "data/entities/props/physics_barrel_burning.xml",
  "data/entities/props/physics_barrel_oil.xml",
  "data/entities/props/physics_barrel_radioactive.xml",
  "data/entities/props/physics_barrel_water.xml",
  "data/entities/props/physics_brewing_stand.xml",
  "data/entities/props/physics_crate.xml",
  "data/entities/props/physics_fungus_acid_big.xml",
  "data/entities/props/physics_fungus_acid_huge.xml",
  "data/entities/props/physics_fungus_acid_hugeish.xml",
  "data/entities/props/physics_fungus_acid_small.xml",
  "data/entities/props/physics_fungus_acid.xml",
  "data/entities/props/physics_fungus_big.xml",
  "data/entities/props/physics_fungus_huge.xml",
  "data/entities/props/physics_fungus_hugeish.xml",
  "data/entities/props/physics_fungus_small.xml",
  "data/entities/props/physics_fungus_trap.xml",
  "data/entities/props/physics_fungus.xml",
  "data/entities/props/physics_lantern_small.xml",
  "data/entities/props/physics_lantern.xml",
  "data/entities/props/physics_mining_lamp.xml",
  "data/entities/props/physics_pata.xml",
  "data/entities/props/physics_pressure_tank.xml",
  "data/entities/props/physics_propane_tank.xml",
  "data/entities/props/physics_seamine.xml",
  "data/entities/props/physics_trap_ignite_enabled.xml",
  "data/entities/props/physics_trap_ignite.xml",
  "data/entities/props/physics_tubelamp.xml",
  "data/entities/props/physics_vase.xml",
  "data/entities/props/physics/lantern_small.xml",
  "data/entities/props/physics/trap_ignite_enabled.xml",
  "data/entities/props/physics/trap_ignite.xml",
  "data/entities/props/suspended_seamine.xml",
  "data/entities/props/suspended_tank_acid.xml",
  "data/entities/props/suspended_tank_radioactive.xml",
  "data/entities/props/vault_apparatus_01.xml",
  "data/entities/props/vault_apparatus_02.xml",
}

local function elem_multiply_attr(component, name, multiplier)
  if component:get(name) then
    component:set(name, tonumber(component:get(name)) * multiplier)
  end
end

local function fixup_prop_children(element)
  if element == nil then return end

  for comp in element:each_of("ParticleEmitterComponent") do
    comp:set("create_real_particles", 1)
    comp:set("emit_cosmetic_particles", 0)
    elem_multiply_attr(comp, "count_min", 20)
    elem_multiply_attr(comp, "count_max", 20)
  end

  for comp in element:each_of("DamageModelComponent") do
    comp:set("blood_multiplier", 10)
    -- better chance to see things fly around instead of exploding immediately
    elem_multiply_attr(comp, "hp", 3)
  end

  for comp in element:each_of("MaterialInventoryComponent") do
    comp:set("leak_pressure_min", 10)
    comp:set("leak_pressure_max", 100)
    comp:set("b2_force_on_leak", 5)
    comp:set("on_death_spill", 1)
    comp:set("leak_on_damage_percent", 0.999)

    for mat_count in comp:each_of("count_per_material_type") do
      for mat in mat_count:each_of("Material") do
        elem_multiply_attr(mat, "count", 25)
      end
    end
  end
end

for _, prop_file in ipairs(prop_files) do
  local prop_xml = nxml.parse(ModTextFileGetContent(prop_file))

  fixup_prop_children(prop_xml)
  fixup_prop_children(prop_xml:first_of("Base"))

  ModTextFileSetContent(prop_file, tostring(prop_xml))
end

