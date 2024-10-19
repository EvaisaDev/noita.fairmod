function table.dump(o)
    if type(o) == 'table' then
        local s = '{ '..string.char(10)
        for k,v in pairs(o) do
           if type(k) ~= 'number' then k = '"'..k..'"' end
           s = s .. '['..k..'] = ' .. table.dump(v) .. ',' ..string.char(10)
        end
        return s .. '} '..string.char(10)
     else
        if(type(o) == "string")then
            return '"'..o..'"'
        else
            return tostring(o)
        end
     end
end

function get_held_item(animal)
	local inv_comp = EntityGetFirstComponentIncludingDisabled(
	  animal, "Inventory2Component"
	)
  
	if not inv_comp then
	  return nil
	end
  
	return ComponentGetValue2(inv_comp, "mActiveItem")
end
  
function split(str, max_line_length)
   local lines = {}
   local line
   str:gsub('(%s*)(%S+)', 
      function(spc, word) 
         if not line or #line + #spc + #word > max_line_length then
            table.insert(lines, line)
            line = word
         else
            line = line..spc..word
         end
      end
   )
   table.insert(lines, line)
   return lines
end

function smart_split(str, max_line_length)
	local lines = {}
	local line
	str:gsub('(%s*)(%S+)', 
	   function(spc, word) 
		  if not line or #line + #spc + #word > max_line_length then
			 table.insert(lines, line)
			 line = word
		  else
			 line = line..spc..word
		  end
	   end
	)
	table.insert(lines, line)

	local output = ""

	for k, v in pairs(lines)do
		output = output .. v .. "\n"
	end

	return output
end

function EntitySetVerletPoints(entity, start_x, start_y, end_x, end_y)
	local verlet_physics_component = EntityGetFirstComponent(entity, "VerletPhysicsComponent")
	
	local links = ComponentGetValue2(verlet_physics_component, "num_points")
	local resting_distance = ComponentGetValue2(verlet_physics_component, "resting_distance")

	local end_x_index = (links*2) - 1
	local end_y_index = (links*2)
	
	EntityApplyTransform(entity, start_x, start_y)
	
	local positions = ComponentGetValue2(verlet_physics_component, "positions")

	local stretch_distance = get_distance( start_x, start_y, end_x, end_y )

	local overshoot = (stretch_distance / resting_distance) / 2
	
	local direction = get_direction( positions[end_x_index - 2], positions[end_y_index - 2], positions[end_x_index], positions[end_y_index] )
	
	local dir_x, dir_y = rad_to_vec( direction )

	positions[end_x_index] = end_x-- + (dir_x * math.abs(overshoot))
	positions[end_y_index] = end_y-- + (dir_y * math.abs(overshoot))

	ComponentSetValue2(verlet_physics_component, "positions", positions)
end

function EntityGetVariable(entity, name, type)
	value = nil
	variable_storages = EntityGetComponent(entity, "VariableStorageComponent")
	if(variable_storages ~= nil)then
		for k, v in pairs(variable_storages)do
			name_out = ComponentGetValue2(v, "name")
			if(name_out == name)then
				value = ComponentGetValue2(v, "value_"..type)
			end
		end
	end
	return value
end

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function EntitySetVariable(entity, name, type, value)
	variable_storages = EntityGetComponent(entity, "VariableStorageComponent")
	has_been_set = false
	if(variable_storages ~= nil)then
		for k, v in pairs(variable_storages)do
			name_out = ComponentGetValue2(v, "name")
			if(name_out == name)then
				ComponentSetValue2(v, "value_"..type, value)
				has_been_set = true
			end
		end
	end
	if(has_been_set == false)then
		comp = {}
		comp.name = name
		comp["value_"..type] = value
		EntityAddComponent2(entity, "VariableStorageComponent", comp)
	end
end


function EntityHasFlag(entity, name)
	value = false
	variable_storages = EntityGetComponent(entity, "VariableStorageComponent")
	if(variable_storages ~= nil)then
		for k, v in pairs(variable_storages)do
			name_out = ComponentGetValue2(v, "name")
			if(name_out == name)then
				value = ComponentGetValue2(v, "value_bool")
			end
		end
	end
	return value
end

function EntityAddFlag(entity, name)
	variable_storages = EntityGetComponent(entity, "VariableStorageComponent")
	has_been_set = false
	if(variable_storages ~= nil)then
		for k, v in pairs(variable_storages)do
			name_out = ComponentGetValue2(v, "name")
			if(name_out == name)then
				ComponentSetValue2(v, "value_bool", true)
				has_been_set = true
			end
		end
	end
	if(has_been_set == false)then
		comp = {}
		comp.name = name
		comp["value_bool"] = true
		EntityAddComponent2(entity, "VariableStorageComponent", comp)
	end
end

function EntityRemoveFlag(entity, name)
	variable_storages = EntityGetComponent(entity, "VariableStorageComponent")
	if(variable_storages ~= nil)then
		for k, v in pairs(variable_storages)do
			name_out = ComponentGetValue2(v, "name")
			if(name_out == name)then
				EntityRemoveComponent(entity, v)
			end
		end
	end
end

function math.lerp(a,b,t) return a + (b-a) * 0.5 * t end

function math.clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end