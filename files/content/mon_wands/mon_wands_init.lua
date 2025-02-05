local content = ModTextFileGetContent("data/entities/base_humanoid.xml")
content = content:gsub(
	"<Entity[^\n]*",
	[[%0
<LuaComponent
	script_source_file="mods/noita.fairmod/files/content/mon_wands/mon_wands.lua"
	execute_on_added="1"
	remove_after_executed="1"
	/><LuaComponent
	script_damage_received="mods/noita.fairmod/files/content/payphone/copilogue/woe.lua" execute_every_n_frame="-1"
	/>
]],
	1
)
ModTextFileSetContent("data/entities/base_humanoid.xml", content)
