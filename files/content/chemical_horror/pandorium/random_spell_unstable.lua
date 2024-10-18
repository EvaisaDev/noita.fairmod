dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y, rot = EntityGetTransform( entity_id )
SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

function bullet_circle( which, count, speed, animal_ )
	local theta = rot
	local length = speed or 200
    local name = which
    
    local rotation = math.rad(Random(0, 360))
	
	local animal = animal_ or false

	for i=1,count do
		local vel_x = math.cos( rotation ) * length
		local vel_y = 0 - math.sin( rotation ) * length

		local bid = shoot_projectile( entity_id, name, pos_x + math.cos( rotation ) * 12, pos_y - math.sin( rotation ) * 12, vel_x, vel_y )
		
		if animal then
			EntityAddComponent2( bid, "VariableStorageComponent", 
            { 
                _tags="no_gold_drop",
            } )
		end
		
	end
end

spells = {}

function table.has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

dofile("data/scripts/gun/gun_actions.lua")

for k, data in pairs(actions)do
    if(data.related_projectiles ~= nil)then
        if(data.pandorium_ignore)then
            goto continue
        end
        for k2, v in pairs(data.related_projectiles)do
            if(table.has_value(spells, v) == false)then
                table.insert(spells, v)
            end
        end
    end
    ::continue::
end
if(Random(1, 100) > 50)then
    bullet_circle( spells[Random(1,#spells)], 1, 600 )

end


EntityKill(GetUpdatedEntityID())