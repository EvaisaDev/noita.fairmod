local entity = GetUpdatedEntityID()

-- P to piss
-- B to shit
local piss_button = InputIsKeyDown(19)
local shit_button = InputIsKeyDown(5)

local piss_pressed = InputIsKeyJustDown(19)
local shit_pressed = InputIsKeyJustDown(5)

local x, y = EntityGetHotspot( entity, "belt_root", true, true )
local controls_comp = EntityGetFirstComponentIncludingDisabled(entity, "ControlsComponent")
local entity_x,entity_y,_,scale_x = EntityGetTransform(entity)

last_ingestion_size = last_ingestion_size or nil

local ingestion_comp = EntityGetFirstComponent(entity, "IngestionComponent")
if(ingestion_comp)then
	local ingestion_size = ComponentGetValue2(ingestion_comp, "ingestion_size")

	if(last_ingestion_size == nil)then
		last_ingestion_size = ingestion_size
	end

	-- prevent it from lowering on its own.
	-- We cannot change the property that sets how fast it decreases to 0 because that just crashed the game.
	if(ingestion_size <= last_ingestion_size)then
		ingestion_size = last_ingestion_size
		ComponentSetValue2(ingestion_comp, "ingestion_size", ingestion_size)
	end

	if(controls_comp and ingestion_size > 0)then
		local dir_x, dir_y = ComponentGetValue2(controls_comp, "mAimingVectorNormalized")
		if(piss_button)then
			local piss_velocity = 100

			if(piss_pressed)then
				GamePlaySound("mods/noita.fairmod/fairmod.bank", "immersivepiss/timetotakeapiss",entity_x,entity_y)
				GlobalsSetValue("TIMES_TOOK_PISS", tostring((tonumber(GlobalsGetValue("TIMES_TOOK_PISS", "0")) or 0) + 1))
			end

			GameCreateParticle( "urine", x + (scale_x * 3), y, 8, dir_x * piss_velocity, dir_y * piss_velocity, false, false, false )

			ingestion_size = ingestion_size - 4
			ComponentSetValue2(ingestion_comp, "ingestion_size", ingestion_size)
		end

		if(shit_button)then
			local shit_velocity = -100
			
			if(shit_pressed)then
				GamePlaySound("mods/noita.fairmod/fairmod.bank", "immersivepiss/diarrhea",entity_x,entity_y)
				GlobalsSetValue("TIMES_TOOK_SHIT", tostring((tonumber(GlobalsGetValue("TIMES_TOOK_SHIT", "0")) or 0) + 1))
			end

			GameCreateParticle( "poo", x, y, 8, dir_x * shit_velocity, dir_y * shit_velocity, false, false, false )

			ingestion_size = ingestion_size - 4
			ComponentSetValue2(ingestion_comp, "ingestion_size", ingestion_size)
		end


	end

	last_ingestion_size = ingestion_size
end