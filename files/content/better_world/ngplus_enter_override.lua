
local function convert_iteration_to_string(iteration)
	--local a = 1
	local b = 0
	for char in string.gmatch(iteration, ".") do
		--print(a)
		print(char)
		print(string.byte(char))
		--a = a * string.byte(char)
		b = b + string.byte(char)
	end
	return b + string.len(iteration)
end

local function print_ng_iteration(iteration)
	local text = GameTextGetTranslatedOrNot("$new_game_for_newgame_plus")
	text = text .. " "
	local plusses = ""
	if tonumber(iteration) ~= nil then
		iteration = tonumber(iteration)
		if iteration > 0 then
			for i=1,iteration do
				plusses = plusses .. "+"
			end
		elseif iteration < 0 then
			for i=1, 0 - iteration do
				plusses = plusses .. "-"
			end
		else
			plusses = "0"
		end
	else
		plusses = iteration
	end


	text = text .. plusses

	GamePrintImportant( text, "" )
end


local special_iterations = {
	apotheosis = {
		redirect = 45,
		func = function()
			
		end,
	},
	backrooms = {
		func = function()
			BiomeMapLoad_KeepPlayer("mods/noita.fairmod/files/content/better_world/ngplus_maps/backrooms/backrooms_ngplus.lua")
		end,
	},
	NaN = {
		redirect = -1 --im lazy im not making smth special for this rn
	}
}



function do_newgame_plus(iteration, force_relative)
	-- GameDoEnding2()
	-- BiomeMapLoad( "mods/nightmare/files/biome_map.lua" )

	local input = iteration --save input
	local newgame_n --newgame value as number

	local prev_number = SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") --store previous ng+
	local prev_id = GlobalsGetValue("NEW_GAME_PLUS_ITERATION")
	GlobalsSetValue("NEW_GAME_PLUS_ITERATION", "")

	local data = { --set data
		input = input,
		force_relative = force_relative,
		prev_number = prev_number,
		prev_id = prev_id,
	}
	

	--setting iteration
	if force_relative then
		SessionNumbersSetValue("convert_to_number", iteration)
		newgame_n = tonumber(prev_number) + SessionNumbersGetValue("convert_to_number") --forcibly convert iteration to number and add it to previous iteration number
	else
		if iteration == nil or iteration == "" then --default iteration if nil
			if prev_id ~= "" then
				iteration = prev_id
			else
				iteration = tonumber(prev_number) + 1
			end
		end
	end




	local return_data = {}
	if tonumber(iteration) == nil then
		--if not a number
		if special_iterations[iteration] == nil then
			iteration = "NaN"
		else
			--redirect iteration value if redirect value is present
			if special_iterations[iteration].redirect then	
				iteration = special_iterations[iteration].redirect(data)
			end
			if special_iterations[iteration].func then
				return_data = special_iterations[iteration].func(data)
			end
		end
	end
	GlobalsSetValue("NEW_GAME_PLUS_ITERATION", return_data.alias or iteration)




	print("NG+ ITERATION INPUT IS [" .. iteration .. "]")
	SessionNumbersSetValue( "NEW_GAME_PLUS_COUNT", iteration )


	
	if return_data.do_return == false then print(string.format('special iteration "%s" returned false for [do_continue], cancelling default script...', iteration, newgame_n)) return end

	newgame_n = tonumber(SessionNumbersGetValue( "NEW_GAME_PLUS_COUNT"))
	print("NG+ ITERATION TONUMBER IS [" .. tostring(newgame_n) .. "]")


	
	local do_enemy_scaling = return_data.do_enemy_scaling or true

	local map = return_data.map or "data/biome_impl/biome_map_newgame_plus.lua"
	local _pixel_scenes = return_data._pixel_scenes or "data/biome/_pixel_scenes_newgame_plus.xml"
	local clean_up_biome_entrances = return_data.clean_up_biome_entrances or true
	



	if do_enemy_scaling then

		-- scale the enemy difficulty
		SessionNumbersSetValue( "DESIGN_SCALE_ENEMIES", "1" )

		local hp_scale_min = 7 + ( (newgame_n-1) * 2.5 )
		local hp_scale_max = 25 + ( (newgame_n-1) * 10 )
		local hp_attack_speed = math.pow( 0.5, newgame_n )
		
		SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_HP_SCALE_MIN", hp_scale_min )
		SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_HP_SCALE_MAX", hp_scale_max )
		SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_ATTACK_SPEED", hp_attack_speed )

		-- fixes the autosave issues
		-- SessionNumbersSave()

		-- scale the player damage intake
		local player_entity = EntityGetClosestWithTag( 0, 0, "player_unit")
		local damagemodels = EntityGetComponent( player_entity, "DamageModelComponent" )
		if( damagemodels ~= nil ) and newgame_n > 0 then
			for i,damagemodel in ipairs(damagemodels) do

				local melee = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "melee" ) )
				local projectile = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ) )
				local explosion = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "explosion" ) )
				local electricity = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "electricity" ) )
				local fire = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "fire" ) )
				local drill = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "drill" ) )
				local slice = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "slice" ) )
				local ice = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "ice" ) )
				local healing = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "healing" ) )
				local physics_hit = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "physics_hit" ) )
				local radioactive = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "radioactive" ) )
				local poison = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "poison" ) )

				melee = melee * 3
				projectile = projectile * 2
				explosion = explosion * 2
				electricity = electricity * 2
				fire = fire * 2
				drill = drill * 2
				slice = slice * 2
				ice = ice * 2
				radioactive = radioactive * 2
				poison = poison * 3

				ComponentObjectSetValue( damagemodel, "damage_multipliers", "melee", tostring(melee) )
				ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile) )
				ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", tostring(explosion) )
				ComponentObjectSetValue( damagemodel, "damage_multipliers", "electricity", tostring(electricity) )
				ComponentObjectSetValue( damagemodel, "damage_multipliers", "fire", tostring(fire) )
				ComponentObjectSetValue( damagemodel, "damage_multipliers", "drill", tostring(drill) )
				ComponentObjectSetValue( damagemodel, "damage_multipliers", "slice", tostring(slice) )
				ComponentObjectSetValue( damagemodel, "damage_multipliers", "ice", tostring(ice) )
				ComponentObjectSetValue( damagemodel, "damage_multipliers", "healing", tostring(healing) )
				ComponentObjectSetValue( damagemodel, "damage_multipliers", "physics_hit", tostring(physics_hit) )
				ComponentObjectSetValue( damagemodel, "damage_multipliers", "radioactive", tostring(radioactive) )
				ComponentObjectSetValue( damagemodel, "damage_multipliers", "poison", tostring(poison) )

			end
		end
	end
	-- Load the actual biome map

	BiomeMapLoad_KeepPlayer( map, _pixel_scenes )
	SessionNumbersSave()
	-- BiomeMapLoad( "data/biome_impl/biome_map.png" )

	-- clean up entrances to biomes
	if clean_up_biome_entrances then
		LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 1534, "", true, true )
		LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 3070, "", true, true )
		LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 6655, "", true, true )
		LoadPixelScene( "data/biome_impl/clean_entrance.png", "", 128, 10750, "", true, true )
	end

	print_ng_iteration(iteration)
end