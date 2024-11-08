-- Kill the left 4 pixels of water so that 2 materials don't mix
local altar = ModImageMakeEditable("data/biome_impl/temple/altar.png", 512, 282)
for y=118,193 do
	for x=0,4 do
		ModImageSetPixel(altar, x, y, 0)
	end
end


-- Holy Mountain portal scenes
ModLuaFileAppend(
	"data/scripts/biomes/temple_altar_top_shared.lua",
	"mods/noita.fairmod/files/content/scene_liquid_randomizer/portal_pools/append_pool.lua"
)
-- silly goober you broke the final portal
--[[ModLuaFileAppend(
	"data/scripts/biomes/temple_wall_ending.lua",
	"mods/noita.fairmod/files/content/scene_liquid_randomizer/portal_pools/append_pool.lua"
)]]

-- Holy Mountain pools
ModLuaFileAppend("data/scripts/biomes/temple_altar.lua", "mods/noita.fairmod/files/content/scene_liquid_randomizer/hm_pools/append_hm_direct.lua")
ModLuaFileAppend("data/scripts/biomes/temple_altar_left.lua", "mods/noita.fairmod/files/content/scene_liquid_randomizer/hm_pools/append_hm_direct.lua")
ModLuaFileAppend("data/scripts/biomes/boss_arena.lua", "mods/noita.fairmod/files/content/scene_liquid_randomizer/hm_pools/append_hm.lua")

