local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")

do
	local path = "data/entities/player_base.xml"
	local content = ModTextFileGetContent(path)
	local xml = nxml.parse(content)
	xml:add_child(nxml.parse([[
        <LuaComponent
            script_shot="data/scripts/status_effects/twitchy_shot.lua"
            execute_every_n_frame="-1"
            >
        </LuaComponent>
    ]]))
	ModTextFileSetContent(path, tostring(xml))
end
