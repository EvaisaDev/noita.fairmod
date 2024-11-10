--dofile_once("mods/conjurer/files/scripts/utilities.lua")

--all carrot-related code has been absolutely ripped and shamelessely stolen from Mortti's Conjurer Mod

local players = EntityGetWithTag( "player_unit" )
if players == nil then return false end


local function has_clicked_m1()
  local control_comp = EntityGetFirstComponentIncludingDisabled(players[1], "ControlsComponent")
  if control_comp == nil then return false end

  local click_frame = ComponentGetValue2(control_comp, "mButtonFrameFire")

  return click_frame == GameGetFrameNum()
end

local function is_holding_m2()
  local control_comp = EntityGetFirstComponentIncludingDisabled(players[1], "ControlsComponent")
  if control_comp == nil then return false end

  return ComponentGetValue2( control_comp, "mButtonDownRightClick")
end

if has_clicked_m1() or is_holding_m2() then
  local x, y = DEBUG_GetMouseWorld()

  EntitySetTransform(players[1], x, y)

  -- 1. Make the arrival less janky when teleporting in-air.
  --
  -- 2. If the Eye of Conjurer is active while we give the player some velocity
  -- it'll make the player float off helpless, so we disable it in that case.
  local dataComp = EntityGetFirstComponent(players[1], "CharacterDataComponent")
  if dataComp == nil then return end
  local xvel, yvel = ComponentGetValue2(dataComp, "mVelocity")
  ComponentSetValue2(dataComp, "mVelocity", xvel, -65)
end