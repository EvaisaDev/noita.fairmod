dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/biome_modifiers.lua")
dofile( "data/scripts/items/generate_shop_item.lua" )

RegisterSpawnFunction( 0xffd4845f, "load_scene_1" )
RegisterSpawnFunction( 0xffd5cd62, "load_scene_2" )
RegisterSpawnFunction( 0xff8dd45e, "load_scene_3" )
RegisterSpawnFunction( 0xff62d35d, "load_scene_4" )
RegisterSpawnFunction( 0xff5dd394, "load_scene_5" )
RegisterSpawnFunction( 0xff5ed4ce, "load_scene_6" )
RegisterSpawnFunction( 0xff60a4d4, "load_scene_7" )
RegisterSpawnFunction( 0xff6165d5, "load_scene_8" )

RegisterSpawnFunction( 0xff8562d5, "load_scene_a" )
RegisterSpawnFunction( 0xffaa60d4, "load_scene_b" )
RegisterSpawnFunction( 0xffd363d5, "load_scene_c" )
RegisterSpawnFunction( 0xffd45eaf, "load_scene_d" )
RegisterSpawnFunction( 0xffd5628a, "load_scene_e" )
RegisterSpawnFunction( 0xffd56477, "load_scene_f" )
RegisterSpawnFunction( 0xffc03333, "load_scene_g" )
RegisterSpawnFunction( 0xffc08032, "load_scene_h" )

RegisterSpawnFunction( 0xfff5c944, "load_lamp" )
RegisterSpawnFunction( 0xfff31919, "load_decal" )
RegisterSpawnFunction( 0xff48a55e, "load_radio" )

function load_scene_1(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/1.png", "", x, y, "", true)
end

function load_scene_2(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/2.png", "", x, y, "", true)
end

function load_scene_3(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/3.png", "", x, y, "", true)
end

function load_scene_4(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/4.png", "", x, y, "", true)
end

function load_scene_5(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/5.png", "", x, y, "", true)
end

function load_scene_6(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/6.png", "", x, y, "", true)
end

function load_scene_7(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/7.png", "", x, y, "", true)
end

function load_scene_8(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/8.png", "", x, y, "", true)
end

function load_scene_a(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/a.png", "", x, y, "", true)
end

function load_scene_b(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/b.png", "", x, y, "", true)
end

function load_scene_c(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/c.png", "", x, y, "", true)
end

function load_scene_d(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/d.png", "", x, y, "", true)
end

function load_scene_e(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/e.png", "", x, y, "", true)
end

function load_scene_f(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/f.png", "", x, y, "", true)
end

function load_scene_g(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/g.png", "", x, y, "", true)
end

function load_scene_h(x, y)
    LoadPixelScene("mods/noita.fairmod/files/content/backrooms/wang/scenes/h.png", "", x, y, "", true)
end

function load_lamp(x, y)
    SetRandomSeed( x, y + GameGetFrameNum() )

    local g_lamp =
    {
        total_prob = 0,
        {
            prob   		= 1.0,
            min_count	= 1,
            max_count	= 1,    
            entity 	= "mods/noita.fairmod/files/content/backrooms/props/ceiling_light.xml"
        },
        {
            prob   		= 0.3,
            min_count	= 1,
            max_count	= 1,    
            entity 	= "mods/noita.fairmod/files/content/backrooms/props/ceiling_light_off.xml"
        },
        {
            prob   		= 0.2,
            min_count	= 1,
            max_count	= 1,    
            entity 	= "mods/noita.fairmod/files/content/backrooms/props/ceiling_light_broken.xml"
        },
    }

    -- if x is odd, add 0.5, else, remove 0.5
    if x % 2 == 1 then
        x = x + 0.5
    else
        x = x - 0.5
    end

    spawn(g_lamp,x - 3.5,y,0,0)

end

function load_decal(x, y)
    local a, b, c, d, e, f = GameGetDateAndTimeLocal()

    local seed = a + b + c + d + e + f
    SetRandomSeed( x + seed, y + GameGetFrameNum() )


    if(Random(0, 100) < 10)then
        LoadBackgroundSprite( "mods/noita.fairmod/files/content/backrooms/background/backrooms_decals/"..Random(1, 10)..".png", x - 16, y - 16)
    end
end

function load_radio(x, y)
    local a, b, c, d, e, f = GameGetDateAndTimeLocal()

    local seed = a + b + c + d + e + f
    SetRandomSeed( x + seed, y + GameGetFrameNum() )
    if(Random(0, 100) > 25)then return end
    EntityLoad( "mods/noita.fairmod/files/content/backrooms/entities/radio.xml", x - 5, y - 5)
end

function la_creatura(x, y)
    local a, b, c, d, e, f = GameGetDateAndTimeLocal()

    local seed = a + b + c + d + e + f
    SetRandomSeed( x + seed, y + GameGetFrameNum() )


    if(Random(0, 100) > 15)then return end
    EntityLoad( "mods/noita.fairmod/files/content/backrooms/entities/creature.xml", x, y)
end