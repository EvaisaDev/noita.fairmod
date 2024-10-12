local function inject_path(file, path)
  local content = ModTextFileGetContent(file)
  content = content:gsub("%%PATH%%", path)
  ModTextFileSetContent(file, content)
end

-- Doesn't work reliably, don't use this, it's just here because :)
local function get_current_mod_id_and_path()
  local result, err = pcall(function() error(" ") end)
  local mod_id, path = err:match("string %\"mods/([^/]*)/(.*)/.*%.lua\"]")
  return mod_id, ("mods/%s/%s"):format(mod_id, path)
end

local function serializeTable(val, name, skipnewlines, depth)
  skipnewlines = skipnewlines or false
  depth = depth or 0
  local tmp = string.rep(" ", depth)
  if name then tmp = tmp .. name .. " = " end
  if type(val) == "table" then
    tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")
    for k, v in pairs(val) do
      tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
    end
    tmp = tmp .. string.rep(" ", depth) .. "}"
  elseif type(val) == "number" then
    tmp = tmp .. tostring(val)
  elseif type(val) == "string" then
    tmp = tmp .. string.format("%q", val)
  elseif type(val) == "boolean" then
    tmp = tmp .. (val and "true" or "false")
  else
    tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
  end
  return tmp
end

return function(lib_path, global_config)
  local root_path = lib_path:gsub("([^/])$","%1/") --  Add a slash at the end if it doesn't already exist
  ModRegisterAudioEventMappings(root_path .. "audio/GUIDs.txt")
  -- Play all sounds to prevent the bug which stops sounds from working if they
  -- haven't been played before starting a new game
  local sounds = { "sans", "one", "two", "three", "four" }
  for i, sound in ipairs(sounds) do
    GamePlaySound(root_path .. "audio/dialog_system.bank", sound, -999999, -999999)
  end
  inject_path(root_path .. "dialog_system.lua", root_path)
  inject_path(root_path .. "transition.xml", root_path)

  ModTextFileSetContent(root_path .. "virtual/config.lua", "return " .. serializeTable(global_config, nil, false))
end
