dofile("data/scripts/lib/coroutines.lua")

local module = {}

function module.update()
    SetRandomSeed(GameGetFrameNum(), 80)
    local chance = 3600 * 60 / 2
    if Random(1, chance) == 1 then
        GamePlaySound("mods/noita.fairmod/fairmod.bank", "pingattack/discord", 0, 0)
    end
end

return module
