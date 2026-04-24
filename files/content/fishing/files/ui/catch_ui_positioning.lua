dofile_once("data/scripts/lib/utilities.lua")

local entity = GetUpdatedEntityID()

local pos_x, pos_y = GameGetCameraPos()

EntitySetTransform(entity, pos_x, pos_y)
