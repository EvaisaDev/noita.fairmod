ModTextFileSetContent(
	"data/scripts/items/potion_aggressive.lua",
	ModTextFileGetContent("mods/noita.fairmod/files/content/more_aggressive_potions/potion_aggressive_lib.lua")
)
ModLuaFileAppend("data/scripts/items/potion_aggressive.lua", "mods/noita.fairmod/files/content/more_aggressive_potions/potion_aggressive_append.lua")
