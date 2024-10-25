dofile_once("mods/noita.fairmod/files/content/fishing/files/eva_utils.lua")
dofile_once("mods/noita.fairmod/files/content/fishing/files/fish_utils.lua")
dofile_once("data/scripts/lib/utilities.lua")

inheritor = GetUpdatedEntityID()

offset_x = EntityGetVariable(inheritor, "offset_x", "int") or 0
offset_y = EntityGetVariable(inheritor, "offset_y", "int") or 0

parent = EntityGetParent(inheritor)
parent_x, parent_y = EntityGetTransform(parent)

--GamePrint(offset_y)

EntityApplyTransform(inheritor, parent_x + offset_x, parent_y + offset_y)
