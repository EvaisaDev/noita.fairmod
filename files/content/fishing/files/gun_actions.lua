dofile_once("mods/noita.fairmod/files/content/fishing/files/eva_utils.lua")
dofile_once("data/scripts/lib/utilities.lua")

dofile("mods/noita.fairmod/files/content/fishing/definitions/bait_list.lua")
for k, v in pairs(bait_list)do
	if(v.id ~= "any")then
		table.insert(actions, {
			id          = v.id,
			name 		= "Bait - "..v.ui_name,
			description = v.ui_description,
			sprite 		= v.sprite,
			type 		= ACTION_TYPE_OTHER,
			spawn_level                       = "0",
			spawn_probability                 = "0",
			price = v.price,
			mana = 0,
			max_uses = v.max_uses,
			action 		= function( recursion_level, iteration )

				--print("Bait casted!")

				c.fire_rate_wait = c.fire_rate_wait + 10
				player = get_players()[1]
				--print("reeeeeeee")
				if(player == GetUpdatedEntityID())then
					x, y = EntityGetTransform(player)

					local wand = get_held_item(player)

					local children = EntityGetAllChildren( wand )

					if(EntityHasTag(wand, "fishing_rod"))then

						--print(tostring(EntityGetClosestWithTag(  x, y, "bobber" )))
						if(EntityGetClosestWithTag(  x, y, "bobber" ) == 0)then
							add_projectile("mods/noita.fairmod/files/content/fishing/files/baits/entities/"..v.id..".xml")

							GameRemoveFlagRun("allow_catch_fish")
							GameRemoveFlagRun("kill_fishing_challenge_ui")
	
							--hand[1].uses_remaining = hand[1].uses_remaining + 1
						else
							
							bobber = EntityGetClosestWithTag(  x, y, "bobber" )


							if(EntityHasFlag(bobber, "is_catch_allowed") == false and not EntityHasFlag(bobber, "failed_catch"))then
								--hand[1].uses_remaining = hand[1].uses_remaining + 1
							end

							if(EntityHasFlag(bobber, "return_bobber") == false)then
								EntityAddFlag(bobber, "return_bobber")

								--print("returning bobber")

								bobber_x, bobber_y = EntityGetTransform(bobber)

								EntitySetVariable(bobber, "frame_num_start", "int", GameGetFrameNum())

								EntitySetVariable(bobber, "last_position_x", "int", bobber_x)
								EntitySetVariable(bobber, "last_position_y", "int", bobber_y)

								EntitySetVariable(bobber, "last_position_player_x", "int", x)
								EntitySetVariable(bobber, "last_position_player_y", "int", y)

								
							end
							
							local inventory2 = EntityGetFirstComponent( player, "Inventory2Component" );
							if inventory2 ~= nil then
								ComponentSetValue2( inventory2, "mForceRefresh", true );
								ComponentSetValue2( inventory2, "mActualActiveItem", 0)
							end

							--EntityKill(children[1])

							for k2, v2 in pairs(EntityGetComponentIncludingDisabled(children[1], "ItemComponent"))do
								if ComponentGetValue2( v2, "permanently_attached" ) == false and ComponentGetValue2( v2, "uses_remaining" ) == 1 then
									EntityKill(children[1])
								end
							end

							local inventory2 = EntityGetFirstComponent( player, "Inventory2Component" );
							if inventory2 ~= nil then
								ComponentSetValue2( inventory2, "mForceRefresh", true );
								ComponentSetValue2( inventory2, "mActualActiveItem", 0)
							end
						end
					else
						--hand[1].uses_remaining = hand[1].uses_remaining + 1
						GamePrint("Bait can only be used in a fishing rod.")
					end	
				end
				--draw_actions( 1, true )
			end,
		})
	end
end

