--- @diagnostic disable: missing-global-doc
local helper = dofile_once("mods/noita.fairmod/files/content/enemy_reworks/death_helper.lua") --- @type enemy_reworks_helper

function damage_received(damage, desc, entity_who_caused, is_fatal)
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform(GetUpdatedEntityID())

	SetRandomSeed(GameGetFrameNum(), x + y + entity_id)

	local dmg_comp = EntityGetFirstComponent(entity_id, "DamageModelComponent")
	if not dmg_comp then return end
	local health = ComponentGetValue2(dmg_comp, "hp")

	if health > 0.3 and health - damage < 0.3 then
		local visible = helper:is_entity_visible(entity_id)
		if visible then GameAddFlagRun("FAIRMOD_GIANTSHOOTER_KILLED") end
		local this_entity_file = EntityGetFilename(entity_id)
		local entities = EntityGetInRadiusWithTag(x, y, 500, "enemy")
		local shooter_count = 0
		for i = 1, #entities do
			local enemy_entity = entities[i]
			if EntityGetFilename(enemy_entity) == this_entity_file then shooter_count = shooter_count + 1 end
		end
		local can_spawn_more = shooter_count < 10
		local entity_file = (visible and can_spawn_more) and this_entity_file
			or "data/entities/animals/slimeshooter.xml"
		for _ = 1, 3 do
			local offset_x = Random(-10, 10)
			local offset_y = Random(-10, 10)

			local e = EntityLoad(entity_file, x + offset_x, y + offset_y)

			local new_dmg_comp = EntityGetFirstComponent(e, "DamageModelComponent")
			if new_dmg_comp then ComponentSetValue2(new_dmg_comp, "invincibility_frames", 10) end
		end
	end
end
