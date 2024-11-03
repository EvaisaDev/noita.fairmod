local tnt = GetUpdatedEntityID()
local x, y = EntityGetTransform(tnt)

local proj = EntityGetFirstComponent(tnt, "ProjectileComponent")
if proj ~= nil then ComponentSetValue2(proj, "lifetime", ProceduralRandomi(x + tnt, y + GameGetFrameNum(), 10, 300)) end
