RegisterSpawnFunction( 0xffbc42c0, "spawn_stalactite_1" )

function spawn_stalactite_1( x, y )
	EntityLoad( "mods/noita.fairmod/files/content/stalactite/stalactite.xml", x - 7, y )
end
