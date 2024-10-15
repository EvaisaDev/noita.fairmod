dofile( "data/scripts/lib/utilities.lua" )

function item_pickup( entity_item, entity_who_picked, name )

	local x,y = EntityGetTransform( entity_item )

	GameTriggerMusicFadeOutAndDequeueAll( 10.0 )
	GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/sampo_pick/create", x, y )

	SetRandomSeed( x, y )

	EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", x, y)
	print("Sampo pickup: " .. tostring(x) .. ", " .. tostring(y))

	y = y - 50
	EntityLoad( "data/entities/buildings/teleport_ending_victory.xml", x, y )


end