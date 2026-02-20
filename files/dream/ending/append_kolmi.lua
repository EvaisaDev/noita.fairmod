local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)
if #EntityGetInRadiusWithTag(x, y, 170, "player_unit") == 0 then return end

local dmc = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
if not dmc then return end

for _,child in ipairs(EntityGetAllChildren(entity_id) or {}) do
	if EntityHasTag(child, "protection") then EntityKill(child) end
end

local hp = ComponentGetValue2(dmc, "hp")
EntityInflictDamage(entity_id, hp+10, "NONE", "rip kolmi", "DISINTEGRATED", 0, 0)

GameScreenshake(200)
GamePlaySound("data/audio/Desktop/animals.bank", "animals/boss_centipede/dying", x, y)