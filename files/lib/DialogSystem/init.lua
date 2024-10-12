local function inject_path(file, path)
  local content = ModTextFileGetContent(file)
  content = content:gsub("%%PATH%%", path)
  ModTextFileSetContent(file, content)
end

local function get_current_mod_id_and_path()
  local result, err = pcall(function() error(" ") end)
  local mod_id, path = err:match("string %\"mods/([^/]*)/(.*)/.*%.lua\"]")
  return mod_id, ("mods/%s/%s"):format(mod_id, path)
end

return function(lib_path, images)
  -- Play all sounds to prevent the bug which stops sounds from working if they
  -- haven't been played before starting a new game
  local root_path = lib_path:gsub("([^/])$","%1/") --  Add a slash at the end if it doesn't already exist
  ModRegisterAudioEventMappings(root_path .. "audio/GUIDs.txt")
  local sounds = { "sans", "one", "two", "three", "four" }
  for i, sound in ipairs(sounds) do
    GamePlaySound(root_path .. "audio/dialog_system.bank", sound, -999999, -999999)
  end
  inject_path(root_path .. "dialog_system.lua", root_path)
  inject_path(root_path .. "transition.xml", root_path)

  local image_inserts = ""
  for name, file_path in pairs(images or {}) do
    image_inserts = image_inserts .. name .. " = \"" .. file_path .. "\",\n"
  end
end
