-- Funni ui that is shown on the right side of the screen.
-- written by IQuant, Refactored by Eba
-- Rewrited again by Lamia using his *beautiful* lib

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local ui = dofile("mods/noita.fairmod/files/lib/ui_lib.lua") --- @class better_ui:UI_class
ui.text_scale = 0.75

for content in nxml.edit_file("data/entities/animals/boss_centipede/sampo.xml") do
	content:add_child(nxml.new_element("LuaComponent", {
		script_item_picked_up = "mods/noita.fairmod/files/content/better_ui/append/sampo_pickup.lua",
		remove_after_executed = "1",
	}))
end

ModLuaFileAppend(
	"data/entities/animals/boss_centipede/ending/sampo_start_ending_sequence.lua",
	"mods/noita.fairmod/files/content/better_ui/append/ending_sequence.lua"
)

local pending_info = {} --- @type display_entry[][]

--- @param frames number
--- @return string
local function frames_to_time(frames)
	local seconds_f = frames / 60
	local minutes = math.floor(seconds_f / 60)
	seconds_f = seconds_f % 60
	return string.format("%i:%02.3f", minutes, seconds_f)
end

local function has_flag_run(flag)
	return function()
		return GameHasFlagRun(flag)
	end
end

local function global_greater_than_zero(global)
	return function()
		return (tonumber(GlobalsGetValue(global, "0")) or 0) > 0
	end
end

--- @param label string
--- @param var string
--- @return fun():string[]
local function speedrun_split(label, var)
	return function()
		local splt = GlobalsGetValue(var, "--")
		if splt ~= "--" then splt = frames_to_time(tonumber(splt)) end
		return { label, splt }
	end
end

--- @param ... string
--- @return number[]
local function get_any_nearby_tags(...)
	local tags = { ... }
	local x, y = GameGetCameraPos()
	local result = {}
	for _, tag in ipairs(tags) do
		result = EntityGetInRadiusWithTag(x, y, 300, tag) or {}

		if #result > 0 then break end
	end
	return result
end

--- @param tagname string
--- @return integer
local function count_nearby_tags(tagname)
	return #get_any_nearby_tags(tagname)
end

local function get_ingame_time()
	local wse = GameGetWorldStateEntity()
	local wsc = EntityGetFirstComponent(wse, "WorldStateComponent")
	local time_fraction = ComponentGetValue2(wsc, "time")
	return time_fraction * (24 * 60)
end

local moon_phases = {
	"Full Moon",
	"Waning Gibbous",
	"Third Quarter",
	"Waning Crescent",
	"New Moon",
	"Waxing Crescent",
	"First Quarter",
	"Waxing Gibbous",
}

--- @class ui_displays
--- @field normal ui_display[]
--- @field speedrun ui_display[]
local ui_displays = {
	normal = {
		{
			text = function()
				return { text = "Debt: " .. GlobalsGetValue("loan_shark_debt", "0"), color = { 1, 0.2, 0.2, 1 } }
			end,
			condition = global_greater_than_zero("loan_shark_debt"),
		},
		{
			text = function()
				local time_minutes_total = get_ingame_time()
				local time_minutes = time_minutes_total % 60
				local time_hours = math.floor(time_minutes_total / 60)
				return string.format("Time: %2.0f:%02.0f", time_hours, time_minutes)
			end,
		},
		{
			text = function()
				local wse = GameGetWorldStateEntity()
				local wsc = EntityGetFirstComponent(wse, "WorldStateComponent")
				local rain = ComponentGetValue2(wsc, "rain")
				local fog = ComponentGetValue2(wsc, "fog")
				local wind = ComponentGetValue2(wsc, "wind")
				local lightning = ComponentGetValue2(wsc, "lightning_count")

				if lightning > 0 then
					return "Weather: thunderstorm"
				elseif rain > 0.5 then
					return "Weather: raining"
				elseif fog > 0.5 then
					return "Weather: foggy"
				elseif wind > 0.5 then
					return "Weather: windy"
				else
					return "Weather: clear"
				end
			end,
		},
		{
			text = function()
				local wse = GameGetWorldStateEntity()
				local wsc = EntityGetFirstComponent(wse, "WorldStateComponent")
				local day = ComponentGetValue2(wsc, "day_count")
				local moon_phase = moon_phases[math.fmod(day, #moon_phases) + 1]

				return "Moon: " .. moon_phase
			end,
		},
		{
			text = function()
				-- TODO give 5 fishing power only when holding the fishing rod
				local fishing_power = 5

				local wse = GameGetWorldStateEntity()
				local wsc = EntityGetFirstComponent(wse, "WorldStateComponent")
				local rain = ComponentGetValue2(wsc, "rain")
				local fog = ComponentGetValue2(wsc, "fog")
				local day = ComponentGetValue2(wsc, "day_count")
				local moon_phase = moon_phases[math.fmod(day, #moon_phases) + 1]
				local gametime = get_ingame_time()

				-- Time modifier
				if gametime >= 4 * 60 + 30 and gametime < 6 * 60 then
					fishing_power = fishing_power * 1.3
				elseif gametime >= 9 * 60 and gametime < 15 * 60 then
					fishing_power = fishing_power * 0.8
				elseif gametime >= 18 * 60 and gametime < 19 * 60 + 30 then
					fishing_power = fishing_power * 1.3
				elseif gametime >= 21 * 60 + 18 or gametime < 2 * 60 + 42 then
					fishing_power = fishing_power * 0.8
				end

				-- rain modifier
				if rain > 0.5 then fishing_power = fishing_power * 1.2 end

				-- fog modifier
				if fog > 0.5 then fishing_power = fishing_power * 1.1 end

				-- moon phase modifier
				if moon_phase == "Full Moon" then
					fishing_power = fishing_power * 1.1
				elseif moon_phase == "Waning Gibbous" or moon_phase == "Waxing Gibbous" then
					fishing_power = fishing_power * 1.05
				elseif moon_phase == "Waning Crescent" or moon_phase == "Waxing Crescent" then
					fishing_power = fishing_power * 0.95
				elseif moon_phase == "New Moon" then
					fishing_power = fishing_power * 0.9
				end

				return tostring(math.floor(fishing_power)) .. " Fishing power"
			end,
		},
		{
			text = function()
				-- TODO get fish kills for this run or something
				return GlobalsGetValue("fish_caught", "0") .. " fish caught"
			end,
			condition = global_greater_than_zero("fish_caught"),
		},
		{
			text = function()
				-- TODO look for actual ore materials like copper
				if count_nearby_tags("gold_nugget") ~= 0 then return "Gold detected nearby!" end
				return "No ore detected"
			end,
		},
		{
			text = function()
				-- TODO: add a rare tag to hiisi chef, mimics, santa hiisi
				local enemy = get_any_nearby_tags(
					"big_friend",
					"small_friend",
					"mimic_potion",
					"boss_dragon",
					"boss",
					"miniboss"
				)[1]
				if enemy ~= nil then
					local name = EntityGetName(enemy) -- not working??? Kolmi not showing up
					if name ~= nil and name ~= "" then return "Rare enemy: " .. GameTextGetTranslatedOrNot(name) end
				end
				return "Rare enemy: None"
			end,
		},
		{
			text = function()
				-- the +1 makes it inaccurate but is intentional as a joke
				-- https://discord.com/channels/453998283174576133/1293148865943310388/1297182319475691581
				local enemy_count = count_nearby_tags("enemy") + 1
				if enemy_count == 1 then
					return enemy_count .. " enemy nearby"
				else
					return enemy_count .. " enemies nearby"
				end
			end,
		},
		{
			text = function()
				local times_taken_piss = tonumber(GlobalsGetValue("TIMES_TOOK_PISS", "0")) or 0
				if times_taken_piss == 1 then
					return times_taken_piss .. " piss taken"
				else
					return times_taken_piss .. " pisses taken"
				end
			end,
			condition = global_greater_than_zero("TIMES_TOOK_PISS"),
		},
		{
			text = function()
				local times_taken_shit = tonumber(GlobalsGetValue("TIMES_TOOK_SHIT", "0")) or 0
				if times_taken_shit == 1 then
					return times_taken_shit .. " shit taken"
				else
					return times_taken_shit .. " shits taken"
				end
			end,
			condition = global_greater_than_zero("TIMES_TOOK_SHIT"),
		},
		{
			text = function()
				return {
					text = table.concat({
						"Achievements Unlocked: ",
						GlobalsGetValue("fairmod_achievements_unlocked", "0"),
						"/",
						GlobalsGetValue("fairmod_total_achievements", "0"),
					}),
					tooltip = "Click to see them!",
					on_click = function()
						fairmod_achievements_displaying_window = not fairmod_achievements_displaying_window
					end,
				}
			end,
			condition = global_greater_than_zero("fairmod_achievements_unlocked"),
		},
		{
			text = function()
				return "Wins while using mod: " .. tostring((ModSettingGet("fairmod_win_count") or 0))
			end,
			condition = function()
				return (ModSettingGet("fairmod_win_count") or 0) > 0
			end,
		},
		{
			text = function()
				return "Deaths while using mod: " .. tostring(ModSettingGet("fairmod.deaths") or 0)
			end,
			condition = function()
				return (ModSettingGet("fairmod.deaths") or 0) > 0
			end,
		},
		{
			text = "",
			condition = has_flag_run("gamblecore_found"),
		},
		{
			text = "Gamblehelper (tm)",
			condition = has_flag_run("gamblecore_found"),
		},
		{
			text = function()
				local times_won = tonumber(GlobalsGetValue("GAMBLECORE_TIMES_WON", "0")) or 0
				if times_won == 1 then
					return "Won " .. times_won .. " time"
				else
					return "Won " .. times_won .. " times"
				end
			end,
			condition = has_flag_run("gamblecore_found"),
		},
		{
			text = function()
				local times_lost_in_a_row = tonumber(GlobalsGetValue("GAMBLECORE_TIMES_LOST_IN_A_ROW", "0")) or 0
				if times_lost_in_a_row == 1 then
					return "Lost " .. times_lost_in_a_row .. " time since last win"
				else
					return "Lost " .. times_lost_in_a_row .. " times since last win"
				end
			end,
			condition = has_flag_run("gamblecore_found"),
		},
		{
			text = function()
				local times_lost_in_a_row = tonumber(GlobalsGetValue("GAMBLECORE_TIMES_LOST_IN_A_ROW", "0")) or 0
				if times_lost_in_a_row > 2 then
					local p1 = 0.1
					local p = math.pow((1 - p1), times_lost_in_a_row + 1)
					local pf = string.format("%.2f %%", p * 100)
					return "Probability of losing " .. (times_lost_in_a_row + 1) .. " times in row is " .. pf
				else
					return nil
				end
			end,
			condition = function()
				local times_lost = tonumber(GlobalsGetValue("GAMBLECORE_TIMES_LOST_IN_A_ROW", "0")) or 0
				return GameHasFlagRun("gamblecore_found") and times_lost > 2
			end,
		},
		{
			text = "Keep gambling, you're due for a win!",
			condition = function()
				local times_lost = tonumber(GlobalsGetValue("GAMBLECORE_TIMES_LOST_IN_A_ROW", "0")) or 0
				return GameHasFlagRun("gamblecore_found") and times_lost > 2
			end,
		},
		{
			text = "",
			condition = has_flag_run("gamblecore_found"),
		},
	},
	speedrun = {
		{
			text = "Noita Fairmod           Any%",
		},
		{
			text = speedrun_split("The Door: ", "SPEEDRUN_SPLIT_DOOR"),
		},
		{
			text = speedrun_split("Sampo: ", "SPEEDRUN_SPLIT_SAMPO"),
		},
		-- Maybe do Kolmi later
		-- {
		--     text = speedrun_split("Kolmi: ", "SPEEDRUN_SPLIT_KOLMI"),
		-- },
		{
			text = speedrun_split("Complete The Work: ", "SPEEDRUN_SPLIT_WORK"),
		},
		{
			text = function()
				return { "Current time: ", frames_to_time(GameGetFrameNum()) }
			end,
		},
		{
			text = "",
		},
	},
}

local current_display = "normal"

--- Draws entry
--- @param entry_data display_entry
function ui:draw_entry_data(entry_data)
	local text = ""
	local color = { 1, 1, 1, 1 }
	if type(entry_data) == "string" then
		text = entry_data
	elseif type(entry_data) == "table" then
		text = entry_data.text or "" --[[@as string]]
		color = entry_data.color or color
	end
	self:Color(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
	local x = self.dim.x - self.x_shift - 10
	local text_w = self:GetTextDimension(text)
	local hovered = self:IsHoverBoxHovered(x, self.y, text_w, 7, true)
	if hovered then
		if entry_data.tooltip then
			local tp_width = self:GetTextDimension(entry_data.tooltip)
			self:ShowTooltip(x - tp_width - 10, self.y, entry_data.tooltip)
		end
		if entry_data.on_click and self:IsLeftClicked() then entry_data.on_click() end
	end
	self:Text(x, self.y, text)
end

--- Draws info
--- @param info display_entry[]
function ui:draw_info(info)
	-- Render the first text entry
	self:draw_entry_data(info[1])

	-- Render additional text entries aligned to the right
	local total_width = 10
	for i = #info, 2, -1 do
		local entry = info[i]
		local entry_text = ""
		local entry_color = { 1, 1, 1, 1 }
		if type(entry) == "string" then
			entry_text = entry
		elseif type(entry) == "table" then
			entry_text = entry.text or "" --[[@as string]]
			entry_color = entry.color or entry_color
		end
		local tw, _ = self:GetTextDimension(entry_text)
		self:Color(entry_color[1] or 1, entry_color[2] or 1, entry_color[3] or 1, entry_color[4] or 1)
		self:Text(self.dim.x - total_width - tw, self.y, entry_text)
		total_width = total_width + tw
	end
	self.y = self.y + 9
end

--- Calculate max entry
function ui:get_max_length()
	local c_max = 0
	for _, info in ipairs(pending_info) do
		local first_entry = info[1]
		local text = ""
		if type(first_entry) == "string" then
			text = first_entry
		elseif type(first_entry) == "table" then
			text = first_entry.text or "" --[[@as string]]
		end
		local tw, _ = self:GetTextDimension(text)
		c_max = math.max(c_max, tw)
	end
	self.x_shift = c_max
end

--- Process entry before drawing
--- @param entry ui_display
function ui:process_entry(entry)
	if entry.condition and not entry.condition() then return end

	local text = entry.text
	if type(text) == "function" then text = text() end
	if not text then return end

	if type(text) == "string" or type(text) == "table" then
		-- Handle text being a string or table
		-- For consistency, wrap single strings in a table
		if type(text) == "string" then text = { text } end

		if text.text then text = { text } end

		table.insert(pending_info, text)
	end
end

--- Draws gui
function ui:update()
	self:StartFrame()
	GuiZSet(self.gui, 10)

	self:UpdateDimensions()

	self.y = 120
	pending_info = {}

	-- Determine which display to use
	if GameHasFlagRun("speedrun_door_used") then
		current_display = "speedrun"
	else
		current_display = "normal"
	end

	local display_entries = ui_displays[current_display]

	for i = 1, #display_entries do
		self:process_entry(display_entries[i])
	end

	self:get_max_length()
	for i = 1, #pending_info do
		self:draw_info(pending_info[i])
	end
end

return ui
