local _OnBiomeConfigLoaded = OnBiomeConfigLoaded
local _BiomeSetValue = BiomeSetValue
local _SetRandomSeed = SetRandomSeed
local _apply_modifier_if_has_none = apply_modifier_if_has_none
local stupidity = 5
function SetRandomSeed(...)
	local args = { ... }
	SetRandomSeed(args[1] + stupidity * stupidity, args[2] - stupidity)
end
function apply_modifier_if_has_none(...)
	stupidity = stupidity + 1
	_apply_modifier_if_has_none(...)
end
function OnBiomeConfigLoaded(...)
	while stupidity > 0 do
		print("being stupid")
		_OnBiomeConfigLoaded(...)
	end
end
function BiomeSetValue(...)
	local thing = ({ ... })[2]
	if thing == "mModifierUIDecorationFile" then
		stupidity = stupidity - 1
	end
	_BiomeSetValue(...)
end
