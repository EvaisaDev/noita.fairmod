local wizards = {
    "data/entities/animals/wizard_dark.xml",
    "data/entities/animals/wizard_hearty.xml",
    "data/entities/animals/wizard_homing.xml",
    "data/entities/animals/wizard_neutral.xml",
    "data/entities/animals/wizard_poly.xml",
    "data/entities/animals/wizard_returner.xml",
    "data/entities/animals/wizard_swapper.xml",
    "data/entities/animals/wizard_tele.xml",
    "data/entities/animals/wizard_twitchy.xml",
    "data/entities/animals/wizard_weaken.xml",
}
for _, wizfile in ipairs(wizards) do
	local content = ModTextFileGetContent(wizfile)
	content = content:gsub("<Entity[^\n]*", [[%0
	<LuaComponent
		script_source_file="mods/noita.fairmod/files/content/wizard_crash/spawn_friend.lua"
		execute_on_added="1"
		remove_after_executed="1"
		/>
	]], 1)
	ModTextFileSetContent(wizfile, content)
end
