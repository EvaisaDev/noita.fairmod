local entity_interacted = GetUpdatedEntityID()
local radio_comp = EntityGetFirstComponent(entity_interacted, "AudioLoopComponent", "radio_on")
local radio_is_on = radio_comp ~= nil
local x, y = EntityGetTransform(entity_interacted)
local special_events = {
	{
		numbers	= {
			"18 21 26",
			"15 3 23 15 6 13 12 26",
			"3 19",
			"3 12 23",
			"8 18 10 10",
			"13 16",
			"6 3 10 8",
			"6 13 18 16",
		},
		current_line = 1,
		current_pointer = 1,
		timer_same_line = 60, -- Time interval between numbers in the same line
		timer_new_line = 90,  -- Time interval before starting a new line
		current_time = 0,
		state = 'reading_line', -- Initial state
		condition = function()
			local year, month, day, hour, minute, second = GameGetDateAndTimeUTC()
			return minute == 0 or minute == 30
		end,
		init = function(self)
			if radio_comp then ComponentSetValue2(radio_comp, "event_name", "radio/static") 
				EntitySetComponentIsEnabled(entity_interacted, radio_comp, false)
				EntitySetComponentIsEnabled(entity_interacted, radio_comp, true)
				ComponentSetValue2(radio_comp, "m_volume", 0.3)
			end
			self.current_line = 1
			self.current_pointer = 1
			self.current_time = 0
		end,
		update = function(self)
			self.current_time = self.current_time + 1

			-- Function to get the next number from the current line
			local function get_number()
				local line = self.numbers[self.current_line]
				local number = ""
				while self.current_pointer <= #line do
					local char = line:sub(self.current_pointer, self.current_pointer)
					if char == " " then
						self.current_pointer = self.current_pointer + 1
						break
					end
					number = number .. char
					self.current_pointer = self.current_pointer + 1
				end
				if number == "" then
					return nil
				else
					return tonumber(number)
				end
			end

			-- State machine to handle reading numbers and waiting between lines
			if self.state == 'reading_line' then
				-- Time to get the next number in the current line
				if self.current_time >= self.timer_same_line then
					self.current_time = self.current_time - self.timer_same_line
					local number = get_number()
					if number then

						GamePlaySound("mods/noita.fairmod/fairmod.bank", "radio/"..tostring(number), x, y)
					else
						-- End of the current line reached; switch to waiting state
						self.state = 'waiting_new_line'
						self.current_time = 0
						-- Prepare for the next line
						self.current_pointer = 1
						self.current_line = self.current_line + 1
						if self.current_line > #self.numbers then
							-- All lines have been processed; deactivate the event
							active_event = nil
							ModSettingSet("fairmod.listened_to_numbers", true)
							if radio_comp then ComponentSetValue2(radio_comp, "event_name", "radio/loop") end
							print("Event has been completed and is now deactivated.")
							return
						end
					end
				end
			elseif self.state == 'waiting_new_line' then
				-- Waiting period before starting the next line
				if self.current_time >= self.timer_new_line then
					self.current_time = self.current_time - self.timer_new_line
					self.state = 'reading_line'
				end
			end
		end
	}
}

active_event = active_event or nil

if(active_event == nil and radio_is_on)then
	for _, event in ipairs(special_events) do
		if event.condition() then
			active_event = event
			active_event:init()
			break
		end
	end
end

if(active_event ~= nil and radio_is_on)then
	active_event:update()
else
	active_event = nil
end

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	radio_is_on = EntityGetFirstComponent(entity_interacted, "AudioLoopComponent", "radio_on") ~= nil
	local entity = GetUpdatedEntityID()


	if not radio_is_on then
		EntitySetComponentsWithTagEnabled(entity, "radio_on", true)
		EntitySetComponentsWithTagEnabled(entity, "radio_off", false)
		local audiocomp = EntityGetFirstComponent(entity, "AudioLoopComponent", "radio_on")
		if audiocomp == nil then EntityInflictDamage(GetUpdatedEntityID(), 1000, "DAMAGE_ELECTRICITY", "Malfunction", "NONE", 0, 0) return end
		ComponentSetValue2(audiocomp, "m_volume", 1)
		SetRandomSeed(x, GameGetFrameNum())
		if audiocomp then ComponentSetValue2(audiocomp, "event_name", "radio/" .. (Random(1, 10) == 9 and "ill_see_you_when_i_see_you" or "loop")) end

		local current_radios = tonumber(GlobalsGetValue("radios_activated", "0")) + 1
		GlobalsSetValue("radios_activated", tostring(current_radios))
		if current_radios > (ModSettingGet("fairmod.radios_activated_highscore") or 0) then
			ModSettingSet("fairmod.radios_activated_highscore", current_radios)
			if current_radios > 9 then
				GameAddFlagRun("10_radios_tuned")
				if current_radios > 27 then
					GameAddFlagRun("28_radios_tuned")
				end
			end
		end
	else
		EntitySetComponentsWithTagEnabled(entity, "radio_on", false)
		EntitySetComponentsWithTagEnabled(entity, "radio_off", true)
		GlobalsSetValue("radios_activated", tostring(tonumber(GlobalsGetValue("radios_activated", "0")) - 1))
	end
end
