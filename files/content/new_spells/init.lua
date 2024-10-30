if ModSettingGet("noita.fairmod.streamer_mode") then
	local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
	for xml in nxml.edit_file("mods/noita.fairmod/files/content/new_spells/racoon/racoon.xml") do
		local loop = xml:first_of("AudioLoopComponent")
		if loop then loop:set("event_name", "pedro/pedro_streamer") end
	end
end

ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita.fairmod/files/content/new_spells/racoon/racoon.lua")
ModLuaFileAppend(
	"data/scripts/gun/gun_actions.lua",
	"mods/noita.fairmod/files/content/new_spells/spakr_bolt/spakr_bolt.lua"
)
