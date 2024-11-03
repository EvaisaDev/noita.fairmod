local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

--local lifetime = EntityGetFirstComponent(entity_id, "LifetimeComponent")
--if lifetime == nil then return end
--if GameGetFrameNum() < ComponentGetValue2(lifetime, "kill_frame") then
--	return
--end

--local frame = tostring(GameGetFrameNum())
--GamePrint(frame .. " LOAD " .. tostring(x))
--print_error(frame .. " LOAD " .. tostring(x))

---@param a number
---@param b number
---@return number
local function random(a, b)
	return ProceduralRandomi(x + entity_id, y + GameGetFrameNum(), a, b)
end


local num_corpses = #(EntityGetInRadiusWithTag(x, y, 512, "corpse_loader") or {})

-- Find a decent spot to place the corpse on the ground
local y_offset = random(5,20)
x, y = FindFreePositionForBody(x, y - y_offset, 0, 0, 20)

-- Load the ragdoll, choose depending on how many other corpses nearby
local scale_x = random(0, 1) * 2 - 1
if num_corpses > 40 then
	local n = random(1, 10)
	LoadRagdoll("mods/noita.fairmod/files/content/corpses/ragdolls/performance_corpse_" .. n .. ".txt", x, y, "meat", scale_x)
elseif num_corpses > 20 then
	local n = random(1, 3)
	LoadRagdoll("mods/noita.fairmod/files/content/corpses/ragdolls/rotten_corpse_" .. n .. ".txt", x, y, "meat", scale_x)
else
	local n = random(1, 3)
	LoadRagdoll("mods/noita.fairmod/files/content/corpses/ragdolls/stale_corpse_" .. n .. ".txt", x, y, "meat", scale_x)
end

-- Add just a bit of blood for effect
GameCreateParticle("blood", x, y, random(10, 30), 0, 0, false)


EntityKill(entity_id)
