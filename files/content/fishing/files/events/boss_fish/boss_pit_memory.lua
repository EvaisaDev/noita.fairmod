dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local pf_comp = EntityGetFirstComponent( entity_id, "PathFindingComponent")
if( pf_comp ) then
	local pf_state = ComponentGetValue2( pf_comp, "read_state" )

	local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
	if ( comps ~= nil ) then
		for i,v in ipairs( comps ) do
			local n = ComponentGetValue2( v, "name" )
			if( n == "pathfinding_frames_stuck" ) then
				local frames_stuck = ComponentGetValue2( v, "value_int" )
				if( pf_state <= 1 ) then 
					frames_stuck = frames_stuck + 1 
				else
					frames_stuck = 0
				end
				ComponentSetValue2( v, "value_int", frames_stuck )
				-- NOTE( Petri ): if frames_stuck is like higher than 160 it means the boss is stuck
				-- print( "frames_stuck: " .. tostring( frames_stuck ) )
			end
		end
	end
end

