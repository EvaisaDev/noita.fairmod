
local pos_x, pos_y = EntityGetTransform(GetUpdatedEntityID())

if ProceduralRandomf(pos_x, pos_y) < 0.9 then
  local x = pos_x + ProceduralRandomf(pos_x-7, pos_y, -3, 3)
  local y = pos_y + ProceduralRandomf(pos_x, pos_y, -3, 3)
  EntityLoad( "data/entities/props/root_grower_branch.xml", x, y )
end
