local entity = GetUpdatedEntityID()

local piss_key = tonumber(ModSettingGet("noita.fairmod.rebind_pee")) or 19
local shit_key = tonumber(ModSettingGet("noita.fairmod.rebind_poo")) or 5

-- P to piss
-- B to shit
local piss_button = InputIsKeyDown(piss_key)
local shit_button = InputIsKeyDown(shit_key)

local piss_pressed = InputIsKeyJustDown(piss_key)
local shit_pressed = InputIsKeyJustDown(shit_key)

local x, y = EntityGetHotspot(entity, "belt_root", true, true)
local controls_comp = EntityGetFirstComponentIncludingDisabled(entity, "ControlsComponent")
local entity_x, entity_y, _, scale_x = EntityGetTransform(entity)

last_ingestion_size = last_ingestion_size or nil

local ingestion_comp = EntityGetFirstComponent(entity, "IngestionComponent")
if ingestion_comp then
	local ingestion_size = ComponentGetValue2(ingestion_comp, "ingestion_size")

	if last_ingestion_size == nil then last_ingestion_size = ingestion_size end

	-- prevent it from lowering on its own.
	-- We cannot change the property that sets how fast it decreases to 0 because that just crashed the game.
	if ingestion_size <= last_ingestion_size then
		ingestion_size = last_ingestion_size
		ComponentSetValue2(ingestion_comp, "ingestion_size", ingestion_size)
	end

	if controls_comp and (ingestion_size > 0 or GameHasFlagRun("tacobell_mode")) then
		local dir_x, dir_y = ComponentGetValue2(controls_comp, "mAimingVectorNormalized")
		if piss_button then
			local piss_velocity = 100

			if piss_pressed then
				GamePlaySound("mods/noita.fairmod/fairmod.bank", "immersivepiss/timetotakeapiss", entity_x, entity_y)
				GlobalsSetValue(
					"TIMES_TOOK_PISS",
					tostring((tonumber(GlobalsGetValue("TIMES_TOOK_PISS", "0")) or 0) + 1)
				)
			end

			GameCreateParticle(
				"urine",
				x + (scale_x * 3),
				y,
				GameHasFlagRun("tacobell_mode") and 16 or 8,
				dir_x * piss_velocity,
				dir_y * piss_velocity,
				false,
				false,
				false
			)

			ingestion_size = ingestion_size - 5
			ComponentSetValue2(ingestion_comp, "ingestion_size", ingestion_size)
		end

		if GameHasFlagRun("tacobell_mode") or shit_button then
			local shit_velocity = -100

			if shit_pressed then
				GamePlaySound("mods/noita.fairmod/fairmod.bank", "immersivepiss/diarrhea", entity_x, entity_y)
				GlobalsSetValue(
					"TIMES_TOOK_SHIT",
					tostring((tonumber(GlobalsGetValue("TIMES_TOOK_SHIT", "0")) or 0) + 1)
				)
			end

			local character_data_comp = EntityGetFirstComponent(entity, "CharacterDataComponent")
			if character_data_comp ~= nil then
				local velocity_x, velocity_y = ComponentGetValue2(character_data_comp, "mVelocity")
				local aim_dir_x, aim_dir_y = ComponentGetValue2(controls_comp, "mAimingVectorNormalized")

				local target_velocity_x = velocity_x + (aim_dir_x * 80)
				local target_velocity_y = velocity_y + (aim_dir_y * 20)

				ComponentSetValue2(character_data_comp, "mVelocity", target_velocity_x, target_velocity_y)
			end

			GameCreateParticle(
				"poo",
				x,
				y,
				GameHasFlagRun("tacobell_mode") and 32 or 8,
				dir_x * shit_velocity,
				dir_y * shit_velocity,
				false,
				false,
				false
			)

			ingestion_size = ingestion_size - 15
			ComponentSetValue2(ingestion_comp, "ingestion_size", ingestion_size)
		end
	end

	last_ingestion_size = ingestion_size
end
