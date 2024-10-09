RegisterSpawnFunction( 0xffa63ba9, "spawn_stalactite_1" )
RegisterSpawnFunction( 0xffbc42c0, "spawn_stalactite_2" )

function spawn_stalactite_1( x, y )
	EntityLoad( "mods/noita.fairmod/files/content/stalactite/entities/triggers/stalactite_entrance_1.xml", x + 5, y )
end


function spawn_stalactite_2( x, y )
	EntityLoad( "mods/noita.fairmod/files/content/stalactite/entities/triggers/stalactite_entrance_2.xml", x + 7, y )
end
