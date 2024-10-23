dofile_once("data/scripts/lib/utilities.lua")

local entity = GetUpdatedEntityID()

local root = EntityGetParent( entity)

if(root == entity)then return end


local component = EntityGetFirstComponent(root, "CharacterDataComponent")
if not component then return end
local vel_x, vel_y = ComponentGetValue2(component, "mVelocity") or 0, 0

local multiplier = 10
vel_y = vel_y + multiplier

ComponentSetValue2(component, "mVelocity", vel_x, vel_y)