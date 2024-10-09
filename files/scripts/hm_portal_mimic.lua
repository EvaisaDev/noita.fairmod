local nxml = dofile_once("mods/noita.fairmod/lib/nxml.lua")

local xml = nxml.parse(ModTextFileGetContent("data/entities/buildings/teleport_liquid_powered.xml"))
xml:add_child(nxml.parse([[
    <LuaComponent
        _tags="mimicspawner"
        _enabled="1" 
        execute_on_added="1"
        script_source_file="mods/noita.fairmod/files/entities/animals/hm_portal_mimic/do_i_spawn.lua"
        >
    </LuaComponent>
]]))
ModTextFileSetContent("data/entities/buildings/teleport_liquid_powered.xml", tostring(xml))