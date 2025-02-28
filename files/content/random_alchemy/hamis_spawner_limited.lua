local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local hamis = EntityGetWithTag( "spawned_hamis" )
if ( #hamis < 20 ) then
	local eid = EntityLoad( "data/entities/animals/longleg.xml", x, y )
	EntityAddTag(eid, "spawned_hamis")
end

EntityKill( entity_id )
