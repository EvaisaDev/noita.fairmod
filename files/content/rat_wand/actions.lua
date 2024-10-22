local fairmod_rat_spellappends = {
    {
        id          = "FAIRMOD_RAT_BITE",
        name 		= "$fairmod_spell_bite_name",
        description = "$fairmod_spell_bite_desc",
        sprite 		= "mods/noita.fairmod/files/content/rat_wand/gfx/rat_bite_ui.png",
        sprite_unidentified = "data/ui_gfx/gun_actions/chainsaw_unidentified.png",
        related_projectiles	= {"mods/noita.fairmod/files/content/rat_wand/rat_bite.xml"},
        type 		= ACTION_TYPE_PROJECTILE,
        spawn_level                       = "0,1,2", -- LUMINOUS_DRILL
        spawn_probability                 = "0.5,0.5,0.25", -- LUMINOUS_DRILL
        price = 150,
        mana = 20,
        --max_uses = 1000,
        action 		= function()
            --if reflecting then
            --	c.damage_melee_add = c.damage_melee_add + 1.0
            --else
                add_projectile("mods/noita.fairmod/files/content/rat_wand/rat_bite.xml")
                c.damage_critical_chance = c.damage_critical_chance + 10
            --end
            --It says "+25 melee damage" instead of "25 melee damage"... hmm.. not satisfactory
        end,
    },
}

for k=1,#fairmod_rat_spellappends
do local v = fairmod_rat_spellappends[k]
    v.author    = v.author  or "Conga Lyne"
    v.mod       = v.mod     or "Fair mod"
    table.insert(actions,v)
end
