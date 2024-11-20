local log = ModTextFileGetContent("mods/noita.fairmod/files/content/credits/commit_log.txt")

local log = [[Fair Mod Commit History

]] .. log .. [[

Added approximately 95,236,821,904,984 hamisket]]

ModTextFileSetContent("data/credits.txt", log)
