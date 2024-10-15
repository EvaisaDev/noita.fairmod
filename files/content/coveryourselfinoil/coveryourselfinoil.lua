local effect_path="data/entities/misc/effect_oiled.xml"
local effect_content=ModTextFileGetContent(effect_path)
effect_content=effect_content:gsub("</Entity>$",
	function()
		return [[<LuaComponent script_source_file="mods/noita.fairmod/files/content/coveryourselfinoil/effect.lua" />]].."</Entity>"
	end)
ModTextFileSetContent(effect_path,effect_content)
