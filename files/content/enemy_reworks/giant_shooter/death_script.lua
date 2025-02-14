--- @diagnostic disable: missing-global-doc
local helper = dofile_once("mods/noita.fairmod/files/content/enemy_reworks/death_helper.lua") --- @type enemy_reworks_helper

function damage_received(damage, desc, entity_who_caused, is_fatal)
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform(entity_id)

	SetRandomSeed(GameGetFrameNum(), x + y + entity_id)

	if is_fatal then
		local visible = helper.is_entity_visible(entity_id)
		if visible then
			GameAddFlagRun("FAIRMOD_GIANTSHOOTER_KILLED")
		end

		local entities = EntityGetWithTag("giantshooter_bullshit")
		local shooter_count = #entities

		if shooter_count >= 16 then
			return
		end

		local this_entity_file = EntityGetFilename(entity_id)
		local can_spawn_more = shooter_count < 8
		local entity_file = (visible and can_spawn_more) and this_entity_file or "data/entities/animals/slimeshooter.xml"
		for _ = 1, 3 do
			local offset_x = Random(-10, 10)
			local offset_y = Random(-10, 10)

			local e = EntityLoad(entity_file, x + offset_x, y + offset_y)
			EntityAddTag(e, "giantshooter_bullshit")

			local new_dmg_comp = EntityGetFirstComponent(e, "DamageModelComponent")
			if new_dmg_comp then ComponentSetValue2(new_dmg_comp, "invincibility_frames", 20) end
		end
	end
end
