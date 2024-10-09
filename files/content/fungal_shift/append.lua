-- just fuck my shit up you know what i'm saying

local filter_materials = function( mats )
	for i=#mats,1,-1 do
		local mat = mats[i]
		local tags = CellFactory_GetTags( CellFactory_GetType(mat) ) or {}
		for _,tag in ipairs(tags) do
			if tag == "[box2d]" or tag == "[catastrophic]" or tag == "[NO_FUNGAL_SHIFT]" then
				table.remove( mats, i )
				break
			end
		end
	end

	return mats
end



fungal_shift = function ( entity, x, y, debug_no_limits )
	local parent = EntityGetParent( entity )
	if parent ~= 0 then
		entity = parent
	end

	local frame = GameGetFrameNum()
	local last_frame = tonumber( GlobalsGetValue( "fungal_shift_last_frame", "-1000000" ) )
	if frame < last_frame + 60*60*2 and not debug_no_limits then
		return -- short cooldown
	end

	local comp_worldstate = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )
	if( comp_worldstate ~= nil and ComponentGetValue2( comp_worldstate, "EVERYTHING_TO_GOLD" ) ) then
		return -- do nothing in case everything is gold
	end


	local liquids = filter_materials(CellFactory_GetAllLiquids()) or {}
	local sands = filter_materials(CellFactory_GetAllSands()) or {}
	local solids = filter_materials(CellFactory_GetAllSolids()) or {}

	local function get_random_material(from)
		if(from)then
			local rand = Random(1, 3)
			if(rand == 1)then
				local material = liquids[Random(1, #liquids)]
				return {materials = {material}, name_material = material}
			elseif (rand == 2)then
				local material = sands[Random(1, #sands)]
				return {materials = {material}, name_material = material}
			else
				local material = solids[Random(1, #solids)]
				return {materials = {material}, name_material = material}
			end
		else
			local rand = Random(1, 3)
			if(rand == 1)then
				local material = liquids[Random(1, #liquids)]
				return {material = material}
			elseif (rand == 2)then
				local material = sands[Random(1, #sands)]
				return {material = material}
			else
				local material = solids[Random(1, #solids)]
				return {material = material}
			end
		end
	end
	
	local shift_count = Random(3, 9)

	for offset=1,shift_count do
		local iter = tonumber( GlobalsGetValue( "fungal_shift_iteration", "0" ) )

		local converted_any = false
		local convert_tries = 0
		local from_material_name = ""

		while converted_any == false and convert_tries < 20 do
			local seed2 = 42345 + iter + 1000*convert_tries
			SetRandomSeed( 89346, seed2 )
			local rnd = random_create( 9123, seed2 )
			local from = get_random_material(true)
			local to = get_random_material(false)
			local held_material = get_held_item_material( entity )

			-- if a potion or pouch is equipped, randomly use main material from it as one of the materials
			if held_material > 0 and random_nexti( rnd, 1, 100 ) <= 75 then
				if random_nexti( rnd, 1, 100 ) <= 50 then
					from = {}
					from.materials = { CellFactory_GetName(held_material) }
				else
					to = {}
					to.material = CellFactory_GetName(held_material)
					-- heh he
					if to.material == "gold" and random_nexti( rnd, 1, 1000 ) ~= 1 then 
						to.material = random_from_array( greedy_materials )
					end

					if to.material == "grass_holy" and random_nexti( rnd, 1, 1000 ) ~= 1 then 
						to.material = "grass"
					end
				end
			end


			local to_material = CellFactory_GetType( to.material )

			-- apply effects
			for i,it in ipairs(from.materials) do
				local from_material = CellFactory_GetType( it )
				
				from_material_name = string.upper( GameTextGetTranslatedOrNot( CellFactory_GetUIName( from_material ) ) )
				if from.name_material then
					from_material_name = string.upper( GameTextGetTranslatedOrNot( CellFactory_GetUIName( CellFactory_GetType( from.name_material ) ) ) )
				end

				-- convert
				if from_material ~= to_material then
					print(CellFactory_GetUIName(from_material) .. " -> " .. CellFactory_GetUIName(to_material))
					ConvertMaterialEverywhere( from_material, to_material )
					converted_any = true

					-- shoot particles of new material
					GameCreateParticle( CellFactory_GetName(from_material), x-10, y-10, 20, rand(-100,100), rand(-100,-30), true, true )
					GameCreateParticle( CellFactory_GetName(from_material), x+10, y-10, 20, rand(-100,100), rand(-100,-30), true, true )
				end
			end

			convert_tries = convert_tries+1
		end

		-- fx
		if converted_any then
			-- increment only here, in case had very bad luck and didn't get a shift
			GlobalsSetValue( "fungal_shift_iteration", tostring(iter+1) )

			-- remove tripping effect
			EntityRemoveIngestionStatusEffect( entity, "TRIP" );

			-- audio
			GameTriggerMusicFadeOutAndDequeueAll( 5.0 )
			GameTriggerMusicEvent( "music/oneshot/tripping_balls_01", false, x, y )

			-- particle fx
			local eye = EntityLoad( "data/entities/particles/treble_eye.xml", x,y-10 )
			if eye ~= 0 then
				EntityAddChild( entity, eye )
			end

			-- log
			local log_msg = ""
			if from_material_name ~= "" then
				log_msg = GameTextGet( "$logdesc_reality_mutation", from_material_name )
				GamePrint( log_msg )
			end
			GamePrintImportant( random_from_array( log_messages ), log_msg, "data/ui_gfx/decorations/3piece_fungal_shift.png" )
			GlobalsSetValue( "fungal_shift_last_frame", tostring(frame) )

			-- add ui icon
			local add_icon = true
			local children = EntityGetAllChildren(entity)
			if children ~= nil then
				for i,it in ipairs(children) do
					if ( EntityGetName(it) == "fungal_shift_ui_icon" ) then
						add_icon = false
						break
					end
				end
			end

			if add_icon then
				local icon_entity = EntityCreateNew( "fungal_shift_ui_icon" )
				EntityAddComponent( icon_entity, "UIIconComponent", 
				{ 
					name = "$status_reality_mutation",
					description = "$statusdesc_reality_mutation",
					icon_sprite_file = "data/ui_gfx/status_indicators/fungal_shift.png"
				})
				EntityAddChild( entity, icon_entity )
			end
		end
	end
end
