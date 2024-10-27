-- This is where he dances and generates smoke
dofile_once("data/scripts/lib/utilities.lua")

gui = gui or GuiCreate()
GuiStartFrame(gui)
GuiOptionsAdd(gui, GUI_OPTION.NonInteractive)

local max_frames = 24
local frame = GetValueNumber("frame", 1)
frame = (frame % max_frames) + 0.25
SetValueNumber("frame", frame)
local scale = 0.5
local image_width, image_height = 105 * scale, 224 * scale
local screen_width, screen_height = GuiGetScreenDimensions(gui)
local virtual_width = MagicNumbersGetValue("VIRTUAL_RESOLUTION_X")
local virtual_height = MagicNumbersGetValue("VIRTUAL_RESOLUTION_Y")
local image = ("mods/noita.fairmod/files/content/smokedogg/frames/frame_%.2d.png"):format(math.ceil(frame))
local x = (math.cos(GameGetFrameNum() / 70) + 1) / 2 * (screen_width - image_width)
local y = screen_height - image_height
GuiImage(gui, 2, x, y, image, 1, 0.5, 0.5)
local cx, cy = GameGetCameraBounds()
local ratio_x = screen_width / virtual_width
local ent_x, ent_y = cx + (x / ratio_x) + image_width / 2, cy + y - image_height + 40
local entity_id = GetUpdatedEntityID()
SetRandomSeed(entity_id + GameGetFrameNum(), ent_x + ent_y)
local random_angle = Randomf(0, math.pi * 2)
local random_distance = Randomf(0, 10)
GameCreateParticle("fairmod_magic_gas_smokedoggium",
  ent_x + math.cos(random_angle) * random_distance,
  ent_y + math.sin(random_angle) * random_distance,
  20, 20, 20, false, false, true)
EntitySetTransform(entity_id, ent_x, ent_y)
