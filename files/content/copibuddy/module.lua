local module = {}

local ref = {
	was_active = false,
	spritesheet = "mods/noita.fairmod/files/content/copibuddy/sprites/copi.xml",
	animation = "idle",
	parsed_text = nil,
	target_text = nil,
	on_cooldown = true,
	event_cooldown = {60 * 5, 60 * 60}, -- 5 to 60 seconds
	current_progress = 0,
	total_length = 0,
	type_delay = 3,
	width = 64,
	height = 96,
	timer = 0,
	x = 0,
	y = 0,
	max_text_width = 200,
	event = nil,
	last_event = nil,
	gui = GuiCreate(),
	functions = {
		test = function()
			print("test")
		end
	}
}

local function reset()
	GameRemoveFlagRun("copibuddy_intro_done")
	for k, v in pairs(ref) do
		module[k] = v
	end
end

local content = dofile_once("mods/noita.fairmod/files/content/copibuddy/content.lua")

local function weighted_random(t)
	local weights = {}
	local total = 0
	for _, v in ipairs(t) do
		local weight = v.weight or 1
		if type(weight) == "function" then
			weight = weight(module)
		end

		weights[v] = weight

		total = total + weight
	end
	local r = Random(0, total)
	for _, v in ipairs(t) do
		local weight = weights[v]
		r = r - weight
		if r <= 0 then
			return v
		end
	end
end

local function merge_formatting(stack)
	local fmt = {}
	for _, f in ipairs(stack) do
		for k, v in pairs(f) do
			if k ~= "tag" then
				fmt[k] = v
			end
		end
	end
	return fmt
end

local function pretty_table(tbl, indent)
    indent = indent or 0
    local toprint = string.rep(" ", indent) .. "{\n"
    for k, v in pairs(tbl) do
        local key
        if type(k) == "string" then
            key = k
        else
            key = "[" .. tostring(k) .. "]"
        end
        toprint = toprint .. string.rep(" ", indent + 4) .. key .. " = "
        if type(v) == "table" then
            toprint = toprint .. pretty_table(v, indent + 4)
        elseif type(v) == "string" then
            toprint = toprint .. '"' .. v .. '"'
        else
            toprint = toprint .. tostring(v)
        end
        toprint = toprint .. ",\n"
    end
    toprint = toprint .. string.rep(" ", indent) .. "}"
    return toprint
end

local function parse_formatted_text(text)
	local segments = {}
	local pos = 1
	local stack = {}
	local seg_counter = 0 
	while pos <= #text do
		local tag_start = string.find(text, "%[", pos)
		if not tag_start then
			local plain = string.sub(text, pos)
			if plain ~= "" then
				seg_counter = seg_counter + 1
				table.insert(segments, { text = plain, format = merge_formatting(stack), seg_id = seg_counter })
			end
			break
		end
		if tag_start > pos then
			local plain = string.sub(text, pos, tag_start - 1)
			if plain ~= "" then
				seg_counter = seg_counter + 1
				table.insert(segments, { text = plain, format = merge_formatting(stack), seg_id = seg_counter })
			end
		end
		local tag_end = string.find(text, "%]", tag_start)
		if not tag_end then
			local plain = string.sub(text, tag_start)
			seg_counter = seg_counter + 1
			table.insert(segments, { text = plain, format = merge_formatting(stack), seg_id = seg_counter })
			break
		end
		local tag_content = string.sub(text, tag_start + 1, tag_end - 1)
		if tag_content:sub(1,1) == "/" then
			local closing_tag = tag_content:sub(2)
			if #stack > 0 then
				local top = stack[#stack]
				if top.tag == closing_tag then
					table.remove(stack)
				end
			end
			pos = tag_end + 1
		else
			local eq_pos = string.find(tag_content, "=")
			if eq_pos then
				local tag = string.sub(tag_content, 1, eq_pos - 1)
				local value = string.sub(tag_content, eq_pos + 1)
				local fmt = {}
				if tag == "color" then
					if #value == 6 then
						local r = tonumber(value:sub(1,2),16)/255
						local g = tonumber(value:sub(3,4),16)/255
						local b = tonumber(value:sub(5,6),16)/255
						fmt.color = { r, g, b, 1 }
					end
				elseif tag == "size" then
					fmt.size = tonumber(value)
				elseif tag == "on_click" then
					fmt.on_click = module.functions[value]
				elseif tag == "on_hover" then
					fmt.on_hover = module.functions[value]
				elseif tag == "on_right_click" then
					fmt.on_right_click = module.functions[value]
				end
				fmt.tag = tag
				table.insert(stack, fmt)
			end
			pos = tag_end + 1
		end
	end
	return segments
end

local function slice_parsed_segments(segments, count)
	local sliced = {}
	local remaining = count
	for _, seg in ipairs(segments) do
		local seg_length = #seg.text
		if remaining <= 0 then break end
		if seg_length <= remaining then
			table.insert(sliced, seg)
			remaining = remaining - seg_length
		else
			local new_seg = { text = string.sub(seg.text, 1, remaining), format = seg.format, seg_id = seg.seg_id }
			table.insert(sliced, new_seg)
			remaining = 0
		end
	end
	return sliced
end

local function wrap_segments(gui, segments, max_width)
	local lines = {}
	local current_line = {}
	local current_line_width = 0
	for _, seg in ipairs(segments) do
		local remaining = seg.text
		local seg_format = seg.format or {}
		local seg_size = seg_format.size or 1
		while #remaining > 0 do
			local newline_pos = string.find(remaining, "\n", 1, true)
			local part
			if newline_pos then
				part = string.sub(remaining, 1, newline_pos - 1)
				remaining = string.sub(remaining, newline_pos + 1)
			else
				part = remaining
				remaining = ""
			end
			for word in string.gmatch(part, "%S+") do
				local word_width, _ = GuiGetTextDimensions(gui, word)
				word_width = word_width * seg_size
				local space_width = 0
				if #current_line > 0 then
					space_width, _ = GuiGetTextDimensions(gui, " ")
					space_width = space_width * seg_size
				end
				if current_line_width + space_width + word_width > max_width and #current_line > 0 then
					table.insert(lines, current_line)
					current_line = {}
					current_line_width = 0
				end
				if #current_line > 0 then
					table.insert(current_line, { text = " ", format = {}, seg_id = seg.seg_id })
					current_line_width = current_line_width + space_width
				end
				table.insert(current_line, { text = word, format = seg_format, seg_id = seg.seg_id })
				current_line_width = current_line_width + word_width
			end
			if newline_pos then
				table.insert(lines, current_line)
				current_line = {}
				current_line_width = 0
			end
		end
	end
	if #current_line > 0 then
		table.insert(lines, current_line)
	end
	return lines
end

local function measure_lines(gui, lines)
	local total_width = 0
	local total_height = 0
	local line_heights = {}
	for _, line in ipairs(lines) do
		local line_width = 0
		local line_height = 0
		for _, seg in ipairs(line) do
			local seg_size = (seg.format and seg.format.size) or 1
			local w, h = GuiGetTextDimensions(gui, seg.text)
			w = w * seg_size
			h = h * seg_size
			line_width = line_width + w
			if h > line_height then
				line_height = h
			end
		end
		if line_width > total_width then
			total_width = line_width
		end
		total_height = total_height + line_height
		table.insert(line_heights, line_height)
	end
	return total_width, total_height, line_heights
end

local function render_wrapped_text(gui, new_id, x, y, lines, line_heights)
	local current_y = y
	for i, line in ipairs(lines) do
		local current_x = x
		for _, seg in ipairs(line) do
			local seg_size = (seg.format and seg.format.size) or 1
			GuiZSetForNextWidget(gui, -1000)
			local clicked, right_clicked
			GuiColorSetForNextWidget(gui, 1, 1, 1, 0)
			if (seg.format and (seg.format.on_click or seg.format.on_right_click)) then
				clicked, right_clicked = GuiButton(gui, new_id(), current_x, current_y, seg.text, seg_size, "data/fonts/font_pixel_noshadow.xml", true)
			else
				GuiText(gui, current_x, current_y, seg.text, seg_size, "data/fonts/font_pixel_noshadow.xml", true)
			end
			local _, _, hovered = GuiGetPreviousWidgetInfo(gui)
			
			local hoverable = seg.format and (seg.format.on_click or seg.format.on_hover or seg.format.on_right_click)

			local is_hovered = hoverable and (hovered or (seg.seg_id and module.prev_hover_ids and module.prev_hover_ids[seg.seg_id]))
			if hovered and seg.seg_id then
				module.current_hover_ids[seg.seg_id] = true
			end
			
			if seg.format and seg.format.color then
				local c = seg.format.color
				GuiColorSetForNextWidget(gui, c[1], c[2], c[3], c[4] or 1)
				if is_hovered then
					GuiColorSetForNextWidget(gui, math.min(c[1] + 0.5, 1), math.min(c[2] + 0.5, 1), math.min(c[3] + 0.5, 1), c[4] or 1)
				elseif clicked or right_clicked then
					GuiColorSetForNextWidget(gui, math.max(c[1] - 0.5, 0), math.max(c[2] - 0.5, 1), math.max(c[3] - 0.5, 1), c[4] or 1)
				end
			else
				if(hoverable)then
					GuiColorSetForNextWidget(gui, 0 / 255, 43 / 255, 150 / 255, 1)
				else
					GuiColorSetForNextWidget(gui, 0, 0, 0, 1)
				end

				if is_hovered then
					GuiColorSetForNextWidget(gui, 31 / 255, 87 / 255, 224 / 255, 1)
				elseif clicked or right_clicked then
					GuiColorSetForNextWidget(gui, 0 / 255, 29 / 255, 99 / 255, 1)
				end
			end
			
			GuiZSetForNextWidget(gui, -1001)
			GuiText(gui, current_x, current_y, seg.text, seg_size, "data/fonts/font_pixel_noshadow.xml", true)
	
			if clicked and seg.format and seg.format.on_click then
				seg.format.on_click(module)
			end
			if right_clicked and seg.format and seg.format.on_right_click then
				seg.format.on_right_click(module)
			end
			if hovered and seg.format and seg.format.on_hover then
				seg.format.on_hover(module)
			end
			local w, _ = GuiGetTextDimensions(gui, seg.text)
			current_x = current_x + w * seg_size
		end
		current_y = current_y + line_heights[i]
	end
end

reset()

local id = 1241
function module.new_id()
	id = id + 1
	return id
end

function module.update()
	if (GameHasFlagRun("reset_copibuddy")) then
		GameRemoveFlagRun("reset_copibuddy")
		reset()
	end
	if (not GameHasFlagRun("copibuddy")) then
		return
	elseif(not GameHasFlagRun("copibuddy_activated"))then
		GameAddFlagRun("copibuddy_activated")
		if(Random(0, 100) < 40)then
			-- 40% chance to happen next run aswell
			AddFlagPersistent("copibuddy_next_run")
			print("Copibuddy will repeat!")
		end
	end
	
	module.prev_hover_ids = module.current_hover_ids or {}
	module.current_hover_ids = {}
	
	id = 1241

	if(module.event and module.event.update)then
		module.event.update(module)
	end

	GuiStartFrame(module.gui)
	local screen_w, screen_h = GuiGetScreenDimensions(module.gui)
	if (not module.was_active) then
		module.animation = "fade_in"
		module.was_active = true
		module.timer = 60
		module.x = Random(0, screen_w - module.width)
		module.y = Random(0, screen_h - module.height)
	end

	local next_event = nil
	if(module.on_cooldown)then
		for _, event in ipairs(content) do
			if (event.force and (not event.condition or event.condition(module, event)) and (event ~= module.last_event)) then
				module.timer = 0
				next_event = event
				goto continue
			end
		end
	end

	::continue::

	if (module.timer > 0) then
		module.timer = module.timer - 1
		if (module.timer == 0) then

			if(module.event and module.event.post_func)then
				module.event.post_func(module)
			end

			module.animation = "idle"
			module.event = nil
			module.parsed_text = nil
			module.current_progress = nil
			module.total_length = nil
			if(not module.on_cooldown)then
				module.on_cooldown = true
				module.timer = Random(module.event_cooldown[1], module.event_cooldown[2])
			end
		end
	elseif (module.event == nil) then
		SetRandomSeed(GameGetFrameNum() + module.x, GameGetFrameNum() + module.y)
		local options = {}
		if(not next_event)then
			for _, event in ipairs(content) do
				if ((not event.condition or event.condition(module, event)) and (event ~= module.last_event)) then
					if(event.force)then
						options = {event}
						break
					end
					table.insert(options, event)
				end
			end
		end

		if (#options > 0 or next_event) then
			module.event = #options > 0 and weighted_random(options) or next_event


			if(module.event == nil)then
				return
			end

			--module.last_event = module.event

			if (module.event.func) then
				module.event.func(module)
			end
			if (module.event.anim and type(module.event.anim) == "function") then
				module.animation = module.event.anim(module)
			elseif (module.event.anim) then
				module.animation = module.event.anim
			else
				module.animation = "idle"
			end

			if (module.event.post_talk_anim and type(module.event.post_talk_anim) == "function") then
				module.post_talk_anim = module.event.post_talk_anim(module)
			elseif (module.event.post_talk_anim) then
				module.post_talk_anim = module.event.post_talk_anim
			else
				module.post_talk_anim = "idle"
			end
			
			if (module.event.audio and type(module.event.audio) == "function") then
				local audio = module.event.audio(module)
				if (audio) then
					GamePlaySound(audio[1], audio[2], 0, 0)
				end
			elseif (module.event.audio) then
				GamePlaySound(module.event.audio[1], module.event.audio[2], 0, 0)
			end
			local raw_text = nil
			if (module.event.text and type(module.event.text) == "function") then
				raw_text = module.event.text(module)
			elseif (module.event.text) then
				raw_text = module.event.text
			end


			module.functions = {}
			for k, v in pairs(ref.functions) do
				module.functions[k] = v
			end

			if (module.event.functions) then
				for k, v in pairs(module.event.functions) do
					module.functions[k] = v
				end
			end
			

			if raw_text then
				module.parsed_text = parse_formatted_text(raw_text)
				--print(pretty_table(module.parsed_text))
				module.total_length = 0
				for _, seg in ipairs(module.parsed_text) do
					module.total_length = module.total_length + #seg.text
				end
				module.current_progress = 0
			end

			module.type_delay = module.event.type_delay or 3
			module.timer = module.event.frames or 60

			module.on_cooldown = false
		end
	end

	if(module.target_text ~= nil)then

		module.parsed_text = parse_formatted_text(module.target_text)
		--print(pretty_table(module.parsed_text))
		module.total_length = 0
		for _, seg in ipairs(module.parsed_text) do
			module.total_length = module.total_length + #seg.text
		end
		module.current_progress = 0
		module.target_text = nil
	end


	if module.parsed_text and module.current_progress < module.total_length then
		module.type_delay = module.type_delay - 1
		if module.type_delay <= 0 then
			module.type_delay = module.event.type_delay or 3
			module.current_progress = module.current_progress + 1
			if module.current_progress > module.total_length then
				module.current_progress = module.total_length
			end

			if module.current_progress == module.total_length then
				module.animation = module.post_talk_anim
			end


			if (not module.event.frames) then
				module.timer = module.timer + module.type_delay
			end
		end
	end
	GuiZSetForNextWidget(module.gui, -998)
	GuiImage(module.gui, module.new_id(), module.x, module.y, module.spritesheet, 1, 1, 1, 0, 2, module.animation or "idle")
	if module.parsed_text then
		local visible_segments = slice_parsed_segments(module.parsed_text, module.current_progress)
		local margin = 5
		local edge_margin = 6
		local lines = wrap_segments(module.gui, visible_segments, module.max_text_width)
		local total_text_width, total_text_height, line_heights = measure_lines(module.gui, lines)

		margin = margin + edge_margin
		local bubble_x, bubble_y
		if (module.y - total_text_height - margin >= 0) then
			bubble_x = module.x + module.width / 2 - total_text_width / 2
			bubble_y = module.y - total_text_height - margin
		elseif (module.y + module.height + total_text_height + margin <= screen_h) then
			bubble_x = module.x + module.width / 2 - total_text_width / 2
			bubble_y = module.y + module.height + margin
		elseif (module.x - total_text_width - margin >= 0) then
			bubble_x = module.x - total_text_width - margin
			bubble_y = module.y + module.height / 2 - total_text_height / 2
		elseif (module.x + module.width + total_text_width + margin <= screen_w) then
			bubble_x = module.x + module.width + margin
			bubble_y = module.y + module.height / 2 - total_text_height / 2
		else
			bubble_x = (screen_w - total_text_width) / 2
			bubble_y = (screen_h - total_text_height) / 2
		end

		bubble_x = math.max(margin, math.min(bubble_x, screen_w - total_text_width - margin))
		bubble_y = math.max(margin, math.min(bubble_y, screen_h - total_text_height - margin))

		margin = margin - edge_margin
		GuiBeginAutoBox(module.gui)
		render_wrapped_text(module.gui, module.new_id, bubble_x, bubble_y, lines, line_heights)
		GuiZSetForNextWidget(module.gui, -999)
		GuiEndAutoBoxNinePiece(module.gui, margin, 0, 0, false, 0, "mods/noita.fairmod/files/content/copibuddy/sprites/bubble.png", "mods/noita.fairmod/files/content/copibuddy/sprites/bubble.png")
	
		local _, _, _, _, _, _, _, bubble_x, bubble_y, bubble_w, bubble_h = GuiGetPreviousWidgetInfo(module.gui)
	
		local sprite_size = 6


		local topleft_x = bubble_x - (sprite_size / 2)
		local topleft_y = bubble_y - (sprite_size / 2)
		local bottomright_x = bubble_x + bubble_w - (sprite_size / 2)
		local bottomright_y = bubble_y + bubble_h - (sprite_size / 2)


		--[[GuiZSetForNextWidget(module.gui, -9999)
		GuiImage(module.gui, new_id(), topleft_x, topleft_y, "mods/noita.fairmod/files/content/copibuddy/sprites/debug.png", 1, 1, 1, 0)
		
		GuiZSetForNextWidget(module.gui, -9999)
		GuiImage(module.gui, new_id(), bottomright_x, bottomright_y, "mods/noita.fairmod/files/content/copibuddy/sprites/debug.png", 1, 1, 1, 0)
		]]
		
		local bubble_center_x = bubble_x + bubble_w / 2
		local bubble_center_y = bubble_y + bubble_h / 2

		local arrow_y = bubble_center_y > module.y and bubble_y + 1 or bubble_y + bubble_h - 1

		local arrow_x = bubble_center_y > module.y and (bubble_center_x + sprite_size / 2) or (bubble_center_x - sprite_size / 2)

		local is_left = bubble_center_x + 2 < module.x + (module.width / 2)
		local is_right = bubble_center_x - 2 > module.x + (module.width / 2)

		local is_above = module.y < bubble_center_y

		local arrow_sprite = "mods/noita.fairmod/files/content/copibuddy/sprites/bubble_arrow_center.png"

		if(is_above)then
			if(is_left)then
				arrow_sprite = "mods/noita.fairmod/files/content/copibuddy/sprites/bubble_arrow_left.png"
			elseif(is_right)then
				arrow_sprite = "mods/noita.fairmod/files/content/copibuddy/sprites/bubble_arrow_right.png"
			end
		else
			if(is_left)then
				arrow_sprite = "mods/noita.fairmod/files/content/copibuddy/sprites/bubble_arrow_right.png"
			elseif(is_right)then
				arrow_sprite = "mods/noita.fairmod/files/content/copibuddy/sprites/bubble_arrow_left.png"
			end
		end
		
		GuiZSetForNextWidget(module.gui, -9999)
		GuiImage(module.gui, module.new_id(), arrow_x, arrow_y, arrow_sprite, 1, 1, 1, not is_above and 0 or math.pi)


	end
end

return module
