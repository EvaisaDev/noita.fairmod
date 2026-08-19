local entity = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity)

---@return number
local function get_ingame_time()
	local wse = GameGetWorldStateEntity()
	local wsc = EntityGetFirstComponent(wse, "WorldStateComponent")
	if wsc == nil then return 0 end
	local time_fraction = ComponentGetValue2(wsc, "time")
	return time_fraction * (24 * 60)
end

---@return boolean
local function IsDay()
	local time = get_ingame_time()
	return time < 600 or time > 1020
end

if GameGetSkyVisibility(x, y) > 0.9 and IsDay() then
	GetGameEffectLoadTo(entity, "ON_FIRE", false)
	EntityInflictDamage(entity, 0.01, "DAMAGE_CURSE", "Vampire in sunlight", "NONE", 0, 0)
end
