function init(entity_id)
	GamePrintImportant("Snail is angry")
	GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", x, y)
end

local entity = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity)

SetRandomSeed(x + y, GameGetFrameNum())
-- get a random angle radian
local angle = math.rad(Random(0, 360))
-- get a random direction vector
local dx = math.cos(angle)
local dy = math.sin(angle)

local distance = Random(100, 250)

local target_x = x + (dx * distance)
local target_y = y + (dy * distance)

local hit = RaytracePlatforms(target_x, target_y, target_x, target_y - 5)

if not hit then EntityLoad("mods/noita.fairmod/files/content/immortal_snail/entities/snail.xml", target_x, target_y) end
