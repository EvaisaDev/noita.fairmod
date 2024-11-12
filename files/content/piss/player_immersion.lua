dofile_once("mods/noita.fairmod/files/lib/status_helper.lua")

local ingestion_threshold = 2250 -- 30% of 7500
local ingestion_max = 7500 -- 100% ingestion level

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
local entity_x, entity_y, entity_rotation, scale_x, scale_y = EntityGetTransform(entity)

last_ingestion_size = last_ingestion_size or nil
last_notice_frame = last_notice_frame or 0

SetRandomSeed(x + GameGetFrameNum(), y)

local taco_bell = GameHasFlagRun("tacobell_mode")

local ingestion_comp = EntityGetFirstComponent(entity, "IngestionComponent")
if ingestion_comp then
	local food_poisoning = tonumber(GetIngestionPercentage(entity, "FOOD_POISONING")) or 0

	local ingestion_size = ComponentGetValue2(ingestion_comp, "ingestion_size")

	if last_ingestion_size == nil then last_ingestion_size = ingestion_size end

	-- prevent it from lowering on its own.
	-- We cannot change the property that sets how fast it decreases to 0 because that just crashed the game.
	if ingestion_size <= last_ingestion_size then
		ingestion_size = last_ingestion_size
		ComponentSetValue2(ingestion_comp, "ingestion_size", ingestion_size)
	end

	if controls_comp and (ingestion_size > 0 or taco_bell) then
		local dir_x, dir_y = ComponentGetValue2(controls_comp, "mAimingVectorNormalized")
		if piss_button then
			local piss_velocity = 100

			if piss_pressed then
				GamePlaySound("mods/noita.fairmod/fairmod.bank", "immersivepiss/timetotakeapiss", entity_x, entity_y)
				GlobalsSetValue("TIMES_TOOK_PISS", tostring((tonumber(GlobalsGetValue("TIMES_TOOK_PISS", "0")) or 0) + 1))
			end

			GameCreateParticle(
				"urine",
				x + (scale_x * 3),
				y,
				taco_bell and 16 or 8,
				dir_x * piss_velocity,
				dir_y * piss_velocity,
				false,
				false,
				false
			)

			ingestion_size = math.max(ingestion_size - 5, 0)
			ComponentSetValue2(ingestion_comp, "ingestion_size", ingestion_size)
		end

		if taco_bell or shit_button or food_poisoning > 1 then
			local shit_velocity = -100

			local shit_count = 8
			if taco_bell then
				shit_count = 32
				shit_velocity = -200
			end

			shit_count = math.floor(shit_count + (food_poisoning * 0.8))
			shit_velocity = shit_velocity - math.floor(shit_count + (food_poisoning * 0.2))

			if shit_pressed then
				GamePlaySound("mods/noita.fairmod/fairmod.bank", "immersivepiss/diarrhea", entity_x, entity_y)
				GlobalsSetValue("TIMES_TOOK_SHIT", tostring((tonumber(GlobalsGetValue("TIMES_TOOK_SHIT", "0")) or 0) + 1))
			end

			local character_data_comp = EntityGetFirstComponent(entity, "CharacterDataComponent")
			if character_data_comp ~= nil then
				local velocity_x, velocity_y = ComponentGetValue2(character_data_comp, "mVelocity")
				local aim_dir_x, aim_dir_y = ComponentGetValue2(controls_comp, "mAimingVectorNormalized")

				local target_velocity_x = velocity_x + (aim_dir_x * 80)
				local target_velocity_y = velocity_y + (aim_dir_y * 20)

				ComponentSetValue2(character_data_comp, "mVelocity", target_velocity_x, target_velocity_y)
			end

			local deg = math.min(food_poisoning, 30)

			-- dir_x, dir_y by food_poisoning degrees
			local angle_deg = Random(-deg, deg)
			local angle_rad = math.rad(angle_deg) -- Convert to radians

			-- Calculate the rotated direction
			local cos_theta = math.cos(angle_rad)
			local sin_theta = math.sin(angle_rad)

			dir_x = dir_x * cos_theta - dir_y * sin_theta
			dir_y = dir_x * sin_theta + dir_y * cos_theta

			GameCreateParticle("poo", x, y, shit_count, dir_x * shit_velocity, dir_y * shit_velocity, false, false, false)

			ingestion_size = math.max(ingestion_size - 15, 0)
			ComponentSetValue2(ingestion_comp, "ingestion_size", ingestion_size)
		end
	elseif piss_button or shit_button then
		local current_frame = GameGetFrameNum()
		if current_frame - last_notice_frame > 60 then
			last_notice_frame = current_frame
			GamePrint("Stomach is empty!")
		end
	end

	last_ingestion_size = ingestion_size
	if last_ingestion_size > ingestion_threshold then
		local scale_wide = 1 + (last_ingestion_size - ingestion_threshold) / (ingestion_max - ingestion_threshold)
		EntitySetTransform(entity, entity_x, entity_y, entity_rotation, scale_x >= 0 and scale_wide or -scale_wide, scale_y)
	end
end
