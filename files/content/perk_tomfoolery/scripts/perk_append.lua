local old_perk_spawn = perk_spawn

perk_spawn = function( x, y, perk_id, dont_remove_other_perks_ )
	local perk = old_perk_spawn( x, y, perk_id, dont_remove_other_perks_ )
	SetRandomSeed( x, y )
	local chance = 20
	if(Random( 1, 100) <= chance)then
		local perk_data = get_perk_with_id( perk_list, perk_id )
		if ( perk_data == nil ) then
			print_error( "spawn_perk( perk_id ) called with'" .. perk_id .. "' - no perk with such id exists." )
			return
		end

		local sprite_components = EntityGetComponentIncludingDisabled( perk, "SpriteComponent" ) or {}

		for i, v in ipairs(sprite_components)do
			local image_file = ComponentGetValue2( v, "image_file" )
			local perk_icon = perk_data.perk_icon or "data/items_gfx/perk.xml"
			if(image_file == perk_icon)then
				ComponentAddTag( v, "perk_icon" )
			end
		end

		local sprite_offset_animator_component = EntityGetFirstComponent( perk, "SpriteOffsetAnimatorComponent" )
		if(sprite_offset_animator_component ~= nil)then
			local y_amount = ComponentGetValue2( sprite_offset_animator_component, "y_amount" )
			local y_speed = ComponentGetValue2( sprite_offset_animator_component, "y_speed" )

			ComponentSetValue2( sprite_offset_animator_component, "y_amount", y_amount * Random(95,105) / 100 )
			ComponentSetValue2( sprite_offset_animator_component, "y_speed",  y_speed * Random(95,105) / 100 )
		end
		
		local random_perk = perk_list[Random(1, #perk_list)]

		EntityAddComponent2(perk, "VariableStorageComponent", {
			name = "actual_perk_id",
			value_string = random_perk.id
		})
		
		EntityAddComponent2(perk, "VariableStorageComponent", {
			name = "actual_perk_icon",
			value_string = random_perk.perk_icon
		})

		EntityAddComponent2(perk, "VariableStorageComponent", {
			name = "actual_perk_desc",
			value_string = random_perk.ui_description
		})

		EntityAddComponent2(perk, "VariableStorageComponent", {
			name = "actual_perk_name",
			value_string = random_perk.ui_name
		})

		EntityAddComponent2(perk, "LuaComponent", {
			script_source_file = "mods/noita.fairmod/files/content/perk_tomfoolery/scripts/perk_tomfoolery.lua",
			execute_every_n_frame = 1,
			execute_on_added = true,
			vm_type="ONE_PER_COMPONENT_INSTANCE"
		})
	end

	return perk
end

local old_perk_pickup = perk_pickup

perk_pickup = function( entity_item, entity_who_picked, item_name, do_cosmetic_fx, kill_other_perks, no_perk_entity_ )
	-- fetch the actual perk data
	
	local actual_perk_id = nil
	if(entity_item ~= nil)then
		local variable_storage_comps = EntityGetComponent(entity_item, "VariableStorageComponent")

		if(variable_storage_comps ~= nil)then
			for i, comp_id in ipairs(variable_storage_comps)do
				local name = ComponentGetValue2(comp_id, "name")
				if(name == "actual_perk_id")then
					actual_perk_id = ComponentGetValue2(comp_id, "value_string")
				end
			end
		end
	end

	if(actual_perk_id ~= nil)then
		local variable_storage_comps = EntityGetComponent(entity_item, "VariableStorageComponent")

		if(variable_storage_comps ~= nil)then
			for i, comp_id in ipairs(variable_storage_comps)do
				local name = ComponentGetValue2(comp_id, "name")
				if(name == "perk_id")then
					ComponentSetValue2(comp_id, "value_string", actual_perk_id)
				end
			end
		end
	end
	return old_perk_pickup( entity_item, entity_who_picked, item_name, do_cosmetic_fx, kill_other_perks, no_perk_entity_ )
end