old_init = init

function init(x, y, w, h)
    old_init(x, y, w, h)

    SetRandomSeed(x, y)

    if y > 0 then
        if Random(0, 100) == 0 then --a classic nolla 1/101 random check :D
            EntityLoad("data/entities/animals/worm_big.xml", x + Random(1, w) - 1, y + Random(1, h) - 1)
        end

        for i = 1, 4, 1 do
            if Random(0, 100) == 0 then
                EntityLoad("data/entities/animals/worm.xml", x + Random(1, w) - 1, y + Random(1, h) - 1)
            end
        end

        for i = 1, 10, 1 do
            if Random(0, 100) == 0 then
                EntityLoad("data/entities/animals/worm_tiny.xml", x + Random(1, w) - 1, y + Random(1, h) - 1)
            end
        end
    end
end