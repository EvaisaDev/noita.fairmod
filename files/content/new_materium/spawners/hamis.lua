local file = "data/entities/animals/longleg.xml"
local max = 20
local radius = 100

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local entities_all = EntityGetInRadius(x, y, radius)
local count = 0

for i = 1, #entities_all do
	if EntityGetFilename(entities_all[i]) == file then count = count + 1 end
end

if count < max then
	SetRandomSeed(x, y + count)
	EntityLoad(file, x + Random(-10, 10), y + Random(-5, 0))
end

EntityKill(entity_id)
