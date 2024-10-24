local entity = GetUpdatedEntityID()


local x, y, r = EntityGetTransform( entity )

local sprite_comp_hand = EntityGetFirstComponentIncludingDisabled( entity, "SpriteComponent", "enabled_in_hand" )
local sprite_comp = EntityGetFirstComponentIncludingDisabled( entity, "SpriteComponent", "enabled_in_world" )

if(EntityGetRootEntity(entity) == entity)then
	EntitySetTransform(entity, x, y, 0)
end

if(sprite_comp_hand)then
	-- if rotated upside down, set ComponentSetValue2( sprite_comp_hand, "special_scale_y", -0.05 )
	GamePrint(tostring(r))
	if(r > 1.6 or r < -1.6)then
		ComponentSetValue2( sprite_comp_hand, "special_scale_y", -0.05 )
	else
		ComponentSetValue2( sprite_comp_hand, "special_scale_y", 0.05 )
	end
end

local var_storage_comps = EntityGetComponentIncludingDisabled( entity, "VariableStorageComponent" )
if not var_storage_comps then return end
local volume_var = nil
for i,comp in ipairs( var_storage_comps ) do
    local var_name = ComponentGetValue2( comp, "name" )
    if( var_name == "dingus_volume" ) then
        volume_var = comp
        break
    end
end
if not volume_var then return end
local volume = ComponentGetValue2( volume_var, "value_float" )


if(sprite_comp)then
	if(volume < 0.5)then
		ComponentSetValue2( sprite_comp, "rect_animation", "idle" )
	else
		ComponentSetValue2( sprite_comp, "rect_animation", "dance" )
	end
end

local ability_component = EntityGetFirstComponentIncludingDisabled( entity, "AbilityComponent" )
last_frame_used = last_frame_used or 0
local frame = GameGetFrameNum()
if(ability_component)then
	local next_frame_usable = ComponentGetValue2( ability_component, "next_frame_usable" )
	if(next_frame_usable >= frame and last_frame_used < frame - 1)then
		
		last_frame_used = frame
	end
end


function interacting( entity_who_interacted, entity_interacted, interactable_name )


    if volume > 0.5 then
        volume = 0.001
    else
        volume = 1
    end

    ComponentSetValue2( volume_var, "value_float", volume )
end

local audio_loop = EntityGetFirstComponentIncludingDisabled( entity, "AudioLoopComponent" )
if not audio_loop then return end
ComponentSetValue2( audio_loop, "m_volume", volume )