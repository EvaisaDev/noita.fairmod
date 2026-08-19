
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/egg/hatch", x, y )
GameCreateParticle("fairmod_egg_white", x, y, 40, 10, 10, false, true, true)

SetRandomSeed(x + entity_id, y + GameGetFrameNum())

local worms = { {"worm_tiny", 3}, {"worm", 2}, {"worm_big", 1}, {"meatmaggot", 2}, {"worm_skull", 0.2}, {"worm_end", 0.2} }

local total = 0
for _,worm in ipairs(worms) do
	total = total + worm[2]
	worm[2] = total
end

local rng = Randomf(0, total)
for _,worm in ipairs(worms) do
	if rng <= worm[2] then
		EntityLoad("data/entities/animals/" .. worm[1] .. ".xml", x + Randomf(-2, 2), y + Randomf(-2, 2))
		break
	end
end
