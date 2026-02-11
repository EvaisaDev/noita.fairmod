local credits = "\n \n=== Fair Mod Commit History ===\n" .. ModTextFileGetContent("mods/noita.fairmod/files/content/credits/commit_log.txt"):gsub("\r\n", "\n")

local function escape(str) return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1") end

local function add_release_break(target, release)
    target = "\n" .. target .. "\n"
    credits = credits:gsub(escape(target), target .. " \n--- " .. release .. " ---\n \n")
end

add_release_break("fixed init (was in absolute fucking shambles)", " MAIN RELEASE 31/10/24")
add_release_break("Labor of Loathing is here :)", "LABOR OF LOATHING 1/4/25")

local dev_messages = {}

local dev_msg_txt = #dev_messages ~= 0 and "\n \n \n==== FINAL WORDS ====" or ""

for dev, message in pairs(dev_messages) do
    dev_msg_txt = dev_msg_txt .. "~MESSAGES FROM " .. dev .. "~\n" .. message .. "\n \n"
end

credits = credits .. dev_msg_txt .. "\n \n \n \nAdded approximately 95,236,821,904,984 hamisket"

ModTextFileSetContent("data/credits.txt", credits)
