local function edit_script(script_path, edit_function)
	local script = ModTextFileGetContent(script_path)
	local edited_script = edit_function(script)
	ModTextFileSetContent(script_path, edited_script)
end

local function escape(str)
	return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

edit_script("data/scripts/items/broken_wand_spells.lua", function(script)
	return string.gsub(
		script,
		escape("local spell = spells[Random(1, #spells)]"),
		[[
spells = {}

function table.has_value(tab, val)
	for index, value in ipairs(tab) do
		if value == val then return true end
	end

	return false
end

dofile_once("data/scripts/gun/gun_actions.lua")

for k, data in pairs(actions) do
	if data.related_projectiles ~= nil then
		if data.pandorium_ignore then goto continue end
		if data.tm_trainer and Randomf() >= (ModSettingGet("noita.fairmod.cpand_tmtrainer_chance") or 0) then goto continue end
		for k2, v in pairs(data.related_projectiles) do
			if(ModDoesFileExist(v))then
				if table.has_value(spells, v) == false then table.insert(spells, v) end
			end
		end
	end
	::continue::
end

local spell = spells[Random(1, #spells)]
]]
	)
end)

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

for entity in nxml.edit_file("data/entities/items/pickup/waterstone.xml") do
	-- add a new element
	entity:add_child(nxml.new_element("ParticleEmitterComponent", {
		_tags = "enabled_in_inventory,enabled_in_hand",
		emitted_material_name = "water",
		create_real_particles = "1",
		lifetime_min = "8",
		lifetime_max = "15",
		count_min = "1",
		count_max = "1",
		render_on_grid = "1",
		fade_based_on_lifetime = "1",
		cosmetic_force_create = "0",
		airflow_force = "0.251",
		airflow_time = "1.01",
		airflow_scale = "0.05",
		emission_interval_min_frames = "1",
		emission_interval_max_frames = "1",
		emit_cosmetic_particles = "0",
		image_animation_file = "data/particles/image_emitters/circle_reverse_64.png",
		image_animation_speed = "100",
		image_animation_loop = "1",
		image_animation_raytrace_from_center = "0",
		collide_with_gas_and_fire = "0",
		set_magic_creation = "1",
		is_emitting = "1",
	}))
end

for entity in nxml.edit_file("data/entities/items/pickup/brimstone.xml") do
	-- remove any GameEffectComponent
	for i = #entity.children, 1, -1 do
		if entity.children[i]:get("effect") == "PROTECTION_FIRE" then entity:remove_child_at(i) end
		if entity.children[i]:get("emitted_material_name") == "fire" then
			entity:set("count_min", 6)
			entity:set("count_max", 12)
		end
	end
end

for entity in nxml.edit_file("data/entities/items/pickup/thunderstone.xml") do
	-- remove any GameEffectComponent
	for i = #entity.children, 1, -1 do
		if entity.children[i]:get("effect") == "PROTECTION_ELECTRICITY" then entity:remove_child_at(i) end
	end

	-- get ElectricitySourceComponent
	local electricity_source = entity:first_of("ElectricitySourceComponent")
	if electricity_source then electricity_source:set("emission_interval_frames", "1") end
end

for entity in nxml.edit_file("data/entities/particles/water_electrocution.xml") do
	local charge = entity:first_of("ElectricChargeComponent")
	if charge then
		charge:set("charge_time_frames", "1")
		charge:set("electricity_emission_interval_frames", "1")
	end
end

for entity in nxml.edit_file("data/entities/items/pickup/physics_die.xml") do
	-- get every LuaComponent
	for i = #entity.children, 1, -1 do
		if entity.children[i]:get("script_source_file") == "data/scripts/items/die_status.lua" then
			entity.children[i]:set("script_source_file", "mods/noita.fairmod/files/content/worse_items/die_status.lua")
		end
	end
end

for entity in nxml.edit_file("data/entities/items/pickup/physics_gold_orb.xml") do
	for i = #entity.children, 1, -1 do
		if entity.children[i]:get("script_kick") == "data/scripts/items/gold_orb.lua" then
			entity.children[i]:set("script_kick", "mods/noita.fairmod/files/content/worse_items/gold_orb.lua")
		end
	end
end
for entity in nxml.edit_file("data/entities/items/pickup/physics_greed_die.xml") do
	-- get every LuaComponent
	for i = #entity.children, 1, -1 do
		if entity.children[i]:get("script_source_file") == "data/scripts/items/greed_die_status.lua" then
			entity.children[i]:set("script_source_file", "mods/noita.fairmod/files/content/worse_items/greed_die_status.lua")
		end
	end
end

for entity in nxml.edit_file("data/entities/items/pickup/physics_gold_orb_greed.xml") do
	for i = #entity.children, 1, -1 do
		if entity.children[i]:get("script_kick") == "data/scripts/items/gold_orb_greed.lua" then
			entity.children[i]:set("script_kick", "mods/noita.fairmod/files/content/worse_items/gold_orb_greed.lua")
		end
	end
end


for entity in nxml.edit_file("data/entities/misc/beam_from_sky.xml") do

	for i = #entity.children, 1, -1 do
		if(entity.children[i]:get("script_source_file") == "data/scripts/magic/beam_from_sky.lua")then
			entity.children[i]:set("script_source_file", "mods/noita.fairmod/files/content/worse_items/beam_from_sky.lua")
		end

		if entity.children[i]:get("lifetime") == "190" then
			entity.children[i]:set("lifetime", "700")
		end
	end
end

local lasers = {"data/entities/props/physics/trap_laser.xml", "data/entities/props/physics/trap_laser_enabled.xml", "data/entities/props/physics/trap_laser_enabled_left.xml", "data/entities/props/physics/trap_laser_toggling.xml", "data/entities/props/physics/trap_laser_toggling_left.xml"}

for _, file in ipairs(lasers)do
	for entity in nxml.edit_file(file) do
		for i = #entity.children, 1, -1 do
			if entity.children[i]:get("name") == "laser" then
				-- get LaserEmitterComponent
				local laser = entity.children[i]:first_of("LaserEmitterComponent")
				if laser then
					-- get or create "laser" child
					local laser_child = laser:first_of("laser")

					if(not laser_child) then
						laser_child = nxml.new_element("laser")
						laser:add_child(laser_child)
					end
					
					if laser_child then
						laser_child:set("max_length", "2048")
						laser_child:set("beam_radius", "20")
					end
				end
			end
		end
	end	
end

local igniters = {"data/entities/props/physics/trap_ignite.xml", "data/entities/props/physics/trap_ignite_enabled.xml", "data/entities/props/physics_trap_ignite.xml", "data/entities/props/physics_trap_ignite_enabled.xml"}
for _, file in ipairs(igniters)do
	for entity in nxml.edit_file(file) do
		for i = #entity.children, 1, -1 do
			if entity.children[i]:get("script_source_file") == "data/scripts/props/physics_trap_ignite.lua" then
				entity.children[i]:set("execute_every_n_frame", 1)
			end
		end
		
		local physics_body_comp = entity:first_of("PhysicsBodyComponent")

		if(physics_body_comp)then
			physics_body_comp:set("is_static", true)
		end

		local physics_body2_comp = entity:first_of("PhysicsBody2Component")

		if(physics_body2_comp)then
			physics_body2_comp:set("is_static", true)
		end
	end
end

local electifiers = {"data/entities/props/physics/trap_electricity.xml", "data/entities/props/physics/trap_electricity_enabled.xml", "data/entities/props/physics/trap_electricity_suspended.xml", "data/entities/props/physics_trap_electricity.xml", "data/entities/props/physics_trap_electricity_enabled.xml"}
for _, file in ipairs(electifiers)do
	for entity in nxml.edit_file(file) do
		for i = #entity.children, 1, -1 do
			if entity.children[i]:get("script_source_file") == "data/scripts/props/physics_trap_electricity_pulse.lua" then
				entity.children[i]:set("execute_every_n_frame", 1)
			end
		end
		
		local physics_body_comp = entity:first_of("PhysicsBodyComponent")

		if(physics_body_comp)then
			physics_body_comp:set("is_static", true)
		end

		local physics_body2_comp = entity:first_of("PhysicsBody2Component")

		if(physics_body2_comp)then
			physics_body2_comp:set("is_static", true)
		end
	end
end

local acid_traps = {"data/entities/props/physics/trap_circle_acid.xml", "data/entities/props/physics_trap_circle_acid.xml"}

for _, file in ipairs(acid_traps)do
	for entity in nxml.edit_file(file) do
		for i = #entity.children, 1, -1 do
			if entity.children[i]:get("value_string") == "data/entities/projectiles/deck/circle_acid.xml" then
				entity.children[i]:set("value_string", "mods/noita.fairmod/files/content/worse_items/circle_acid.xml")
			end
		end

		local physics_body_comp = entity:first_of("PhysicsBodyComponent")

		if(physics_body_comp)then
			physics_body_comp:set("is_static", true)
		end

		local physics_body2_comp = entity:first_of("PhysicsBody2Component")

		if(physics_body2_comp)then
			physics_body2_comp:set("is_static", true)
		end
	end
end
