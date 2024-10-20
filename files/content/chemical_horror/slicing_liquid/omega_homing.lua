dofile_once("data/scripts/lib/utilities.lua")

local distance_full = 400
local float_range = 200
local float_force = 300
local float_sensor_sector = math.pi * 0.3

local entity_id = GetUpdatedEntityID()
local x, y, rot = EntityGetTransform(entity_id)
local velcomp = EntityGetComponent(entity_id, "VelocityComponent")

if velcomp == nil then return end
local nearest_player = EntityGetClosestWithTag(x, y, "player_unit")
local nearest_polyd_player = EntityGetClosestWithTag(x, y, "polymorphed_player")
print(tostring(nearest_player))
print(tostring(nearest_polyd_player))

if nearest_player <= 0 and nearest_polyd_player <= 0 then return end

local player --in the event of multiplayer
if nearest_player > 0 and nearest_polyd_player > 0 then --basically if both poly'd and non-poly'd players exist, decide which is closer
	local A = { EntityGetTransform(nearest_player) } --this is theory code btw, dont have a reasonable way to test this lmao
	local B = { EntityGetTransform(nearest_polyd_player) } --below code: compare distances and pick the one with the shortest, prioritising nearest_player
	A.xdistance, A.ydistance = x - A[1], y - A[2]
	B.xdistance, B.ydistance = x - B[1], y - B[2]
	player = math.sqrt(A.xdistance ^ 2 + A.ydistance ^ 2) > math.sqrt(B.xdistance ^ 2 + B.ydistance ^ 2)
			and { id = nearest_player, x = A.xdistance, y = A.ydistance }
		or { id = nearest_polyd_player, x = B.xdistance, y = B.ydistance }
else
	player = { id = math.max(nearest_player, nearest_polyd_player) }
	local transform = { EntityGetTransform(player.id) }
	player.xdistance, player.ydistance = x - transform[1], y - transform[2]
end

if player == nil then
	print("wHAt the fUCK?! (both player and poly player are nil??)")
	return
end

--local distance = math.sqrt( a^2 + b^2 )

--local distance = math.sqrt( a^2 + b^2 )
local direction = 0 - math.atan2(player.ydistance, player.xdistance)

-- local gravity_percent = ( distance_full - distance ) / distance_full
-- local gravity_percent = 8
local gravity_coeff = 160

local fx = math.cos(direction) * gravity_coeff
local fy = math.sin(direction) * gravity_coeff

local velcomp1 = velcomp[1]
local vel_x, vel_y = ComponentGetValue2(velcomp1, "mVelocity")
ComponentSetValue2(velcomp1, "mVelocity", (vel_x - fx) * 0.8, (vel_y + fy) * 0.8)

--LUA: entity_id is 1210, x,y is [-35224, -150.99967956543]
--LUA: target.id is 186, target.x,y is [-35233.02734375, -88.982971191406]
--LUA: a,b is [9.02734375,-62.016708374023], distance is 62.670288436621, direction is 1.5546730372617
--LUA: fx is 3.160027830635, fy is -195.97452442629

--Code mostly nabbed from Evaisa's Condensed Gravity effect in CC

--[[ 
-- stainPercent = (Stain% * 5 + IngestionSeconds * .05) < 1.5

local function calculate_force_at(body_x, body_y)
	local distance = math.sqrt( ( x - body_x ) ^ 2 + ( y - body_y ) ^ 2 )
	if distance * (stainPercent * .9) < 12 then
		-- stop attracting when near enough to prevent some collisions against moon
		return 0,0
	end
	local direction = 0 - math.atan2( ( y - body_y ), ( x - body_x ) )

	-- local gravity_percent = ( distance_full - distance ) / distance_full 
	-- local gravity_percent = 8
	local gravity_coeff = 196
	
	local fx = math.cos( direction ) * ( gravity_coeff * stainPercent )
	local fy = -math.sin( direction ) * ( gravity_coeff * stainPercent )

    return fx,fy
end


-- force field for physics bodies
local function calculate_force_for_body( entity, body_mass, body_x, body_y, body_vel_x, body_vel_y, body_vel_angular )
	local fx, fy = calculate_force_at(body_x, body_y)

	fx = fx * 0.11 * body_mass
	fy = fy * 0.11 * body_mass

    return body_x,body_y,fx,fy,0 -- forcePosX,forcePosY,forceX,forceY,forceAngular
end
local size = distance_full * 0.5
PhysicsApplyForceOnArea( calculate_force_for_body, entity_id, x-size, y-size, x+size, y+size )


-- float by raycasting down and applying opposite physical force



do
	local dir_x = 0
	local dir_y = float_range
	dir_x, dir_y = vec_rotate(dir_x, dir_y, ProceduralRandomf(x, y + GameGetFrameNum(), -float_sensor_sector, float_sensor_sector))
	
	local did_hit,hit_x,hit_y = RaytracePlatforms( x, y, x + dir_x, y + dir_y )
	if did_hit then
		local dist = get_distance(x, y, hit_x, hit_y)
		dist = math.max(6, dist) -- tame a bit on close encounters
		dir_x = -dir_x / dist * float_force
		dir_y = -dir_y / dist * float_force
		PhysicsApplyForce(entity_id, dir_x, dir_y)
	end
end

 ]]
