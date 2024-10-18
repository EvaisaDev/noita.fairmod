dofile("mods/noita.fairmod/files/content/fishing/files/eva_utils.lua")

local current_id = 0

function NextID()
	current_id = current_id + 1
	return current_id
end

function hex2argb(hex)
	local n = tonumber(hex, 16)
	return bit.band(bit.rshift(n, 24), 0xFF)/255, bit.band(bit.rshift(n, 16), 0xFF)/255, bit.band(bit.rshift(n, 8), 0xFF)/255, bit.band(n, 0xFF)/255
end

function AutoBox(gui, autobox_id, x, y, elem1, elem2, elem3)
	local callback = function() end
	local sprite_filename = type(elem1) == "string" and elem1 or "data/ui_gfx/decorations/9piece0_gray.png"
	local sprite_highlight_filename = type(elem2) == "string" and elem2 or "data/ui_gfx/decorations/9piece0_gray.png"
	if(type(elem1) == "function") then
		callback = elem1
	end
	if(type(elem2) == "function") then
		callback = elem2
	end
	if(type(elem3) == "function") then
		callback = elem3
	end

	local width = 0
	local height = 0

	local GuiTextOld = GuiText
	GuiText = function( gui, x, y, text )
		GuiTextOld( gui, x, y, text )
		local clicked, right_clicked, hovered, x, y, width2, height2, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo( gui )
		width = width + width2
		height = height + height2
	end

	local GuiTextCenteredOld = GuiTextCentered
	GuiTextCentered = function( gui, x, y, text )
		GuiTextCenteredOld( gui, x, y, text )
		local clicked, right_clicked, hovered, x, y, width2, height2, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo( gui )
		width = width + width2
		height = height + height2
	end

	local GuiImageOld = GuiImage
	GuiImage = function( gui, id, x, y, sprite_filename, alpha, scale, scale_y, rotation, rect_animation_playback_type, rect_animation_name )
		GuiImageOld( gui, id, x, y, sprite_filename, alpha, scale, scale_y, rotation, rect_animation_playback_type, rect_animation_name )
		local clicked, right_clicked, hovered, x, y, width2, height2, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo( gui )
		width = width + width2
		height = height + height2
	end

	local GuiImageNinePieceOld = GuiImageNinePiece
	GuiImageNinePiece = function( gui, id, x, y, width, height, alpha, sprite_filename, sprite_highlight_filename )
		GuiImageNinePieceOld( gui, id, x, y, width, height, alpha, sprite_filename, sprite_highlight_filename )
		local clicked, right_clicked, hovered, x, y, width2, height2, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo( gui )
		width = width + width2
		height = height + height2
	end

	local GuiButtonOld = GuiButton
	GuiButton = function( gui, id, x, y, text )
		GuiButtonOld( gui, id, x, y, text )
		local clicked, right_clicked, hovered, x, y, width2, height2, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo( gui )
		width = width + width2
		height = height + height2
	end

	local GuiImageButtonOld = GuiImageButton
	GuiImageButton = function( gui, id, x, y, text, sprite_filename )
		GuiImageButtonOld( gui, id, x, y, text, sprite_filename )
		local clicked, right_clicked, hovered, x, y, width2, height2, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo( gui )
		width = width + width2
		height = height + height2
	end

	local GuiSliderOld = GuiSlider
	GuiSlider = function( gui, id, x, y, text, value, value_min, value_max, value_default, value_display_multiplier, value_formatting, width )
		GuiSliderOld( gui, id, x, y, text, value, value_min, value_max, value_default, value_display_multiplier, value_formatting, width )
		local clicked, right_clicked, hovered, x, y, width2, height2, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo( gui )
		width = width + width2
		height = height + height2
	end

	local GuiTextInputOld = GuiTextInput
	GuiTextInput = function( gui, id, x, y, text, width, max_length, allowed_characters )
		GuiTextInputOld( gui, id, x, y, text, width, max_length, allowed_characters )
		local clicked, right_clicked, hovered, x, y, width2, height2, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo( gui )
		width = width + width2
		height = height + height2
	end

	local GuiEndAutoBoxNinePieceOld = GuiEndAutoBoxNinePiece
	GuiEndAutoBoxNinePiece = function( gui, margin, size_min_x, size_min_y, mirrorize_over_x_axis, x_axis, sprite_filename, sprite_highlight_filename )
		GuiEndAutoBoxNinePieceOld( gui, margin, size_min_x, size_min_y, mirrorize_over_x_axis, x_axis, sprite_filename, sprite_highlight_filename )
		local clicked, right_clicked, hovered, x, y, width2, height2, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo( gui )
		width = width + width2
		height = height + height2
	end

	local GuiBeginScrollContainerOld = GuiBeginScrollContainer
	GuiBeginScrollContainer = function( gui, id, x, y, width, height, scrollbar_gamepad_focusable, margin_x, margin_y )
		GuiBeginScrollContainerOld( gui, id, x, y, width, height, scrollbar_gamepad_focusable, margin_x, margin_y )
		local clicked, right_clicked, hovered, x, y, width2, height2, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo( gui )
		width = width + width2
		height = height + height2
	end

	local GuiEndScrollContainerOld = GuiEndScrollContainer
	GuiEndScrollContainer = function( gui )
		GuiEndScrollContainerOld( gui )
		local clicked, right_clicked, hovered, x, y, width2, height2, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo( gui )
		width = width + width2
		height = height + height2
	end

	callback()

	GamePrint("width: " .. tostring(width) .. " height: " .. tostring(height))

	GuiImageNinePiece( gui, autobox_id, x, y, width, height, 1, sprite_filename, sprite_highlight_filename )

	GuiText = GuiTextOld
	GuiTextCentered = GuiTextCenteredOld
	GuiImage = GuiImageOld
	GuiImageNinePiece = GuiImageNinePieceOld
	GuiButton = GuiButtonOld
	GuiImageButton = GuiImageButtonOld
	GuiSlider = GuiSliderOld
	GuiTextInput = GuiTextInputOld
	GuiEndAutoBoxNinePiece = GuiEndAutoBoxNinePieceOld
	GuiBeginScrollContainer = GuiBeginScrollContainerOld
	GuiEndScrollContainer = GuiEndScrollContainerOld
end

function Horizontal(gui, x, y, ui_scale, callback)
	GuiLayoutBeginHorizontal(gui, x, y, ui_scale)
	  callback()
	GuiLayoutEnd(gui)
end


function Vertical(gui, x, y, ui_scale, callback)
	GuiLayoutBeginVertical(gui, x, y, ui_scale)
		callback()
	GuiLayoutEnd(gui)
end


function HorizontalSpacing(gui, amount)
	GuiLayoutAddHorizontalSpacing(gui, amount)
end


function VerticalSpacing(gui, amount)
	GuiLayoutAddVerticalSpacing(gui, amount)
end
  
function Grid(gui, vars, callback)
	local items = vars.items or {}
	local x = vars.x or 0
	local y = vars.y or 0

	local offset_x = vars.offset_x or 0

	local ui_scale = vars.ui_Scale or false
  
	local auto_size = math.max(6, math.min((#items) ^ 0.75, 12))
	local row_length = math.ceil(vars.size or auto_size);
	local row_count = math.ceil(#items / row_length)
  
	local item_pos = 1
	for row=0, row_count-1 do
	  if not items[item_pos] then break end
  
	  local y_reverse = vars.reverse and row*10 or 0
  
	  Horizontal(gui, x, y-y_reverse, ui_scale, function()
		for col = 1, row_length do
			if not items[item_pos] then break end
			Horizontal(gui, offset_x * (col - 1), 0, ui_scale, function()
				callback(items[item_pos], item_pos)
				item_pos = item_pos + 1
		
				if vars.padding_x then
					HorizontalSpacing(gui, vars.padding_x)
				end
			end)
		end
	  end)
  
	  if vars.padding_y then
		VerticalSpacing(gui, vars.padding_y)
	  end
	end
end

local UTF8ToCharArray = function(str)
    local charArray = {};
    local iStart = 0;
    local strLen = str:len();
    
    local function bit(b)
        return 2 ^ (b - 1);
    end
 
    local function hasbit(w, b)
        return w % (b + b) >= b;
    end
    
    local checkMultiByte = function(i)
        if (iStart ~= 0) then
            charArray[#charArray + 1] = str:sub(iStart, i - 1);
            iStart = 0;
        end        
    end
    
    for i = 1, strLen do
        local b = str:byte(i);
        local multiStart = hasbit(b, bit(7)) and hasbit(b, bit(8));
        local multiTrail = not hasbit(b, bit(7)) and hasbit(b, bit(8));
 
        if (multiStart) then
            checkMultiByte(i);
            iStart = i;
            
        elseif (not multiTrail) then
            checkMultiByte(i);
            charArray[#charArray + 1] = str:sub(i, i);
        end
    end
    
    -- process if last character is multi-byte
    checkMultiByte(strLen + 1);
 
    return charArray;
end

local allowed_characters = "aäbcdeëfghiïjklmnopqrstuvwxyz1234567890."
local conversion = {
	["ä"] = "a2",
	["ë"] = "e2",
	["ï"] = "i2",
}

function DrawText(gui, font, x, y, scale, z_index, in_string, color, margin_x, margin_y)
	in_string = string.lower(in_string)
	margin_x = margin_x or 0
	margin_y = margin_y or 0

	GuiLayoutBeginVertical( gui, x, y, true, margin_x, margin_y )
	for line in in_string:gmatch("[^\r\n]+") do
		GuiLayoutBeginHorizontal( gui, 0, 0, true, margin_x, margin_y )
		for _, c in ipairs(UTF8ToCharArray(line)) do
			local letter = "unknown"
			if(c ~= " " and c ~= "?")then
				for _, c2 in ipairs(UTF8ToCharArray(allowed_characters)) do
					
					if(c2 == c)then
						letter = c
					end
				end
			elseif(c == " ")then
			
				letter = "space"

			elseif(c == "?")then
				letter = "question"
			end

			if(conversion[c] ~= nil)then
				letter = conversion[c]
			end

			local a, r, g, b = hex2argb(color)

			GuiColorSetForNextWidget( gui, r, g, b, a )
			GuiZSetForNextWidget(gui, z_index)
			GuiImage( gui, NextID(), 0, 0, font.."/"..letter..".png", a, scale, 0, 0)

		end
		GuiLayoutEnd( gui )
	end
	GuiLayoutEnd( gui )
end

function TextSize(gui, font, x, y, scale, z_index, in_string, margin)
	local line = string.lower(in_string)
	local width = 0
	local height = 0
	margin = margin or 0
	for _, c in ipairs(UTF8ToCharArray(line)) do

		local letter = "unknown"
		if(c ~= " " and c ~= "?")then
			for _, c2 in ipairs(UTF8ToCharArray(allowed_characters)) do
				
				if(c2 == c)then
					letter = c
				end
			end
		elseif(c == " ")then
		
			letter = "space"

		elseif(c == "?")then
			letter = "question"
		end

		if(conversion[c] ~= nil)then
			letter = conversion[c]
		end

		local w2, h2 = GuiGetImageDimensions( gui, font.."/"..letter..".png", scale )

		height = h2

		width = width + margin + GuiGetImageDimensions( gui, font.."/"..letter..".png", scale )

	end
	return width, height
end