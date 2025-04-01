local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") ---@type nxml

local event_root = ModSettingGet("noita.fairmod.streamer_mode") and "fairmod/song_streamer" or "fairmod/song"

for xml in nxml.edit_file("data/entities/props/music_machines/base_music_machine.xml") do
	local audio = xml:first_of("AudioComponent")
	if audio then
		audio:set("file", "mods/noita.fairmod/fairmod.bank")
		audio:set("event_root", event_root)
	end
end
