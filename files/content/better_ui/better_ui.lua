-- Funni ui that is shown on the right side of the screen.
-- written by IQuant, Refactored by Eba
-- Rewrited again by Lamia using his *beautiful* lib

local seasonal = dofile_once("mods/noita.fairmod/files/content/seasonals/season_helper.lua")

local userseed = ModSettingGet("fairmod.user_seed")
if type(userseed) ~= "string" then error("broken seed") end

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local ui = dofile("mods/noita.fairmod/files/lib/ui_lib.lua") --- @class better_ui:UI_class
ui.text_scale = 0.75
ui.buttons.img = "mods/noita.fairmod/files/content/better_ui/gfx/ui_9piece_button.png"
ui.buttons.img_hl = "mods/noita.fairmod/files/content/better_ui/gfx/ui_9piece_button_highlight.png"

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
	return string.format(seconds_f < 10 and "%i:0%02.3f" or "%i:%02.3f", minutes, seconds_f)
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

local objectives_codes = {
	"copi",
	"chaos",
	"superchest",
	"boob",
	"thirsty",
	"gimmetinker",
}

local objectives = {
	"Find Dave",
	"Hämis",
	"Complete the objective",
	"Drink all water",
	"Have 3 people visit your island",
	"Loading...",
	"Failed",
	"Follow the purple lights",
	"Forfeit material wealth for Hämis",
	"Kill.",
	"Fail this objective",
	"Defeat God.",
	"Download Copi's Things",
	"Make 100 friends",
	"Buy tips from Hämis",
	"Throw for content",
	"Keep Yourself Safe",
	"Win",
	"Survive",
	"Lose",
	"Tie",
	"Eat Steve",
	"Eat Scott",
	"Unlock dev_mode",
	"Type Code [" .. objectives_codes[Random(1, #objectives_codes)] .. "]!",
	"Be the last to be eliminated",
	"Kill 5 other players",
	"Find love",
	"Forgive.",
	"Remember yourself",
	"Realise your ambitions",
}

local game_speed_a = 0
local game_speed_b = 1

--- @class ui_displays
--- @field normal ui_display[]
--- @field speedrun ui_display[]
local ui_displays = {
	normal = {
		{
			text = function()
				return {
					text = string.format(
						"[Achievements: %s/%s]",
						GlobalsGetValue("fairmod_achievements_unlocked", "0"),
						GlobalsGetValue("fairmod_total_achievements", "0")
					),
					tooltip = "Click to see them!",
					on_click = function()
						fairmod_achievements_displaying_window = not fairmod_achievements_displaying_window
					end,
					color = GameHasFlagRun("fairmod_new_achievement") and { 0.8, 1, 0.5 } or { 0.8, 0.8, 0.8 },
				}
			end,
			condition = global_greater_than_zero("fairmod_achievements_unlocked"),
		},
		{
			text = function()
				return { text = "Debt: " .. GlobalsGetValue("loan_shark_debt", "0"), color = { 1, 0.2, 0.2, 1 } }
			end,
			condition = global_greater_than_zero("loan_shark_debt"),
		},
		{
			text = function()
				return string.format("Radios tuned: %s", GlobalsGetValue("radios_activated", "0"))
			end,
			condition = global_greater_than_zero("radios_activated"),
		},
		{
			text = function()
				return string.format("Radios tuned Highscore: %s", tostring(ModSettingGet("fairmod.radios_activated_highscore")))
			end,
			condition = global_greater_than_zero("radios_activated"),
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
				if wsc == nil then return end --if wsc is nil, god help us...
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
				local enemy = get_any_nearby_tags("big_friend", "small_friend", "mimic_potion", "boss_dragon", "boss", "miniboss")[1]
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
				return "New Game+ Iteration: " .. (GlobalsGetValue("NEW_GAME_PLUS_ITERATION") == "NaN" and "NaN" or SessionNumbersGetValue("NEW_GAME_PLUS_COUNT"))
			end,
			condition = function()
				return GlobalsGetValue("NEW_GAME_PLUS_ITERATION") ~= ""
			end
		},
		{
			text = function()
				return "Alias: " .. GlobalsGetValue("NEW_GAME_PLUS_ITERATION")
			end,
			condition = function()
				return GlobalsGetValue("NEW_GAME_PLUS_ITERATION") ~= SessionNumbersGetValue("NEW_GAME_PLUS_COUNT")
				and GlobalsGetValue("NEW_GAME_PLUS_ITERATION") ~= ""
				and GlobalsGetValue("NEW_GAME_PLUS_ITERATION") ~= "NaN"
			end
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
					return "Lost 1 time since last win"
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
local extra_ui = {
	{
		text = "Hair follicles: 0",
	},
	{
		text = function()
			SetRandomSeed(0, math.floor(GameGetFrameNum() / 120))
			local ping_ms = Random(14, 350)
			return "Ping: " .. ping_ms .. " ms"
		end,
	},
	{
		text = function()
			SetRandomSeed(0, math.floor(GameGetFrameNum() / (60 * 3600)))
			local objective = objectives[Random(1, #objectives)]
			return "Current objective: " .. objective
		end,
	},
	{
		text = function()
			local player_count = #EntityGetWithTag("player_unit")
				+ #EntityGetWithTag("polymorphed_player") -- Base game
				+ #EntityGetWithTag("client") -- Noita Arena
				+ #EntityGetWithTag("ew_client") -- Entangled Worlds
				+ #EntityGetWithTag("nt_ghost") -- Noita Together
				+ #EntityGetWithTag("iota_multiplayer.player") -- Iota Multiplayer
			return "Players connected: " .. player_count
		end,
	},
	{
		text = function()
			return "Unread messages: " .. (ModSettingGet("noita.fairmod.discord_pings") or 0)
		end,
	},
	{
		text = "Best pet: Cats", --[[ +1 -k]]
	},
	{
		text = function()
			local special_ammo = 0
			local player = EntityGetWithTag("player_unit")[1]
			if player then
				local ingestion_comp = EntityGetFirstComponent(player, "IngestionComponent")
				if ingestion_comp then special_ammo = ComponentGetValue2(ingestion_comp, "ingestion_size") end
			end
			return "Special ammo: " .. math.max(0, special_ammo)
		end,
	},
	{
		text = function()
			local enemies = EntityGetWithTag("enemy")
			local hams = 0
			for _, enemy in ipairs(enemies) do
				if EntityGetFilename(enemy) == "data/entities/animals/longleg.xml" then hams = hams + 1 end
			end
			return "Häppiness: " .. hams
		end,
	},
	{
		text = "Noita: yes",
	},
	{
		text = "You smell: Bad",
	},
	{
		text = tonumber(userseed.sub(27,27)) > 7 and "Terraria: Maybe" or "Terraria: No",
	},
	{
		text = function()
			if GameGetFrameNum() % 60 == 0 then
				game_speed_b = game_speed_a
				game_speed_a = GameGetRealWorldTimeSinceStarted()
			end
			return "Game speed: " .. ("%.2f%%"):format(100 / (game_speed_a - game_speed_b))
		end,
	},
	{
		text = function()
			return "Language: " .. GameTextGetTranslatedOrNot("$current_language")
		end,
	},
	{
		text = function()
			local is_void = seasonal.void_day
			is_void = userseed:sub(21,21) < 3 and not is_void or is_void --30% chance to just lie based on user_seed
			is_void = is_void and "yes" or "no"
			return "Void Calendar: " .. is_void
		end
	},
	{
		text = function()
			return "Cool: " .. (ModIsEnabled("component-explorer") and "Yes" or "No")
		end,
	},
	{
		text = function()
			local jumps = tonumber(GlobalsGetValue("FAIRMOD_JUMPS")) or 0
			local player = EntityGetWithTag("player_unit")[1] or EntityGetWithTag("polymorphed_player")[1]
			if player then
				local controls = EntityGetFirstComponent(player, "ControlsComponent")
				if controls and ComponentGetValue2(controls, "mButtonFrameFly") == GameGetFrameNum() then
					jumps = jumps + 1
					GlobalsSetValue("FAIRMOD_JUMPS", tostring(jumps))
				end
			end
			return "Jumps: " .. jumps
		end,
	},
	{
		text = function()
			local dir = "Unknowable"
			local player = EntityGetWithTag("player_unit")[1] or EntityGetWithTag("polymorphed_player")[1]
			if player then
				local controls = EntityGetFirstComponent(player, "ControlsComponent")
				if controls then
					local dirx, diry = ComponentGetValue2(controls, "mAimingVectorNormalized")
					if diry < -0.5 then
						dir = "North"
						if dirx > 0.5 then
							dir = "Neast"
						elseif dirx < -0.5 then
							dir = "Worth"
						end
					elseif diry > 0.5 then
						dir = "South"
						if dirx > 0.5 then
							dir = "Easth"
						elseif dirx < -0.5 then
							dir = "Woust"
						end
					elseif dirx > 0.5 then
						dir = "East"
					elseif dirx < -0.5 then
						dir = "West"
					else
						dir = "None"
					end
				end
			end
			return "Direction: " .. dir
		end,
	},
	{
		text = function()
			-- Speed per second but we calculate it once every minute
			local prev_pos_x = tonumber(GlobalsGetValue("FAIRMOD_PREVPOS_X")) or 0
			local prev_pos_y = tonumber(GlobalsGetValue("FAIRMOD_PREVPOS_Y")) or 0
			local last_pos_x = tonumber(GlobalsGetValue("FAIRMOD_LASTPOS_X")) or 0
			local last_pos_y = tonumber(GlobalsGetValue("FAIRMOD_LASTPOS_Y")) or 0

			-- we calculate the speed by taking the difference between two
			-- positions every 60 seconds. this is objectively the wrong way
			-- to do it. :)
			if GameGetFrameNum() % (60 * 60) == 0 then
				local player = EntityGetWithTag("player_unit")[1] or EntityGetWithTag("polymorphed_player")[1]
				if player then
					prev_pos_x, prev_pos_y = last_pos_x, last_pos_y
					last_pos_x, last_pos_y = EntityGetTransform(player)
					GlobalsSetValue("FAIRMOD_PREVPOS_X", tostring(prev_pos_x))
					GlobalsSetValue("FAIRMOD_PREVPOS_Y", tostring(prev_pos_y))
					GlobalsSetValue("FAIRMOD_LASTPOS_X", tostring(last_pos_x))
					GlobalsSetValue("FAIRMOD_LASTPOS_Y", tostring(last_pos_y))
				end
			end

			local diff_x = prev_pos_x - last_pos_x
			local diff_y = prev_pos_y - last_pos_y
			local speed_per_minute = math.sqrt(diff_x ^ 2 + diff_y ^ 2)

			return "Speed: " .. ("%.2f"):format(speed_per_minute / 60)
		end,
	},
	{
		text = function()
			local _, y = GameGetCameraPos()
			-- Don't show X position. That would spoil the PW!
			local above_or_below = ""
			if y < 10 then
				above_or_below = "above surface"
			elseif y > 10 then
				above_or_below = "underground"
			else
				return "Depth: Surface"
			end
			return "Depth: " .. math.abs(math.floor(y / 10)) / 2 .. "m " .. above_or_below
		end,
	},
}

local current_display = "normal"

--- Draws entry
--- @param entry_data display_entry
function ui:draw_entry_data(entry_data)
	local text = ""
	if type(entry_data) == "string" then
		text = entry_data
	elseif type(entry_data) == "table" then
		text = entry_data.text or "" --[[@as string]]
	end
	local x = self.dim.x - self.x_shift - 10
	local text_w = self:GetTextDimension(text)
	local hovered = self:IsHoverBoxHovered(x, self.y, text_w, 7, true)
	if hovered then
		if entry_data.tooltip then
			local tp_width = self:GetTextDimension(entry_data.tooltip)
			self:ShowTooltip(x - tp_width - 10, self.y, entry_data.tooltip)
		end
		if entry_data.on_click and self:IsLeftClicked() then
			GamePlaySound("ui", "ui/button_click", 0, 0)
			entry_data.on_click()
		end
	end
	if entry_data.color then self:Color(entry_data.color[1] or 1, entry_data.color[2] or 1, entry_data.color[3] or 1, entry_data.color[4] or 1) end
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

	local extra_ui_count = tonumber(GlobalsGetValue("FAIRMOD_EXTRA_UI_COUNT")) or 0
	for i = 1, math.min(extra_ui_count, #extra_ui) do
		self:process_entry(extra_ui[i])
	end

	self:get_max_length()
	for i = 1, #pending_info do
		self:draw_info(pending_info[i])
	end

	-- Buttons for more/fewer UI. Intentionally goes off-screen so you can't
	-- change it.
	self.y = self.y + 4
	local x = self.dim.x - self.x_shift - 10

	local more_text = "More"
	local _, more_w = self:GetTextDimension(more_text)
	if self:IsButtonClicked(x, self.y, 10, more_text, "Show more info UI") then extra_ui_count = math.min(extra_ui_count + 5, #extra_ui) end

	if extra_ui_count > 0 then
		if self:IsButtonClicked(x + more_w + 20, self.y, 10, "Fewer", "Show less info UI") then extra_ui_count = math.max(0, extra_ui_count - 5) end
	end

	GlobalsSetValue("FAIRMOD_EXTRA_UI_COUNT", tostring(extra_ui_count))
end

return ui
