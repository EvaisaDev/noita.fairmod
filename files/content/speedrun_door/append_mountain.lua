-- b95ab9

RegisterSpawnFunction( 0xffb95ab9, "spawn_speedrunner_door" )

function spawn_speedrunner_door( x, y )
	EntityLoad( "mods/noita.fairmod/files/content/speedrun_door/door_entrance.xml", x + 26, y )

	
	LoadBackgroundSprite("mods/noita.fairmod/files/content/speedrun_door/speedrun_sign.png", x + 25, y - 72, -100, false)
end
