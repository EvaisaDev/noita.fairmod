local function edit_script(script_path, edit_function)
	local script = ModTextFileGetContent(script_path)
	local edited_script = edit_function(script)
	ModTextFileSetContent(script_path, edited_script)
end

local function escape(str)
	return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

edit_script("data/scripts/items/broken_wand_spells.lua", function(script)
	return string.gsub(script, escape("local spell = spells[Random(1, #spells)]"), [[
spells = {}

function table.has_value(tab, val)
	for index, value in ipairs(tab) do
		if value == val then return true end
	end

	return false
end

dofile_once("data/scripts/gun/gun_actions.lua")

for k, data in pairs(actions) do
	if data.related_projectiles ~= nil then
		if data.pandorium_ignore then goto continue end
		if data.tm_trainer and Randomf() >= (ModSettingGet("cpand_tmtrainer_chance") or 0) then goto continue end
		for k2, v in pairs(data.related_projectiles) do
			if(ModDoesFileExist(v))then
				if table.has_value(spells, v) == false then table.insert(spells, v) end
			end
		end
	end
	::continue::
end

local spell = spells[Random(1, #spells)]
]])
end)

