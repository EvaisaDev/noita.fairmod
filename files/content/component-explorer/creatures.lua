local fairmod_creatures = {
	{
		file="mods/noita.fairmod/files/content/chemical_horror/pandorium/random_spell_chaotic.xml",
		herd="mage_swapper",
		name="Goddess Pandora",
		tags="teleportable_NOT",
	},
	{
		file="mods/noita.fairmod/files/content/enemy_reworks/fish/fish.xml",
		herd="spider",
		name="$animal_fish",
		tags="mortal,hittable,homing_target,teleportable_NOT,enemy,human,destruction_target,flying",
	},
	{
		file="mods/noita.fairmod/files/content/enemy_reworks/hamis_reworked/hamis_part.xml",
		herd="spider",
		name="$animal_longleg",
		tags="mortal,hittable,homing_target,teleportable_NOT,enemy,human,destruction_target",
	},
	{
		file="mods/noita.fairmod/files/content/evil_nuggets/ai.xml",
		herd="giant",
		name="gold nugget",
		tags="mortal,hittable,homing_target,teleportable_NOT,enemy,human,destruction_target,glue_NOT",
	},
	{
		file="mods/noita.fairmod/files/content/immortal_snail/entities/snail.xml",
		herd="helpless",
		name="Immortal Snail",
		tags="mortal,prey,do_not_evil,hittable,helpless_animal,homing_target,teleportable_NOT",
	},
	{
		file="mods/noita.fairmod/files/content/kolmi_not_home/boss_longleg.xml",
		herd="spider",
		name="$animal_longleg",
		tags="mortal,do_not_evil,hittable,homing_target,teleportable_NOT,enemy,human,destruction_target",
	},
	{
		file="mods/noita.fairmod/files/content/snowman/snowman.xml",
		herd="ghost",
		name="Snowman",
		tags="mortal,hittable,homing_target,teleportable_NOT,enemy,human,destruction_target,polymorphable_NOT,curse_NOT,snowman",
	},
	{
		file="mods/noita.fairmod/files/content/wizard_crash/enemy.xml",
		herd="mage",
		name="$animal_wizard_tele",
		tags="mortal,hittable,homing_target,teleportable_NOT,enemy,human,destruction_target",
	},
	{
		file="mods/noita.fairmod/files/lib/DialogSystem/examples/morshu/npc.xml",
		herd="helpless",
		tags="mortal,hittable,helpless_animal,homing_target,teleportable_NOT",
	},
}

local creatures = dofile_once("mods/component-explorer/spawn_data/creatures.lua")

for _, fc in ipairs(fairmod_creatures) do
	fc.origin = "noita.fairmod"
	creatures[#creatures+1] = fc
end
