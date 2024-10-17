dofile("mods/noita.fairmod/files/content/fishing/definitions/fish_list.lua")
dofile("mods/noita.fairmod/files/content/fishing/definitions/bait_list.lua")

function table.has_value(table, value)
	if(table == nil)then
		return false
	end
	for k, v in pairs(table)do
		if(v == value)then
			return true	
		end
	end
	return false
end

function find_entry_with_id(input_table, id)
	for k, v in pairs(input_table)do
		if(v.id == id)then
			return v
		end
	end
	return nil
end


function nearest_value(table, number)
    local smallestSoFar, smallestIndex
	for i, y in ipairs(table) do
		print(tostring(y[1]))
        if not smallestSoFar or (math.abs(number-y[1]) < smallestSoFar) then
            smallestSoFar = math.abs(number-y[1])
            smallestIndex = i
        end
    end
    return table[smallestIndex]
end


function catch_ui(fish, size)

	pos_x, pos_y = GameGetCameraPos()

	size_closest = nearest_value({{fish.sizes.min, "small"}, {fish.sizes.max - ((fish.sizes.max - fish.sizes.min) / 2), "medium"}, {fish.sizes.max, "large"}}, size)
	size_true = size_closest[2]

	if(fish.single_sprite_size)then
		size_true = "large"
	end
	
	local ui = EntityLoad("mods/noita.fairmod/files/content/fishing/files/ui/catch_popup.xml", pos_x, pos_y)

	EntitySetVariable(ui, "fish", "string", fish.ui_sprite)
	EntitySetVariable(ui, "background", "string", "mods/noita.fairmod/files/content/fishing/files/ui/catch_backgrounds/default.png")
	EntitySetVariable(ui, "fish_name", "string", fish.name)
	--EntitySetVariable(ui, "bottom_text", "string", fish.catch_text.bottom)
	EntitySetVariable(ui, "size", "string", tostring(round(size, 1)))
	EntitySetVariable(ui, "animation", "string", size_true)
	

	EntityAddComponent2(ui, "LuaComponent", {
		script_source_file="mods/noita.fairmod/files/content/fishing/files/ui/catch_popup.lua",
		vm_type="ONE_PER_COMPONENT_INSTANCE",
		execute_on_added=true,
		execute_every_n_frame=-1,
		execute_times=1,
		enable_coroutines=true,
	})



end

function create_fish_object(fish, x, y, size)
	local fish_item = EntityLoad("mods/noita.fairmod/files/content/fishing/files/fish/fish_entity.xml", x, y)
	
	EntityAddComponent2(fish_item, "PhysicsImageShapeComponent", {
		_tags="fish_image_shape",
		body_id=1,
		centered=true,
		image_file=fish.sprite,
		material=CellFactory_GetType( "meat" ),
	})
	EntityAddComponent2(fish_item, "PhysicsBodyComponent", {
		_tags="enabled_in_world",
		uid=1,
		allow_sleep=true,
		angular_damping=0,
		fixed_rotation=false ,
		is_bullet=false,
		linear_damping=0,
		auto_clean=false,
		on_death_leave_physics_body=false,
		hax_fix_going_through_ground=true,
	})
	EntityAddComponent2(fish_item, "SpriteComponent", {
		_tags="enabled_in_hand,fish_sprite",
		_enabled=false,
		offset_x=4,
		offset_y=4,
		image_file=fish.sprite,
	})

	EntityAddComponent2(fish_item, "ItemComponent", {
		_tags="enabled_in_world,fish_item",
		item_name=fish.name,
		max_child_items=0,
		is_pickable=true,
		is_equipable_forced=true,
		ui_sprite=fish.sprite,
		ui_description=fish.description,
		preferred_inventory="QUICK",
	})

	EntityAddComponent2(fish_item, "UIInfoComponent", {
		_tags="enabled_in_world",
    	name=fish.name
	})

	EntityAddComponent2(fish_item, "AbilityComponent", {
		ui_name=fish.name,
		throw_as_item=true,
	})

	EntitySetVariable(fish_item, "fish_size", "float", size)

	EntityAddTag(fish_item, fish.id)
	--[[
		  
  <SpriteComponent
    _tags="enabled_in_hand,fish_sprite"
    _enabled="0"
    offset_x="4"
    offset_y="4"
    image_file="data/items_gfx/in_hand/gourd_in_hand.png"
  ></SpriteComponent>


  <PhysicsBodyComponent 
    _tags="enabled_in_world"
    uid="1" 
    allow_sleep="1" 
    angular_damping="0" 
    fixed_rotation="0" 
    is_bullet="1" 
    linear_damping="0"
    auto_clean="0"
    on_death_leave_physics_body="0"
    hax_fix_going_through_ground="1"
  ></PhysicsBodyComponent>
  
  <PhysicsImageShapeComponent 
    _tags="fish_image_shape"
    body_id="1"
    centered="1"
    image_file="data/items_gfx/gourd.png"
    material="meat"
  ></PhysicsImageShapeComponent>
  
	]]

	--ComponentSetValue2(image_shape, "image_file", fish.sprite)
	return fish_item
end

function catch(bobber_type, x, y, liquid)
	random_percent = Random(1, 1000000) / 10000
	available_fish = {}

	local biome = BiomeMapGetName(x, y)

	for k, fish in pairs(fish_list)do
		if(random_percent <= fish.probability)then
			table.insert(available_fish, fish)
		end


		--if(fish.bobber_types and table.has_value(fish.liquid, liquid) and random_percent <= fish.probability)then
			--table.insert(available_fish, fish)
		--end
	end

	fish = nil

	if(available_fish[1] ~= nil)then
		fish = available_fish[Random(1, #available_fish)]
	end

	

	return fish
end