--[[
Custom coroutines.lua made by Horscht, inspired by Zatherz

-- TODO: Make asyncs pause- and resumeable from outside?

Changelog:
v0.1.0:
- First release
- "Signal" based functions are unimplemented
- Errors in async functions will not get swallowed but reported in the logger correctly
- Coroutines can be stopped (kills the coroutine) and restarted
]]

local current_time = 0

local last_id = 0

local coroutines_by_id = {}
local ids_by_coroutine = {}

local coroutine_lists_by_signal = {}

local waiting_coroutines = {}

local function resume_unprot(c)
  if coroutine.status(c) == "suspended" then
    waiting_coroutines[c] = nil
    local ok, err = coroutine.resume(c)
    if not ok then
      local id = ids_by_coroutine[c]
      error("In coroutine with ID " .. tostring(id) .. ": " .. tostring(err), 2)
    end
  end
end

local function alloc_id(co)
  last_id = last_id + 1
  
  while coroutines_by_id[last_id] ~= nil do
    last_id = last_id + 1
  end
  
  return last_id
end

local function get_coroutine(id)
  local c = coroutines_by_id[id]
  if not c then error("coroutine with ID " .. tostring(id) .. " doesn't exist, or has completed its execution") end
  return c
end

function async(f)
  local c = coroutine.create(f)

  local id = alloc_id(c)
  coroutines_by_id[id] = c
  ids_by_coroutine[c] = id

  resume_unprot(c)

  return {
    stop = function()
      -- waiting_coroutines = {}
      waiting_coroutines[c] = nil
      coroutines_by_id[id] = nil
      ids_by_coroutine[c] = nil
      -- coroutine.yield()
    end,
    restart = function()
      waiting_coroutines[c] = nil
      c = coroutine.create(f)
      coroutines_by_id[id] = c
      ids_by_coroutine[c] = id
      resume_unprot(c)
      -- coroutine.yield()
    end,
    resume = function()
      resume_unprot(c)
    end
  }
end

local async = async
function async_loop(f)
  return async(function()
    while true do
      f()
    end
  end)
end

function wait(frames, id)
  local c = id and get_coroutine(id) or coroutine.running()
  -- if not c then error("cannot wait in the main thread") end
  if ids_by_coroutine[c] then
    waiting_coroutines[c] = current_time + (frames or 0)
  end
  coroutine.yield()
end

function wake_up_waiting_threads(frames_delta)
  -- Only call this function once per frame per lua context
  if last_frame_woken == GameGetFrameNum() then return end
  last_frame_woken = GameGetFrameNum()
  current_time = current_time + frames_delta
  
  for c, target_time in pairs(waiting_coroutines) do
    if target_time < current_time then
      resume_unprot(c)
    end
  end
end
