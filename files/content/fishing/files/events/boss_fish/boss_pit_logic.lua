dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local dm = 1.0

edit_component( entity_id, "HitboxComponent", function(comp,vars)
	dm = ComponentGetValue2( comp, "damage_multiplier" )
	
	if ( dm < 1.0 ) then
		dm = math.min( 1.0, dm + 0.35 )
	end
	
	ComponentSetValue2( comp, "damage_multiplier", dm )
end)

EntitySetComponentsWithTagEnabled( entity_id, "invincible", false )

local state = 0
local p = ""
local pathfinding_frames_stuck = 0
local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
if ( comps ~= nil ) then
	for i,v in ipairs( comps ) do
		local n = ComponentGetValue2( v, "name" )
		if ( n == "state" ) then
			state = ComponentGetValue2( v, "value_int" )
			
			state = (state + 1) % 10
			
			ComponentSetValue2( v, "value_int", state )
		elseif ( n == "pathfinding_frames_stuck" ) then
			pathfinding_frames_stuck = ComponentGetValue2( v, "value_int" )
		end
	end
end

SetRandomSeed( x, y * GameGetFrameNum() )

local players = EntityGetWithTag( "player_unit" )
local player = players[1]

if ( state == 1 ) then

	local angle = Random( 1, 200 ) * math.pi
	local vel_x = math.cos( angle ) * 100
	local vel_y = 0 - math.cos( angle ) * 100

	local wid = shoot_projectile( entity_id, "mods/noita.fairmod/files/content/fishing/files/events/boss_fish/wand.xml", x, y, vel_x, vel_y )

	EntityAddComponent( wid, "HomingComponent", 
	{ 
		homing_targeting_coeff = "30.0",
		homing_velocity_multiplier = "0.16",
		target_tag = "player_unit",
	} )
	

elseif ( state == 7 ) then
	if ( Random( 1, 10 ) == 5 ) or ( 1 == 1 ) then

		-- if we're stuck shoot blackholes towards player
		if( pathfinding_frames_stuck > 160 ) then
			
			-- we're stuck, lets hunt for that connoisseur of cheese
			local path = "mods/noita.fairmod/files/content/fishing/files/events/boss_fish/remove_ground.xml"
			local wid = shoot_projectile( entity_id, path, x, y, 0, 0 )
		end
	end
end