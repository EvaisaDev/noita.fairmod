local module = {}

local ref_template = {
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
	forced_event_queue = {},
	functions = {
		test = function()
			print("test")
		end
	}
}

local function reset(instance)
	for k, v in pairs(ref_template) do
		if k ~= "gui" and k ~= "id_counter" then
			instance[k] = v
		end
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
	local camera_x, camera_y = GameGetCameraPos()
	-- Use floating point random to avoid edge cases and ensure proper distribution
	SetRandomSeed(GameGetFrameNum() + camera_x, GameGetFrameNum() + camera_y * total)
	local r = Random() * total
	for _, v in ipairs(t) do
		local weight = weights[v]
		r = r - weight
		if r < 0 then
			return v
		end
	end
	-- Fallback to last item if rounding errors occur
	return t[#t]
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

local function parse_formatted_text(text, instance)
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
					fmt.on_click = instance and instance.functions and instance.functions[value]
				elseif tag == "on_hover" then
					fmt.on_hover = instance and instance.functions and instance.functions[value]
				elseif tag == "on_right_click" then
					fmt.on_right_click = instance and instance.functions and instance.functions[value]
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

local function render_wrapped_text(gui, new_id, x, y, lines, line_heights, instance)
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

			local is_hovered = hoverable and (hovered or (seg.seg_id and instance.prev_hover_ids and instance.prev_hover_ids[seg.seg_id]))
			if hovered and seg.seg_id then
				instance.current_hover_ids[seg.seg_id] = true
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

function module.create()
	local instance = {
		gui = GuiCreate(),
		id_counter = 1241
	}

	for k, v in pairs(ref_template) do
		instance[k] = v
	end

	function instance.new_id()
		instance.id_counter = instance.id_counter + 1
		return instance.id_counter
	end

	function instance.update()
		if (GameHasFlagRun("reset_copibuddy")) then
			reset(instance)
		end
		if (not GameHasFlagRun("is_copibuddied")) then
			return
		elseif(not GameHasFlagRun("copibuddy_activated"))then
			GameAddFlagRun("copibuddy_activated")
			if(Random(0, 100) < 40)then
				AddFlagPersistent("copibuddy_next_run")
				print("Copibuddy will repeat!")
			end
		end
		
		local speak_text = GlobalsGetValue("copibuddy_speak_text", "")
		if speak_text ~= "" and not instance.event then
			GlobalsSetValue("copibuddy_speak_text", "")
			local id = "speak_event_" .. tostring(GameGetFrameNum())
			local speak_event = {
				id = id,
				text = speak_text,
				anim = "talk",
				frames = 300,
				force = true,
				func = function(copibuddy)
					GlobalsSetValue("copi_tts", speak_text)
					-- remove itself from content after speaking
					for i, event in ipairs(content) do
						if event.id and event.id == id then
							table.remove(content, i)
							break
						end
					end

				end,
			}
			content = content or {}
			table.insert(content, 1, speak_event)
		end
		
		local force_event_id = GlobalsGetValue("copi_force_event", "")
		if force_event_id ~= "" then
			GlobalsSetValue("copi_force_event", "")
			-- Find the event with matching id and add it to the queue
			for _, event in ipairs(content) do
				if event.id == force_event_id then
					table.insert(instance.forced_event_queue, event)
					break
				end
			end
		end
		
		instance.prev_hover_ids = instance.current_hover_ids or {}
		instance.current_hover_ids = {}
		instance.prev_hover_ids = instance.current_hover_ids or {}
		instance.current_hover_ids = {}
		
		instance.id_counter = 1241

		if(instance.event and instance.event.update)then
			instance.event.update(instance)
		end

		GuiStartFrame(instance.gui)
		local screen_w, screen_h = GuiGetScreenDimensions(instance.gui)
		if (not instance.was_active) then
			instance.animation = "fade_in"
			instance.was_active = true
			instance.timer = 60
			instance.x = Random(0, screen_w - instance.width)
			instance.y = Random(0, screen_h - instance.height)
		end

		local next_event = nil
		if(instance.on_cooldown)then
			-- Check if there's a forced event in the queue
			if #instance.forced_event_queue > 0 then
				next_event = table.remove(instance.forced_event_queue, 1)
				instance.timer = 0
			else
				for _, event in ipairs(content) do
					if (event.force and (not event.condition or event.condition(instance, event)) and (event ~= instance.last_event)) then
						instance.timer = 0
						next_event = event
						goto continue
					end
				end
			end
		end

		::continue::

		if (instance.timer > 0) then
			instance.timer = instance.timer - 1
			if (instance.timer == 0) then

				if(instance.event and instance.event.post_func)then
					instance.event.post_func(instance)
				end

				instance.animation = "idle"
				instance.event = nil
				instance.parsed_text = nil
				instance.current_progress = nil
				instance.total_length = nil
				if(not instance.on_cooldown)then
					instance.on_cooldown = true
					instance.timer = Random(instance.event_cooldown[1], instance.event_cooldown[2])
				end
			end
		elseif (instance.event == nil) then
			SetRandomSeed(GameGetFrameNum() + instance.x, GameGetFrameNum() + instance.y)
			local options = {}
			if(not next_event)then
				for _, event in ipairs(content) do
					if ((not event.condition or event.condition(instance, event)) and (event ~= instance.last_event)) then
						if(event.force)then
							options = {event}
							break
						end
						table.insert(options, event)
					end
				end
			end

			if (#options > 0 or next_event) then
				instance.event = #options > 0 and weighted_random(options) or next_event


				if(instance.event == nil)then
					return
				end

				--instance.last_event = instance.event

				if (instance.event.func) then
					instance.event.func(instance)
				end
				if (instance.event.anim and type(instance.event.anim) == "function") then
					instance.animation = instance.event.anim(instance)
				elseif (instance.event.anim) then
					instance.animation = instance.event.anim
				else
					instance.animation = "idle"
				end

				if (instance.event.post_talk_anim and type(instance.event.post_talk_anim) == "function") then
					instance.post_talk_anim = instance.event.post_talk_anim(instance)
				elseif (instance.event.post_talk_anim) then
					instance.post_talk_anim = instance.event.post_talk_anim
				else
					instance.post_talk_anim = "idle"
				end
				
				if (instance.event.audio and type(instance.event.audio) == "function") then
					local audio = instance.event.audio(instance)
					if (audio) then
						GamePlaySound(audio[1], audio[2], 0, 0)
					end
				elseif (instance.event.audio) then
					GamePlaySound(instance.event.audio[1], instance.event.audio[2], 0, 0)
				end
				local raw_text = nil
				if (instance.event.text and type(instance.event.text) == "function") then
					raw_text = instance.event.text(instance)
				elseif (instance.event.text) then
					raw_text = instance.event.text
				end


				instance.functions = {}
				for k, v in pairs(ref_template.functions) do
					instance.functions[k] = v
				end

				if (instance.event.functions) then
					for k, v in pairs(instance.event.functions) do
						instance.functions[k] = v
					end
			end
			

			if raw_text then
				instance.parsed_text = parse_formatted_text(raw_text, instance)
				--print(pretty_table(instance.parsed_text))
				instance.total_length = 0
				for _, seg in ipairs(instance.parsed_text) do
					instance.total_length = instance.total_length + #seg.text
				end
				instance.current_progress = 0
			end				instance.type_delay = instance.event.type_delay or 3
				instance.timer = instance.event.frames or 60

				instance.on_cooldown = false
			end
		end

	if(instance.target_text ~= nil)then

		instance.parsed_text = parse_formatted_text(instance.target_text, instance)
		--print(pretty_table(instance.parsed_text))
		instance.total_length = 0
		for _, seg in ipairs(instance.parsed_text) do
			instance.total_length = instance.total_length + #seg.text
		end
		instance.current_progress = 0
		instance.target_text = nil
	end
		if instance.parsed_text and instance.current_progress < instance.total_length then
			instance.type_delay = instance.type_delay - 1
			if instance.type_delay <= 0 then
				instance.type_delay = (instance.event and instance.event.type_delay) or 3
				instance.current_progress = instance.current_progress + 1
				if instance.current_progress > instance.total_length then
					instance.current_progress = instance.total_length
				end

				if instance.current_progress == instance.total_length then
					instance.animation = instance.post_talk_anim
				end


				if (not instance.event or not instance.event.frames) then
					instance.timer = instance.timer + instance.type_delay
				end
			end
		end
		GuiZSetForNextWidget(instance.gui, -998)
		GuiImage(instance.gui, instance.new_id(), instance.x, instance.y, instance.spritesheet, 1, 1, 1, 0, 2, instance.animation or "idle")
		if instance.parsed_text then
			local visible_segments = slice_parsed_segments(instance.parsed_text, instance.current_progress)
			local margin = 5
			local edge_margin = 6
			local lines = wrap_segments(instance.gui, visible_segments, instance.max_text_width)
			local total_text_width, total_text_height, line_heights = measure_lines(instance.gui, lines)

			margin = margin + edge_margin
			local bubble_x, bubble_y
			if (instance.y - total_text_height - margin >= 0) then
				bubble_x = instance.x + instance.width / 2 - total_text_width / 2
				bubble_y = instance.y - total_text_height - margin
			elseif (instance.y + instance.height + total_text_height + margin <= screen_h) then
				bubble_x = instance.x + instance.width / 2 - total_text_width / 2
				bubble_y = instance.y + instance.height + margin
			elseif (instance.x - total_text_width - margin >= 0) then
				bubble_x = instance.x - total_text_width - margin
				bubble_y = instance.y + instance.height / 2 - total_text_height / 2
			elseif (instance.x + instance.width + total_text_width + margin <= screen_w) then
				bubble_x = instance.x + instance.width + margin
				bubble_y = instance.y + instance.height / 2 - total_text_height / 2
			else
				bubble_x = (screen_w - total_text_width) / 2
				bubble_y = (screen_h - total_text_height) / 2
			end

			bubble_x = math.max(margin, math.min(bubble_x, screen_w - total_text_width - margin))
			bubble_y = math.max(margin, math.min(bubble_y, screen_h - total_text_height - margin))

			margin = margin - edge_margin
			GuiBeginAutoBox(instance.gui)
			render_wrapped_text(instance.gui, instance.new_id, bubble_x, bubble_y, lines, line_heights, instance)
			GuiZSetForNextWidget(instance.gui, -999)
			GuiEndAutoBoxNinePiece(instance.gui, margin, 0, 0, false, 0, "mods/noita.fairmod/files/content/copibuddy/sprites/bubble.png", "mods/noita.fairmod/files/content/copibuddy/sprites/bubble.png")
		
			local _, _, _, _, _, _, _, bubble_x, bubble_y, bubble_w, bubble_h = GuiGetPreviousWidgetInfo(instance.gui)
		
			local sprite_size = 6


			local topleft_x = bubble_x - (sprite_size / 2)
			local topleft_y = bubble_y - (sprite_size / 2)
			local bottomright_x = bubble_x + bubble_w - (sprite_size / 2)
			local bottomright_y = bubble_y + bubble_h - (sprite_size / 2)


			--[[GuiZSetForNextWidget(instance.gui, -9999)
			GuiImage(instance.gui, new_id(), topleft_x, topleft_y, "mods/noita.fairmod/files/content/copibuddy/sprites/debug.png", 1, 1, 1, 0)
			
			GuiZSetForNextWidget(instance.gui, -9999)
			GuiImage(instance.gui, new_id(), bottomright_x, bottomright_y, "mods/noita.fairmod/files/content/copibuddy/sprites/debug.png", 1, 1, 1, 0)
			]]
			
			local bubble_center_x = bubble_x + bubble_w / 2
			local bubble_center_y = bubble_y + bubble_h / 2

			local arrow_y = bubble_center_y > instance.y and bubble_y + 1 or bubble_y + bubble_h - 1

			local arrow_x = bubble_center_y > instance.y and (bubble_center_x + sprite_size / 2) or (bubble_center_x - sprite_size / 2)

			local is_left = bubble_center_x + 2 < instance.x + (instance.width / 2)
			local is_right = bubble_center_x - 2 > instance.x + (instance.width / 2)

			local is_above = instance.y < bubble_center_y

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
			
			GuiZSetForNextWidget(instance.gui, -9999)
			GuiImage(instance.gui, instance.new_id(), arrow_x, arrow_y, arrow_sprite, 1, 1, 1, not is_above and 0 or math.pi)


		end
	end
	
	return instance
end

return module
