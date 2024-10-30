
run_real_ending = function(x,y)
    EntityLoad("mods/noita.fairmod/files/content/ending_quiz/confetti.xml",x,y)
    if y < 0 then -- mountain altar
        dofile( "data/entities/animals/boss_centipede/sampo_start_ending_sequence.lua")
    elseif y > 0 then -- underground work
        dofile("data/entities/animals/boss_centipede/sampo_normal_ending.lua")
    else -- what the fuck
        dofile("data/entities/animals/boss_centipede/sampo_normal_ending.lua")
    end
end
