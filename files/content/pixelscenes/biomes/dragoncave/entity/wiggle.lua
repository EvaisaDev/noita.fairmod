local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

SetRandomSeed(x, y + GameGetFrameNum())

PhysicsApplyForce(entity_id, 2000000 * Random(-8, 8), 2000000 * Random(-8, 8))
