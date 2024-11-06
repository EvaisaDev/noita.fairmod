local popups = {}
local append_decoded = ModTextFileGetContent("mods/noita.fairmod/files/content/popups/files/append.lua")
local script_decoded = ModTextFileGetContent("mods/noita.fairmod/files/content/popups/files/script.lua")
ModTextFileSetContent("mods/noita.fairmod/virtual/content/popups/files/append.lua", append_decoded)
ModTextFileSetContent("mods/noita.fairmod/virtual/content/popups/files/script.lua", script_decoded)
popups = dofile_once("mods/noita.fairmod/virtual/content/popups/files/append.lua")
return popups
--ModLuaFileAppend("mods/noita.fairmod/files/content/popups/init.lua", "mods/noita.fairmod/virtual/content/popups/files/append.lua")
