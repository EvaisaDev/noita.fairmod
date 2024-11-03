ModLuaFileAppend("data/scripts/biomes/boss_arena.lua", "mods/noita.fairmod/files/content/kolmi_not_home/append_boss_arena.lua")
ModLuaFileAppend("data/scripts/biomes/boss_victoryroom.lua", "mods/noita.fairmod/files/content/kolmi_not_home/append_boss_victoryroom.lua")
ModLuaFileAppend("data/entities/animals/boss_centipede/death_check.lua", "mods/noita.fairmod/files/content/kolmi_not_home/kolmi_death_check.lua")

local function escape(str)
	return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

local teleport_delay_content = ModTextFileGetContent("data/entities/animals/boss_centipede/boss_centipede_update.lua")

teleport_delay_content = teleport_delay_content:gsub(
	escape([[EntityLoad( "data/entities/buildings/teleport_ending_victory_delay.xml", x_portal, y_portal )]]),
	escape([[
if( not GameHasFlagRun("kolmi_not_home") )then
	EntityLoad( "data/entities/buildings/teleport_ending_victory_delay.xml", x_portal, y_portal )
end
GameAddFlagRun("kolmi_killed")
]])
)

ModTextFileSetContent("data/entities/animals/boss_centipede/boss_centipede_update.lua", teleport_delay_content)
