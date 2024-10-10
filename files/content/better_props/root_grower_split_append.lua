
local pos_x, pos_y = EntityGetTransform(GetUpdatedEntityID())
pos_x = pos_x + Random(0, 1)*2 - 1
pos_y = pos_y + Random(0, 1)*2 - 1

local r = ProceduralRandomf(pos_x, pos_y + GameGetFrameNum())
if r < 0.1 then
  local x = pos_x + ProceduralRandomf(pos_x-12, pos_y, -3, 3)
  local y = pos_y + ProceduralRandomf(pos_x, pos_y+54, -3, 3)
  EntityLoad( "data/entities/props/root_grower.xml", x, y )
elseif r < 0.9 then
  local x = pos_x + ProceduralRandomf(pos_x-7, pos_y, -3, 3)
  local y = pos_y + ProceduralRandomf(pos_x, pos_y, -3, 3)
  EntityLoad( "data/entities/props/root_grower_branch.xml", x, y )
end
