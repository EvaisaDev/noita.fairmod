dofile_once("data/scripts/lib/utilities.lua")

-- all functions below are optional and can be left out

--[[

function OnModPreInit()
	print("Mod - OnModPreInit()") -- First this is called for all mods
end

function OnModInit()
	print("Mod - OnModInit()") -- After that this is called for all mods
end

function OnModPostInit()
	print("Mod - OnModPostInit()") -- Then this is called for all mods
end

function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	GamePrint( "OnPlayerSpawned() - Player entity id: " .. tostring(player_entity) )
end

function OnWorldInitialized() -- This is called once the game world is initialized. Doesn't ensure any world chunks actually exist. Use OnPlayerSpawned to ensure the chunks around player have been loaded or created.
	GamePrint( "OnWorldInitialized() " .. tostring(GameGetFrameNum()) )
end

function OnWorldPreUpdate() -- This is called every time the game is about to start updating the world
	GamePrint( "Pre-update hook " .. tostring(GameGetFrameNum()) )
end

function OnWorldPostUpdate() -- This is called every time the game has finished updating the world
	GamePrint( "Post-update hook " .. tostring(GameGetFrameNum()) )
end

function OnMagicNumbersAndWorldSeedInitialized() -- this is the last point where the Mod* API is available. after this materials.xml will be loaded.
	local x = ProceduralRandom(0,0)
	print( "===================================== random " .. tostring(x) )
end

]]
--

dofile_once("mods/noita.fairmod/files/content/chemical_horror/methane/shader_utilities.lua")
postfx.append(
"uniform vec4 grayscale;",
"uniform vec4 brightness_contrast_gamma;",
"data/shaders/post_final.frag"
)
postfx.append(
[[
color = mix(color, vec3(dot(color,vec3(.2126, .7152, .0722))), grayscale.a );
]],
"// various debug visualizations================================================================================",
"data/shaders/post_final.frag"
)



ModLuaFileAppend("data/scripts/status_effects/status_list.lua", "mods/noita.fairmod/files/content/chemical_horror/status_effects.lua")
ModMaterialsFileAdd("mods/noita.fairmod/files/content/chemical_horror/materials.xml")

--print("Example mod init done")
