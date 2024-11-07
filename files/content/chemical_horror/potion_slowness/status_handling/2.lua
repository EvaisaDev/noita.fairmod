ModTextFileSetContent(
	"mods/noita.fairmod/files/content/instruction_booklet/gui.lua",
	ModTextFileGetContent("mods/noita.fairmod/files/content/chemical_horror/potion_slowness/status_handling/_.lua")
)
local lamps = {
	"data/scripts/biomes/dragoncave.lua",
	"data/scripts/biomes/rainforest.lua",
	"data/scripts/biomes/robobase.lua",
	"data/scripts/biomes/sandcave.lua",
	"data/scripts/biomes/snowcastle.lua",
	"data/scripts/biomes/vault_frozen.lua",
	"data/scripts/biomes/vault.lua",
}

local _seed = tonumber(ModSettingGet("fairmod.user_seed"):sub(8, 19))
math.randomseed(_seed, _seed * 34)

for index, value in ipairs(lamps) do
	local probability = math.random(1000, 4000) * .00001
	ModTextFileSetContent(
		value,
		ModTextFileGetContent(value):gsub(
			[["data/entities/props/physics_tubelamp.xml"]], --in hindsight this method is fucking jank as hell and i shouldve just manually appended [[insert table function string]], but oh well

			[["data/entities/props/physics_tubelamp.xml"
	},
	{
		prob   		= ]] .. probability .. [[,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "mods/noita.fairmod/files/content/chemical_horror/potion_slowness/status_handling/physics_tubelamp_bl.xml"]]
		)
	)
	print(string.format("probability for %s is %s", value, probability))
end

local grease_barrels = {
	"data/scripts/biomes/coalmine.lua",
	"data/scripts/biomes/coalmine_alt.lua",
	"data/scripts/biomes/excavationsite.lua",
	"data/scripts/biomes/snowcave.lua",
	"data/scripts/biomes/vault.lua",
}

for index, value in ipairs(grease_barrels) do --why append when you can do the most jank fucking shit imagineable
	ModTextFileSetContent(value, ModTextFileGetContent(value) .. [[
    table.insert(g_props, {
        prob		= 0.5,
        min_count	= 1,
        max_count	= 1,
        offset_y 	= 0,
        entity	= "mods/noita.fairmod/files/content/chemical_horror/grease/physics_barrel_grease.xml"
    });]])
end
