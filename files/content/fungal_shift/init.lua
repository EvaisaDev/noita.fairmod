local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

for xml in nxml.edit_file("data/entities/misc/effect_trip_03.xml") do
	local lua = xml:first_of("LuaComponent")
	if not lua then return end
	lua:set("execute_every_n_frame", 60)
	lua:set("execute_times", 1)
end

ModLuaFileAppend("data/scripts/magic/fungal_shift.lua", "mods/noita.fairmod/files/content/fungal_shift/append.lua")
ModLuaFileAppend(
	"data/scripts/status_effects/status_list.lua",
	"mods/noita.fairmod/files/content/fungal_shift/status_list_append.lua"
)
