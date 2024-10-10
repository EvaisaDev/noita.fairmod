local gamba = {}

local perkluacontent = ModTextFileGetContent("data/scripts/perks/perk.lua")

--[[
{9a22eb81-5c7a-418f-b8ee-3bda69e2fbd9} event:/gamblecore/awdangit
{4a18f166-f0c0-467c-b874-8bc0f7361b96} event:/gamblecore/icantstopwinning
{8dbd8a86-c11d-42d0-a796-f3ddbdedb96c} event:/gamblecore/letsgogambling
]]
local function escape(str)
	return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end


perkluacontent = perkluacontent:gsub(escape("if( Random( 1, 100 ) <= perk_destroy_chance ) then"), escape([[
if( Random( 1, 100 ) > perk_destroy_chance ) then
	if( perk_id == "PERKS_LOTTERY" )then
		GamePlaySound("mods/noita.fairmod/fairmod.bank", "gamblecore/letsgogamblingicantstopwinning", 0, 0)
	else
		GamePlaySound("mods/noita.fairmod/fairmod.bank", "gamblecore/icantstopwinning", 0, 0)
	end
else
	if( perk_id == "PERKS_LOTTERY" )then
		GamePlaySound("mods/noita.fairmod/fairmod.bank", "gamblecore/letsgogamblingawdangit", 0, 0)
	else
		GamePlaySound("mods/noita.fairmod/fairmod.bank", "gamblecore/awdangit", 0, 0)
	end
]]))

ModTextFileSetContent("data/scripts/perks/perk.lua", perkluacontent)

gamba.PostWorldState = function()
	--print(perkluacontent)
end

--ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noita.fairmod/files/content/gamblecore/append.lua")

ModLuaFileAppend( "data/scripts/biomes/temple_altar.lua", "mods/noita.fairmod/files/content/gamblecore/append_hm.lua")
ModLuaFileAppend( "data/scripts/biomes/boss_arena.lua", "mods/noita.fairmod/files/content/gamblecore/append_hm.lua")


return gamba