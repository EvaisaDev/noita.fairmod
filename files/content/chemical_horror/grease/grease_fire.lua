dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")


local entity_id = GetUpdatedEntityID()
entity_id = EntityGetRootEntity( entity_id )

local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum() + GetUpdatedComponentID(), pos_x + pos_y + entity_id )

local rand = Random(45,135)

local angle = math.rad(rand)
local length = Random(150,400)

local vel_x = math.cos( angle ) * length
local vel_y = 0 - math.sin( angle ) * length
	
if(Random(1,10) == 1) then
	shoot_projectile( entity_id, "mods/noita.fairmod/files/content/chemical_horror/grease/grease_bubble.xml", pos_x, pos_y, vel_x, vel_y )
end

EntityKill( entity_id )
