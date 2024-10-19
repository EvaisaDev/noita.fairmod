dofile_once("data/scripts/lib/utilities.lua")

dofile("mods/noita.fairmod/files/scripts/utils/utilities.lua")

local nukes = {}

function nukes.OnWorldPreUpdate()

	local players = GetPlayers()
	
	for i, v in ipairs(players)do
		local x, y = EntityGetTransform(v)
		local projectiles = EntityGetWithTag( "projectile" )

		SetRandomSeed( x, y )

		if ( #projectiles > 0 ) then
			for i,projectile_id in ipairs( projectiles ) do
				if(not EntityHasTag( projectile_id, "tried_to_nuke" ))then
					local random = Random(0,1000000)
					local value = 0.005

					local rand = random / 10000

					if rand <= value then
						local tags = EntityGetTags( projectile_id )
						
						if ( tags == nil ) or ( string.find( tags, "nuke" ) == nil ) then
							local px, py = EntityGetTransform( projectile_id )
							local vel_x, vel_y = 0,0
							
							local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
							local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
							
							if ( projectilecomponents ~= nil ) then
								for j,comp_id in ipairs( projectilecomponents ) do
									ComponentSetValue( comp_id, "on_death_explode", "0" )
									ComponentSetValue( comp_id, "on_lifetime_out_explode", "0" )
								end
							end
							
							if ( velocitycomponents ~= nil ) then
								edit_component( projectile_id, "VelocityComponent", function(comp,vars)
									vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity", vel_x, vel_y)
								end)
							end

							local nuke_file = "data/entities/projectiles/deck/nuke.xml"

							if(Random(0, 100) < 50 or EntityHasTag(projectile_id, "player_projectile"))then
								nuke_file = "mods/noita.fairmod/files/content/nukes/entities/projectiles/nuke_useless.xml"
							end
							
							shoot_projectile_from_projectile( projectile_id, nuke_file, px, py, vel_x, vel_y )
							EntityKill( projectile_id )
						end
					end

					EntityAddTag( projectile_id, "tried_to_nuke" )
				end
			end
		end

	end
end

return nukes