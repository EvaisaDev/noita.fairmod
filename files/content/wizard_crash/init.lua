local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")

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
	local entity = nxml.parse(ModTextFileGetContent(wizfile))
	entity:add_child(nxml.new_element("LuaComponent", {
		script_source_file = "mods/noita.fairmod/files/content/wizard_crash/spawn_friend.lua",
		execute_on_added = "1",
		remove_after_executed = "1",
	}))
	ModTextFileSetContent(wizfile, tostring(entity))
end

ReplaceImage("data/generated/sprite_uv_maps/mods.noita.fairmod.files.content.wizard_crash.gfx.png", "mods/noita.fairmod/files/content/wizard_crash/uvmap.png")