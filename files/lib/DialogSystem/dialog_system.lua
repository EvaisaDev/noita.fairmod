-- DialogSystem v0.1.0
-- Made by Horscht https://github.com/TheHorscht

dofile_once("data/scripts/lib/utilities.lua")
dofile_once("%PATH%coroutines.lua")
local Color = dofile_once("%PATH%color.lua")

local line_height = 10

local func_cache = setmetatable({}, { __mode = "k" })
-- Calls the provided function only once every N frames, otherwise returns the cached result
local function throttle(func, n, ...)
  if not func_cache[func] then
    func_cache[func] = {
      frame_called_at = GameGetFrameNum(),
      result = func(...)
    }
  else
    if GameGetFrameNum() > func_cache[func].frame_called_at + n then
      func_cache[func].frame_called_at = GameGetFrameNum()
      func_cache[func].result = func(...)
    end
  end
  return func_cache[func].result
end

local stats = setmetatable({}, {
  __index = function(self, prop)
    local getters = {
      gold = function()
        local player = EntityGetWithTag("player_unit")[1]
        if player then
          local wallet_component = EntityGetFirstComponentIncludingDisabled(player, "WalletComponent")
          return ComponentGetValue2(wallet_component, "money")
        end
      end,
      hp = function()
        local player = EntityGetWithTag("player_unit")[1]
        if player then
          local damage_model_component = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
          return ComponentGetValue2(damage_model_component, "hp") * 25
        end
      end,
      max_hp = function()
        local player = EntityGetWithTag("player_unit")[1]
        if player then
          local damage_model_component = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
          return ComponentGetValue2(damage_model_component, "max_hp") * 25
        end
      end,
    }
    return getters[prop] and getters[prop]()
  end
})

local dialog_system = {
  images = {},
  sounds = {
    default = { bank = "data/audio/Desktop/ui.bank", event = "ui/button_select" },
    sans = { bank = "%PATH%audio/dialog_system.bank", event = "talking_sounds/sans" },
    one = { bank = "%PATH%audio/dialog_system.bank", event = "talking_sounds/one" },
    two = { bank = "%PATH%audio/dialog_system.bank", event = "talking_sounds/two" },
    three = { bank = "%PATH%audio/dialog_system.bank", event = "talking_sounds/three" },
    four = { bank = "%PATH%audio/dialog_system.bank", event = "talking_sounds/four" },
  },
  dialog_box_y = 50, -- Optional
  dialog_box_width = 300,
  dialog_box_height = 70,
  distance_to_close = 15,
}

-- DEBUG_SKIP_ANIMATIONS = true

gui = GuiCreate()

local routines = {}

local is_open = false
local is_text_writing = false
local skip_dialogue = false
dialog_system.open_dialog = function(message)
  if is_open and not is_text_writing then
    return
  end
  if is_text_writing then
    skip_dialogue = true
    -- To resume in case of the pause command
    routines.logic.resume()
    return
  else
    skip_dialogue = false
    is_open = true
  end
  -- Remove whitespace before and after every line
  message.text = message.text:gsub("^%s*", ""):gsub("\n%s*", "\n"):gsub("%s*(?:\n)", "")

  local entity_id = GetUpdatedEntityID()
  local x, y = EntityGetTransform(entity_id)

  local dialog = {
    transition_state = 0,
    fade_in_portrait = -1,
    message = message,
    lines = {{}},
    opened_at_position = { x = x, y = y },
  }
  dialog.current_line = dialog.lines[1]
  dialog.show = function(message)
    skip_dialogue = false
    local previous_message_name = dialog.message.name
    local previous_message_animation = dialog.message.animation
    local previous_message_portrait = dialog.message.portrait
    local previous_message_typing_sound = dialog.message.typing_sound
    message.parent = dialog.message
    dialog.message = message
    dialog.message.name = message.name or previous_message_name
    dialog.message.portrait = message.portrait or previous_message_portrait
    dialog.message.animation = message.animation or previous_message_animation
    dialog.message.typing_sound = message.typing_sound or previous_message_typing_sound
    dialog.lines = {{}}
    dialog.current_line = dialog.lines[1]
    dialog.show_options = false
    routines.logic.restart()
  end
  dialog.back = function()
    if dialog.message.parent then
      dialog.message = dialog.message.parent
      dialog.lines = {{}}
      dialog.current_line = dialog.lines[1]
      dialog.show_options = false
      routines.logic.restart()
    else
      error("Dialog can't go any further back", 2)
    end
  end

  -- Returns a boolean indicating whether the player is too far from the position the dialog was opened at
  dialog.is_too_far = function()
    local player = EntityGetWithTag("player_unit")[1]
    if not player then
      return true
    end
    local px, py = EntityGetTransform(player)
    local function get_distance( x1, y1, x2, y2 )
      local result = math.sqrt( ( x2 - x1 ) ^ 2 + ( y2 - y1 ) ^ 2 )
      return result
    end
    
    return get_distance(dialog.opened_at_position.x, dialog.opened_at_position.y, px, py) > dialog_system.distance_to_close
  end

  dialog.close = function()
    if dialog.closing then return end
    if routines.logic then
      routines.logic.stop()
    end
    dialog.closing = true
    dialog.lines = {{}}
    dialog.current_line = dialog.lines[1]
    dialog.show_options = false
    async(function()
      while dialog.fade_in_portrait > -1 do
        dialog.fade_in_portrait = dialog.fade_in_portrait - 1
        wait(0)
      end
      while dialog.transition_state > 0 do
        dialog.transition_state = dialog.transition_state - (2 / 32)
        wait(0)
      end
      is_open = false
    end)
  end

  -- "Kill" currently running routines
  for k, v in pairs(routines) do
    v.stop()
    routines[v] = nil
  end

  -- Render the GUI
  routines.gui = async(function()
    while is_open do
      if dialog.is_too_far() then
        dialog.close()
      end
      GuiStartFrame(gui)
      local screen_width, screen_height = GuiGetScreenDimensions(gui)
      local width = dialog.transition_state * dialog_system.dialog_box_width
      local height = dialog.transition_state * dialog_system.dialog_box_height
      local x, y = screen_width/2 - width/2, screen_height - height/2
      -- x and y are the center of the dialog box and will be used to draw text and portaits etc
      y = y - dialog_system.dialog_box_height / 2 + 3 - dialog_system.dialog_box_y
      x = x + 3
      GuiIdPushString(gui, "dialog_box")
      GuiZSetForNextWidget(gui, 2)
      GuiImageNinePiece(gui, 1, screen_width/2 - width/2, screen_height - dialog_system.dialog_box_y - dialog_system.dialog_box_height/2 - height/2, width, height)
      if dialog.fade_in_portrait > -1 then
        GuiZSetForNextWidget(gui, 1)
        GuiImage(gui, 2, x, y, dialog.message.portrait, 1, 1, 1, 0, GUI_RECT_ANIMATION_PLAYBACK.Loop, message.animation or "")
        GuiZSetForNextWidget(gui, 0)
        GuiImage(gui, 3, x, y, "%PATH%transition.xml", 1, 1, 1, 0, GUI_RECT_ANIMATION_PLAYBACK.PlayToEndAndPause, "anim_" .. tostring(dialog.fade_in_portrait))
        GuiZSetForNextWidget(gui, -1)
        GuiImage(gui, 4, x, y, "%PATH%border.png", 1, 1, 1, 0)
        -- -----------------
        -- Name plate with autobox
        -- -----------------
        -- GuiImageNinePiece(gui, 5, screen_width/2, screen_height - dialog_system.dialog_box_y - height - 40, 100, 40)
        -- GuiBeginAutoBox(gui)
        -- -- GuiEndAutoBoxNinePiece( gui:obj, margin:number = 5, size_min_x:number = 0, size_min_y:number = 0, mirrorize_over_x_axis:bool = false, x_axis:number = 0, sprite_filename:string = "data/ui_gfx/decorations/9piece0_gray.png", sprite_highlight_filename:string = "data/ui_gfx/decorations/9piece0_gray.png" )
        -- GuiText(gui, screen_width/2 - width/2 + 2, screen_height - dialog_system.dialog_box_y - height - 16, "Morshu")
        -- GuiZSetForNextWidget(gui, 1)
        -- GuiEndAutoBoxNinePiece(gui, 2)

        -- -----------------
        -- Name plate left side
        -- -----------------
        -- local name_width, name_height = GuiGetTextDimensions(gui, "Morshu")
        -- GuiZSetForNextWidget(gui, 2)
        -- GuiImageNinePiece(gui, 5, screen_width/2 - width/2, screen_height - dialog_system.dialog_box_y - height - 14, name_width + 7, name_height)
        -- GuiText(gui, screen_width/2 - width/2 + 4, screen_height - dialog_system.dialog_box_y - height - 14, "Morshu")

        -- -----------------
        -- Name plate left side
        -- -----------------
        if dialog.message.name and dialog.message.name ~= "" then
          local nameplate_padding = 2
          local nameplate_inner_width = 70
          local nameplate_height = 11
          local name_width, name_height = GuiGetTextDimensions(gui, dialog.message.name)
          GuiZSetForNextWidget(gui, 2)
          GuiImageNinePiece(gui, 5, screen_width/2 - width/2, screen_height - dialog_system.dialog_box_y - height - nameplate_height - 3, nameplate_inner_width, nameplate_height)
          local diff = nameplate_inner_width - name_width + nameplate_padding
          GuiText(gui, screen_width/2 - width/2 + diff/2, screen_height - dialog_system.dialog_box_y - height - nameplate_height/2 - name_height + nameplate_padding, dialog.message.name)
        end
      end
      -- Render text
      local y_offset = 0
      local char_i = 1
      for i, line in ipairs(dialog.lines) do
        GuiLayoutBeginHorizontal(gui, x + 72, y - 1, true)
        for i2, char_data in ipairs(line) do
          local wave_offset_y = 0
          local shake_offset = { x = 0, y = 0 }
          local r, g, b, a = unpack(char_data.color and char_data.color or { 1, 1, 1, 1 })
          local absolute_position = false

          if char_data.shake then
            shake_offset.x = (1 - math.random() * 2) * 0.7
            shake_offset.y = (1 - math.random() * 2) * 0.7
            -- Draw an invisible version of the text just so we can get the location where it would be drawn normally
            local x, y = 0, 0
            if char_data.img then
              GuiImage(gui, i2, -3, (i-1) * line_height + wave_offset_y, dialog_system.images[char_data.img], 0, 1, 1)
              _, _, _, x, y, _ ,_ , draw_x, draw_y = GuiGetPreviousWidgetInfo(gui)
              -- To shift the next thing that gets drawn 2 pixels left
              GuiText(gui, -2, 0, "")
            else
              GuiColorSetForNextWidget(gui, 1, 1, 1, 0.001) --  0 alpha doesn't work, is bug
              GuiText(gui, -2, y_offset + wave_offset_y, char_data.char)
              _, _, _, x, y, _ ,_ , draw_x, draw_y = GuiGetPreviousWidgetInfo(gui)
            end
            shake_offset.x = shake_offset.x + x
            shake_offset.y = shake_offset.y + y
            absolute_position = true
            GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NoLayouting)
          end
          if char_data.wave then
            local color = Color:new((char_i * 25 + GameGetFrameNum() * 5) % 360, 0.7, 0.6)
            r, g, b = color:get_rgb()
            wave_offset_y = math.sin(char_i * 0.5 + GameGetFrameNum() * 0.1) * 1
          end
          if char_data.blink then
            a = math.sin(GameGetFrameNum() * 0.2) *  0.3 + 0.7
          end
          if char_data.img then
            GuiColorSetForNextWidget(gui, r, g, b, a)
            GuiImage(gui, i2, (absolute_position and 0 or -3) + shake_offset.x, (absolute_position and 0 or y_offset) + wave_offset_y + shake_offset.y, dialog_system.images[char_data.img], a, 1, 1)
            if not absolute_position then
              GuiText(gui, -2, 0, "")
            end
          else
            GuiColorSetForNextWidget(gui, r, g, b, a)
            GuiText(gui, (absolute_position and 0 or -2) + shake_offset.x, (absolute_position and 0 or y_offset) + wave_offset_y + shake_offset.y, char_data.char)
          end
          char_i = char_i + 1
        end
        GuiLayoutEnd(gui)
        y_offset = y_offset + line_height
      end
      -- /Text
      -- Dialog options
      if dialog.show_options then
        if dialog.message.options then
          local num_options = #dialog.message.options
          for i, v in ipairs(dialog.message.options) do
            local enabled = v.enabled == nil or (type(v.enabled) == "function" and throttle(v.enabled, 30, stats)) or (type(v.enabled) ~= "function" and v.enabled)
            local text_x, text_y = x + 70, y + dialog_system.dialog_box_height - (num_options - i + 1) * line_height - 7
            if enabled then
              if GuiButton(gui, 5 + i, text_x, text_y, "[ " .. v.text .. " ]") then
                if v.func then
                  v.func(dialog)
                else
                  dialog.close()
                end
              end
            else
              GuiColorSetForNextWidget(gui, 0.4, 0.4, 0.4, 1.0)
              GuiText(gui, text_x, text_y, "[ " .. (v.text_disabled or v.text) .. " ]")
            end
          end
        else
          if GuiButton(gui, 6, x + 70, y + dialog_system.dialog_box_height - line_height - 7, "[ End ]") then
            dialog.close()
          end
        end
      end
      -- /Dialog options
      GuiIdPop(gui)
      wait(0)
    end
  end)

  -- Advance the state logic etc
  routines.logic = async(function()
    is_text_writing = false
    if DEBUG_SKIP_ANIMATIONS then
      dialog.transition_state = 1
      dialog.fade_in_portrait = 32
    end
    while dialog.transition_state < 1 do
      dialog.transition_state = dialog.transition_state + (2 / 32)
      wait(0)
    end
    dialog.transition_state = 1
    while dialog.fade_in_portrait < 32 do
      dialog.fade_in_portrait = dialog.fade_in_portrait + 1
      wait(1)
    end
    dialog.fade_in_portrait = 32

    local color = { 1, 1, 1, 1 }
    local wave, blink, shake = false, false, false
    local delay = 3
    local skip_char_count, chars_skipped = 0, 0
    local typing_sound = dialog.message.typing_sound
    local i = 1

    is_text_writing = true
    while i <= #dialog.message.text do
      local char = dialog.message.text:sub(i, i)
      local play_sound = false
      local do_wait = false
      if char == "\n" then
        table.insert(dialog.lines, {})
        dialog.current_line = dialog.lines[#dialog.lines]
      elseif char == "~" then
        wave = not wave
      elseif char == "*" then
        blink = not blink
      elseif char == "#" then
        shake = not shake
      elseif char == "{" then
        -- Look ahead 20 characters and get that substring
        local str = dialog.message.text:sub(i, i + 20)
        local command, param1 = string.gmatch(str, "@(%w+)%s+([^}]+)")()
        if command then
          if command == "delay" then
            delay = tonumber(param1)
            if delay < 0 then
              skip_char_count = math.abs(delay)
            end
          elseif command == "pause" and not skip_dialogue then
            wait(tonumber(param1)-1)
          elseif command == "color" then
            local rgb = tonumber(param1, 16)
            color[1] = bit.band(bit.rshift(rgb, 16), 0xFF) / 255
            color[2] = bit.band(bit.rshift(rgb, 8), 0xFF) / 255
            color[3] = bit.band(rgb, 0xFF) / 255
          elseif command == "img" then
            table.insert(dialog.current_line, { wave = wave, blink = blink, shake = shake, img = param1 })
            play_sound = true
            do_wait = true
          elseif command == "sound" then
            typing_sound = param1
          end
          i = i + string.find(str, "}") - 1
        else
          error(("Invalid command: %s"):format(command))
        end
      else
        local color_copy = {unpack(color)}
        table.insert(dialog.current_line, { char = char, wave = wave, blink = blink, shake = shake, color = color_copy })
        if char ~= " " then
          play_sound = true
        end
        do_wait = true
      end
      if typing_sound ~= "none" and play_sound and frame_last_played_sound ~= GameGetFrameNum() then
        frame_last_played_sound = GameGetFrameNum()
        local bank = dialog_system.sounds[typing_sound or "default"].bank
        local event = dialog_system.sounds[typing_sound or "default"].event
        GamePlaySound(bank, event, 0, 0)
      end
      if skip_dialogue then
        do_wait = false
      end
      if do_wait and (delay > 0 or chars_skipped >= skip_char_count) then
        wait(math.max(0, delay-1))
        chars_skipped = 0
      elseif do_wait then
        chars_skipped = chars_skipped + 1
      end
      i = i + 1
    end
    if not skip_dialogue then
      wait(15)
    end
    dialog.show_options = true
    is_text_writing = false
  end)

  return dialog
end

return dialog_system
