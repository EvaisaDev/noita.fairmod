local CYCLE_SECONDS = 3
local MAX_THROW = 1.5

local ent = GetUpdatedEntityID()
local inv = EntityGetFirstComponentIncludingDisabled(ent, "Inventory2Component")
if not inv then return end

local item = ComponentGetValue2(inv, "mActiveItem")
if not EntityGetIsAlive(item) then return end

local throw_comp = EntityGetFirstComponentIncludingDisabled(item, "PhysicsThrowableComponent")
if not throw_comp then return end

local t = GameGetFrameNum() / 60
local _, rem = math.modf(t / CYCLE_SECONDS)
local power = math.abs(math.sqrt(rem) - 0.5) * 2
ComponentSetValue2(throw_comp, "throw_force_coeff", power * MAX_THROW)
