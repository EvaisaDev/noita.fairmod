--stylua: ignore start
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")

local paths = {
	"data/entities/animals/boss_centipede/ending/ending_sampo_spot_underground.xml",
	"data/entities/animals/boss_centipede/ending/ending_sampo_spot_mountain.xml",
}

for k = 1, #paths do
	local content = ModTextFileGetContent(paths[k])
	local xml = nxml.parse(content)
	xml:add_child(nxml.parse([[
    <LifetimeComponent
		lifetime="30"
		>
	</LifetimeComponent>
    ]]))
	ModTextFileSetContent(paths[k], tostring(xml))
end

do
	local path = "data/scripts/biomes/boss_victoryroom.lua"
	local content = ModTextFileGetContent(path)
	content = content:gsub(	"data/entities/animals/boss_centipede/ending/ending_sampo_spot_underground%.xml","mods/noita.fairmod/files/content/ending_quiz/fake_ending.xml")
	ModTextFileSetContent(path, content)
end

do
	local path = "data/scripts/biomes/mountain/mountain_floating_island.lua"
	local content = ModTextFileGetContent(path)
	content = content:gsub("data/entities/animals/boss_centipede/ending/ending_sampo_spot_mountain%.xml","mods/noita.fairmod/files/content/ending_quiz/fake_ending.xml")
	ModTextFileSetContent(path, content)
end

do
	local path = "data/entities/animals/boss_centipede/ending/sampo_start_ending_sequence.lua"
	local content = ModTextFileGetContent(path)
	content = content:gsub('GamePlaySound%( "data/audio/Desktop/event_cues%.bank", "event_cues/midas/create", x, y %)', "")
	ModTextFileSetContent(path, content)
end

local module = {}

local opts = { "circle", "square", "triangle", "diamond", "rectangle", "pentagon", "star" }

module.spawn_shape = function(x, y)
	SetRandomSeed(x, y)
	local shape_chosen = GlobalsGetValue("fairmod_ending_quiz_shape", "null")
	if shape_chosen == "null" then
		local shape = opts[Random(1, #opts)]
		EntityLoad(table.concat({ "mods/noita.fairmod/files/content/ending_quiz/shape/", shape, ".xml" }),x + 135,y - 40)
		GlobalsSetValue("fairmod_ending_quiz_shape", shape)
	end
end

return module
--stylua: ignore end