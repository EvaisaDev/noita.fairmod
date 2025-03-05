
local old_drop_random_reward = drop_random_reward
function drop_random_reward(x, y, entity_id, rand_x, rand_y, set_rnd_)
	local set_rnd = set_rnd_ or false 
	if( set_rnd ) then
		SetRandomSeed(GameGetFrameNum(), x + y + entity_id)
	end

	if Random(1,120) > 1 then
		return old_drop_random_reward(x, y, entity_id, rand_x, rand_y, set_rnd)
	end

	local eid = EntityLoad("data/entities/items/orbs/orb_11.xml", x + Random(-10,10), y - 4 + Random(-5,5))

	local orb_comp = EntityGetFirstComponentIncludingDisabled(eid, "OrbComponent")
	if orb_comp ~= nil then
		ComponentSetValue2(orb_comp, "orb_id", GameGetOrbCountThisRun() + 1)
	end

	local item_comp = EntityGetFirstComponent( eid, "ItemComponent" )
	if item_comp ~= nil then
		if( ComponentGetValue2( item_comp, "auto_pickup") ) then
			ComponentSetValue2( item_comp, "next_frame_pickable", GameGetFrameNum() + 30 )	
		end
	end
	return true
end
