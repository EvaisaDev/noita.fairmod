-- not_in_default_perk_pool
local perk_pool = {}
for i, perk in ipairs(perk_list) do
    if(not perk.not_in_default_perk_pool)then
        table.insert(perk_pool, perk)
    end
end

local function getRandomPerk()
    return perk_pool[Random(1, #perk_pool)]
end

local TMTRAINER_SEED = StatsGetValue("world_seed")

print("TMTRAINER_SEED", tostring(TMTRAINER_SEED))

dofile("mods/noita.fairmod/files/content/tmtrainer/files/scripts/icon_list.lua")

for i = 1, #perk_pool do
    SetRandomSeed(i + TMTRAINER_SEED, i + TMTRAINER_SEED)

    local id = "TMTRAINER_"..i
    local ui_name = ""
    local ui_description = ""
    local ui_icon = ""
    local perk_icon = ""
    local game_effect = nil
    local particle_effect = nil
    local usable_by_enemies = true
    local stackable = true
    local funcs = {}
    local funcs_remove = {}
    local funcs_enemy = {}

    for j = 1, 2 do
        local perk = getRandomPerk()
        local added_name = GameTextGetTranslatedOrNot(perk.ui_name);
        local added_description = GameTextGetTranslatedOrNot(perk.ui_description);

        local getRandomChunkOfSize = function(input, size)
            local len = string.len(input)
            local start = Random(1, len - size)
            return string.sub(input, start, start + size)
        end

        local name_part = getRandomChunkOfSize(added_name, 4)
        ui_name = ui_name .. name_part;

        local description_part = getRandomChunkOfSize(added_description, 10)
        ui_description = ui_description .. description_part;

        if(j == 1 or Random(0, 100) > 50)then
            ui_icon = "mods/noita.fairmod/files/content/tmtrainer/files/corruptions/"..perk.ui_icon;
            if (not icon_exists(perk_icons, perk.ui_icon))then
                local random_sprite = perk_icons[Random(1, #perk_icons)]
                ui_icon = "mods/noita.fairmod/files/content/tmtrainer/files/corruptions/"..random_sprite;
            end

            perk_icon = "mods/noita.fairmod/files/content/tmtrainer/files/corruptions/"..perk.perk_icon;
            if (not icon_exists(perk_item_icons, perk.perk_icon))then
                local random_sprite = perk_item_icons[Random(1, #perk_item_icons)]
                perk_icon = "mods/noita.fairmod/files/content/tmtrainer/files/corruptions/"..random_sprite;
            end
        end

        if(perk.usable_by_enemies ~= nil and perk.usable_by_enemies == false)then
            usable_by_enemies = false
        end

        if(perk.stackable ~= nil and perk.stackable == false)then
           perk.stackable = false
        end

        if(perk.game_effect ~= nil and perk.game_effect ~= "")then
            if(game_effect ~= "" or Random(0, 100) > 50)then
                game_effect = perk.game_effect
            end
        end

        if(perk.particle_effect ~= nil and perk.particle_effect ~= "")then
            if(particle_effect ~= "" or Random(0, 100) > 50)then
                particle_effect = perk.particle_effect
            end
        end

        if(perk.func ~= nil)then
            table.insert(funcs, perk.func)
        end

        if(perk.func_remove ~= nil)then
            table.insert(funcs_remove, perk.func_remove)
        end

        if(perk.func_enemy ~= nil)then
            table.insert(funcs_enemy, perk.func_enemy)
        end
    end

    local func = function(entity_perk_item, entity_who_picked, item_name)
        for i, func in ipairs(funcs)do
            func(entity_perk_item, entity_who_picked, item_name)
        end
    end

    local func_remove = function(entity_who_picked)
        for i, func in ipairs(funcs_remove)do
            func(entity_who_picked)
        end
    end

    local func_enemy = function(entity_perk_item, entity_who_picked)
        for i, func in ipairs(funcs_enemy)do
            func(entity_perk_item, entity_who_picked)
        end
    end

    local new_perk = {
        not_in_default_perk_pool = false,
        id = id,
        ui_name = ui_name,
        ui_description = ui_description,
        ui_icon = ui_icon,
        perk_icon = perk_icon,
        usable_by_enemies = usable_by_enemies,
        stackable = stackable,
        game_effect = game_effect,
        particle_effect = particle_effect,
        tmtrainer = true,
        func = func,
        func_remove = func_remove,
        func_enemy = func_enemy
    }

    table.insert(perk_list, new_perk)
end
