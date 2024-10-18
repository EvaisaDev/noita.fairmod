dofile_once("data/scripts/lib/utilities.lua")

entity = GetUpdatedEntityID()

pos_x, pos_y = GameGetCameraPos()

EntitySetTransform(entity, pos_x, pos_y)
