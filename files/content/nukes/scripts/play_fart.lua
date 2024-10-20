local entity = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity)

SetRandomSeed(x, y)
GamePlaySound("mods/noita.fairmod/fairmod.bank", "nuke/fart" .. Random(1, 5), x, y)
