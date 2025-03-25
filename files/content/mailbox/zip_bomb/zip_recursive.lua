frames = frames or 0

if(frames < 30)then
	frames = frames + 1
	return
elseif(frames == 30)then
	frames = 0
end

if(Random(1, 100) > 10)then
	return
end

local entity = GetUpdatedEntityID()

local x, y, r = EntityGetTransform(entity)
local zip = EntityLoad("mods/noita.fairmod/files/content/mailbox/zip_bomb/zip_recursive.xml", x, y)

local velocity_comp = EntityGetFirstComponentIncludingDisabled(zip, "VelocityComponent")
if(velocity_comp)then
	local vel_x = math.random(-200, 200)
	local vel_y = -200
	ComponentSetValue2(velocity_comp, "mVelocity", vel_x, vel_y)
end

ModSettingSet("noita.fairmod.popups", (ModSettingGet("noita.fairmod.popups") or "") .. "idiot,")