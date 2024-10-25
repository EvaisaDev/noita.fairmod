local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")

do
	local path = "data/entities/props/forcefield_generator.xml"

	local content = ModTextFileGetContent(path)
	local xml = nxml.parse(content)
	xml:add_child(nxml.parse([[
    <GenomeDataComponent 
        herd_id="orcs"
        food_chain_rank="9"
        is_predator="1" >
    </GenomeDataComponent>
    ]]))
	ModTextFileSetContent(path, tostring(xml))
end

do
	local path = "data/scripts/props/forcefield_generator.lua"
	local content = ModTextFileGetContent(path)
	content = content:gsub('"enemy"', '"player_unit"')
	ModTextFileSetContent(path, content)
end
