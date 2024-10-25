local me = GetUpdatedEntityID()
local fire = GameGetGameEffect(me, "ON_FIRE")
if fire == 0 then return end
local x, y = EntityGetTransform(me)
SetRandomSeed(x * GameGetFrameNum(), y)
for _ = 1, 10 do
	GameCreateParticle("fire", x, y, 1, Random(-20, 20), Random(-20, 20), false, false, true)
end
