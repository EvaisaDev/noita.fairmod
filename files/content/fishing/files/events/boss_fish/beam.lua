dofile_once("data/scripts/lib/utilities.lua")

local target_distance = 288
local segment_width = 64

local entity_id = GetUpdatedEntityID()
local x, y, angle = EntityGetTransform(entity_id)
local target_x = x + math.cos(angle) * target_distance
local target_y = y + math.sin(angle) * target_distance

local did_hit, hit_x, hit_y = RaytracePlatforms(x, y, target_x, target_y)
local effective_distance = did_hit and get_distance(x, y, hit_x, hit_y) or target_distance

if(GameGetFrameNum() % 1 == 0)then
	EntityLoad("mods/noita.fairmod/files/content/fishing/files/events/boss_fish/touch_water.xml", hit_x, hit_y)
end

local n = GetValueInteger("frames", 0)
n = n + 1
if n > 15 then
	local laser_emitter = EntityGetComponentIncludingDisabled(entity_id, "LaserEmitterComponent") or {}
	for _, comp in ipairs(laser_emitter) do
		ComponentSetValue2(comp, "is_emitting", true)
	end
end

SetValueInteger("frames", n)

EntitySetTransform(entity_id, x, y, angle, 1, 1)

local sprite_comps = EntityGetComponentIncludingDisabled(entity_id, "SpriteComponent") or {}
local last_segment = math.ceil(effective_distance / segment_width)

local last_offset = 5
local i = 1
local length = last_segment * segment_width
local percentage = effective_distance / length

for _, comp in ipairs(sprite_comps) do
    local image_file = ComponentGetValue2(comp, "image_file")
    if image_file then
        local suffix = string.sub(image_file, -10)
        if suffix == "beam_b.xml" then
            if i <= last_segment then
				

                -- For the last segment, adjust the scale to the remaining distance.
                ComponentSetValue2(comp, "offset_x", -last_offset)

            	ComponentSetValue2(comp, "has_special_scale", true)
                ComponentSetValue2(comp, "special_scale_x", percentage)
                ComponentSetValue2(comp, "special_scale_y", 1)
				
				last_offset = last_offset + (segment_width)
				
				EntitySetComponentIsEnabled(entity_id, comp, true)
            else
                -- Disable any segments beyond the needed beam length.
                EntitySetComponentIsEnabled(entity_id, comp, false)
            end

            
            i = i + 1
        elseif suffix == "beam_c.xml" then
            ComponentSetValue2(comp, "offset_x", -(((last_segment * segment_width) * percentage) - 5))
            ComponentSetValue2(comp, "special_scale_x", 1)
            ComponentSetValue2(comp, "special_scale_y", 1)
            EntitySetComponentIsEnabled(entity_id, comp, true)
        end
    end
end
