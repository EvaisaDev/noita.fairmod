local x,y = EntityGetTransform(GetUpdatedEntityID())
SetRandomSeed(x,y)
if Random(1, 5) > 4 then return end
LoadBackgroundSprite("mods/noita.fairmod/files/content/backrooms/background/blacklighthint.png", x - 14, y - 3)