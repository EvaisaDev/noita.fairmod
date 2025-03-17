dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y, a = EntityGetTransform( entity_id )

local p = EntityGetWithTag( "player_unit" )
local proj = "mods/noita.fairmod/files/content/fishing/files/events/boss_fish/beam.xml"
local mult = 1.0

local length = 300
local homing = EntityGetComponent( entity_id, "HomingComponent" )
if ( homing == nil ) then
	length = 500
end

if ( p ~= nil ) and ( #proj > 0 ) then
	for i,v in ipairs( p ) do
		local px,py = EntityGetTransform( v )
		local dir = 0 - math.atan2( py - y, px - x )
		
		local vel_x = math.cos( dir ) * length * mult
		local vel_y = 0 - math.sin( dir ) * length * mult
		local pid = shoot_projectile_from_projectile( entity_id, proj, x, y, vel_x, vel_y )
		
		edit_component( pid, "ProjectileComponent", function(comp,vars)
			local d = ComponentGetValue2( comp, "damage" )
			d = d + 0.2
			ComponentSetValue2( comp, "damage", d )
		end)
	end
end