local entity = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity)

if GetValueBool("idle", true) then
	local left_x1 = x - 20
	local left_x2 = x - 50
	local right_x1 = x + 20
	local right_x2 = x + 50
	if RaytracePlatforms(left_x1, y, left_x2, y) == false and RaytracePlatforms(right_x1, y, right_x2, y) == false then
		GameAddFlagRun("fairmod_fish_is_free")
		SetValueBool("idle", false)
		EntityAddComponent2(entity, "LifetimeComponent", { lifetime = 2400, fade_sprites = true })
	end
	return
end

local increment = GetValueNumber("increment", 0.1)
EntitySetTransform(entity, x, y - increment)
if GameGetFrameNum() % 60 == 0 then SetValueNumber("increment", increment + 0.1) end

if GetValueBool("spell_not_spawn", true) and increment >= 0.5 then
	CreateItemActionEntity("FAIRMOD_JOEL", x, y + 30)
	SetValueBool("spell_not_spawn", false)
end

local sprite_comp = EntityGetFirstComponent(entity, "SpriteComponent")
local audio_comp = EntityGetFirstComponent(entity, "AudioLoopComponent")
if not sprite_comp or not audio_comp then return end

local alpha = ComponentGetValue2(sprite_comp, "alpha")
ComponentSetValue2(audio_comp, "m_volume", alpha)
