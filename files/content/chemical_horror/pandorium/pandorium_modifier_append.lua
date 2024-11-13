table.insert(actions, 
{
    id = "CHAOTIC_PANDORIUM_MODIFIER",
    name = "Chaotic Pandorium Modifier",
    description = "Hey, you shouldn't have this!",
    sprite = "data/ui_gfx/gun_actions/burn_trail.png",
    sprite_unidentified = "data/ui_gfx/gun_actions/burn_trail_unidentified.png",
    related_extra_entities = { "data/entities/misc/burn.xml" },
    type = ACTION_TYPE_MODIFIER,
    spawn_level = "",
    spawn_probability = "",
    mana = 0,
    do_not_spawn = true,
    pandorium_ignore = true,
    action = function()
        c.extra_entities = c.extra_entities .. "mods/noita.fairmod/files/content/chemical_horror/pandorium/pandorium_modifier.xml,"
        draw_actions(1, true)
    end,
})