local CH_effects = { 
	{
		id="CC_MOVEMENT_SLOWER_2X",
		ui_name="$status_cc_movement_slower_2x",
		ui_description="$status_desc_cc_movement_slower_2x",
		ui_icon="data/ui_gfx/status_indicators/movement_slower.png",
		effect_entity="data/entities/misc/effect_movement_slower_2x.xml",
		is_harmful=true,
	},
	{
		id="CC_LEVITATION_SLOWER",
		ui_name="$status_cc_levitation_slower",
		ui_description="$status_desc_cc_levitation_slower",
		ui_icon="mods/noita.fairmod/files/content/chemical_horror/potion_slowness/effect_levitation_slow.png",
		effect_entity="mods/noita.fairmod/files/content/chemical_horror/potion_slowness/effect_slower_levitation.xml",
		is_harmful=true,
	},
	{
		id="CC_INGESTION_METHANE",
		ui_name="$status_cc_ingestion_methane",
		ui_description="$status_desc_cc_ingestion_methane",
		ui_icon="mods/noita.fairmod/files/content/chemical_horror/methane/effect_methane.png",
		effect_entity="mods/noita.fairmod/files/content/chemical_horror/methane/effect_methane.xml",
		protects_from_fire=false,
		is_harmful=true,
	},
    --[[ 
	{
		id="CC_BLINDNESS",
		ui_name="$status_cc_blindness",
		ui_description="$status_desc_cc_blindness",
		ui_icon="data/ui_gfx/status_indicators/blindness.png",
		effect_entity="mods/Hydroxide/files/chemical_curiosities/materials/potion_blindness/effect_blindness.xml",
		protects_from_fire=false,
	 	is_harmful=true,
	},
	{
		id="CC_TWITCHY",
		ui_name="$status_cc_twitchy",
		ui_description="$statusdesc_twitchy",
		ui_icon="data/ui_gfx/status_indicators/twitchy.png",
		effect_entity="mods/Hydroxide/files/chemical_curiosities/materials/potion_twitchy/effect_twitchy.xml",
		is_harmful=true,
	},
	{
		id="CC_EXPLODING",
		ui_name="$status_cc_exploding",
		ui_description="$status_desc_cc_exploding",
		ui_icon="data/ui_gfx/status_indicators/explosive_shots.png",
		effect_entity="mods/Hydroxide/files/chemical_curiosities/materials/agitine/effect_explosion.xml", -- I know this is used by other materials, but it fits best here, and it's what I assume the effect was originally intended for -UserK
		is_harmful=false, --it *is* harmful but disabling it entirely is cringe :(, I'm instead going to put a check in the mat itself and make it apply Explosion Immunity or smth instead
	},
	{
		id="CC_IRONSKIN",
		ui_name="$status_cc_ironskin",
		ui_description="$status_desc_cc_ironskin",
		ui_icon="mods/Hydroxide/files/chemical_curiosities/materials/metals/effect_ironskin.png",
		effect_entity="mods/Hydroxide/files/chemical_curiosities/materials/metals/effect_ironskin.xml",
		is_harmful=false,
	},
	{
		id="AA_HIT_SELF",
		ui_name="$status_aa_hit_self",
		ui_description="$status_desc_aa_hit_self",
		ui_icon="mods/Hydroxide/files/arcane_alchemy/materials/hit_self/effect_hit_self.png",
		protects_from_fire=false,
		effect_entity="mods/Hydroxide/files/arcane_alchemy/materials/hit_self/hit_self.xml",
	},
	{
		id="AA_LOVE_POTION",
		ui_name="$status_aa_love_potion",
		ui_description="$status_desc_aa_love_potion",
		ui_icon="mods/Hydroxide/files/arcane_alchemy/materials/love/effect_LOVE.png",
		protects_from_fire=false,
		effect_entity="mods/Hydroxide/files/arcane_alchemy/materials/love/love.xml",
	},
	{
		id="AA_PATH",
		ui_name="$status_aa_path",
		ui_description="$status_desc_aa_path",
		ui_icon="mods/Hydroxide/files/arcane_alchemy/materials/meager_offering/effect_rice.png",
		protects_from_fire=false,
		effect_entity="mods/Hydroxide/files/arcane_alchemy/materials/meager_offering/path.xml",
	},
	{
		id="AA_CLONE",
		ui_name="$status_aa_clone",
		ui_description="$status_desc_aa_clone",
		ui_icon="mods/Hydroxide/files/arcane_alchemy/materials/cloning_solution/effect_cloning.png",
		protects_from_fire=false,
		effect_entity="mods/Hydroxide/files/arcane_alchemy/materials/cloning_solution/cloned.xml",
	}, ]]
}




for i=1,#CH_effects do
    status_effects[#status_effects+1] = CH_effects[i]
end