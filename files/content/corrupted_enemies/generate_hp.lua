--stylua: ignore start
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local currbiome = BiomeMapGetName(x, y)
currbiome = tostring(currbiome)
local hp_mod = 2

local biome_table = {
	{ "$biome_coalmine", 0.5 },
	{ "$biome_coalmine_alt", 1.0 },
	{ "$biome_forest", 1.0 },
	{ "$biome_excavationsite", 1.0 },
	{ "$biome_snowcave", 1.25 },
	{ "$biome_snowcastle", 1.0 },
	{ "$biome_desert", 2.0 },
	{ "$biome_rainforest", 2.5 },
	{ "$biome_crypt", 5.0 },
	{ "$biome_robobase", 15.0 },
	{ "$biome_wizardcave", 15.0 },
	{ "$biome_clouds", 10.0 },
	{ "$biome_boss_victoryroom", 20.0 },
}

for k = 1, #biome_table do
	if biome_table[k][1] == currbiome then
		hp_mod = biome_table[k][2]
		break
	end
end

local comp = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
local hp = ComponentGetValue2(comp, "hp")
ComponentSetValue2(comp, "hp", hp * hp_mod)
ComponentSetValue2(comp, "max_hp", hp * hp_mod)
--stylua: ignore end
