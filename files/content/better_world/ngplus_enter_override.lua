
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



function do_newgame_plus(iteration)
	-- GameDoEnding2()
	-- BiomeMapLoad( "mods/nightmare/files/biome_map.lua" )

	local prev_iteration = SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") --store previous ng+
	
	if iteration == nil then --default iteration if nil
		if tonumber(prev_iteration) then
			iteration = tonumber(prev_iteration) + 1
		else
			iteration = prev_iteration
		end
	end

	print("NG+ ITERATION IS [" .. iteration .. "]")
	SessionNumbersSetValue( "NEW_GAME_PLUS_COUNT", iteration )

	local newgame_n
	if tonumber(iteration) == nil then --if iteration is not a number
		if special_iterations[iteration] == nil then
			iteration = "NaN"
		end
		if special_iterations[iteration].redirect then
			iteration = special_iterations[iteration].redirect()
		end
		if special_iterations[iteration].func then
			newgame_n = special_iterations[iteration].func()
		end
	else
		newgame_n = tonumber(iteration)
	end



	
	if newgame_n == nil then print(string.format('special iteration "%s" did not return a valid NG+ iterationm returned "%s"\ncancelling default script...', iteration, newgame_n)) return end



	
	local do_enemy_scaling = true

	local map = "data/biome_impl/biome_map_newgame_plus.lua"
	local _pixel_scenes = "data/biome/_pixel_scenes_newgame_plus.xml"
	local clean_up_biome_entrances = true
	



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