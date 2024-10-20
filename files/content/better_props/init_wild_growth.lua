-- Makes root growers spread a lot more
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

ModLuaFileAppend(
	"data/scripts/biomes/temple_altar_right.lua",
	"mods/noita.fairmod/files/content/better_props/temple_altar_right_append.lua"
)

local function rootgrower_apply_changes(element)
	for comp in element:each_of("LifetimeComponent") do
		-- Go longer
		comp:set("lifetime", 500)
	end

	for comp in element:each_of("LuaComponent") do
		if comp:get("execute_every_n_frame") ~= nil then
			if comp:get("script_source_file") == "data/scripts/props/root_grower_spread.lua" then
				-- Speed of vine spread, lower is better
				comp:set("execute_every_n_frame", 1)
			else
				-- Time between when flowers spawn, lower is more frequent
				-- Too low causes more lag, so increase the duration instead
				comp:set("execute_every_n_frame", tonumber(comp:get("execute_every_n_frame")) * 2)
			end
		end
	end

	-- GIRTHY vines
	for comp in element:each_of("ParticleEmitterComponent") do
		comp:set("count_min", 20)
		comp:set("count_max", 140)
	end
end

for rootgrower_xml in nxml.edit_file("data/entities/props/root_grower.xml") do
	rootgrower_apply_changes(rootgrower_xml)

	local collision = rootgrower_xml:first_of("CollisionTriggerComponent")
	if collision ~= nil then
		collision:set("width", 350)
		collision:set("height", 350)
		collision:set("radius", 350)
	end
end

for rootgrower_branch_xml in nxml.edit_file("data/entities/props/root_grower_branch.xml") do
	rootgrower_apply_changes(rootgrower_branch_xml:first_of("Base"))
end
