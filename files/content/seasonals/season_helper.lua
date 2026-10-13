local TimeLocal,TimeUTC

do
	local a,b,c,d,e,f,g,h = GameGetDateAndTimeLocal()
	TimeLocal = {
		year = a,
		month = b,
		day = c,
		hour = d,
		minute = e,
		second = f,
		jussi = g,
		mammi = h,
	}

	a,b,c,d,e,f = GameGetDateAndTimeUTC()
	TimeUTC = {
		year = a,
		month = b,
		day = c,
		hour = d,
		minute = e,
		second = f,
	}
end

--[[ spoof dates by uncommenting stuff at the bottom
local spoof_date = {
	year = 2025,
	month = 12,
	day = 15,
	hour = 7,
	minute = 49,
	second = 57,
	jussi = false,
	mammi = true,
}
TimeLocal = spoof_date
TimeUTC = spoof_date --]]


local is_leap_year
---nabbed code
if TimeLocal.year % 4 == 0 then --damn leap years are more complex than i thought, i thought it was just (year % 4 == 0) lmao
	if TimeLocal.year % 100 == 0 then
		if TimeLocal.year % 400 == 0 then
			is_leap_year = true
		else
			is_leap_year = false
		end
	else
		is_leap_year = true
	end
else
	is_leap_year = false
end
---nabbed code

local month_lengths = {
	31,
	is_leap_year and 29 or 28,
	31,
	30,
	31,
	30,
	31,
	31,
	30,
	31,
	30,
	31,
}

local day_of_year = 0
for i = 1, TimeLocal.month - 1 do
	day_of_year = day_of_year + month_lengths[i]
end
day_of_year = day_of_year + TimeLocal.day


---nabbed code
	local dd,mm,yy = TimeUTC.day, TimeUTC.month, TimeUTC.year
	local days = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }

	local mmx = mm

	if (mm == 1) then  mmx = 13; yy = yy-1  end
	if (mm == 2) then  mmx = 14; yy = yy-1  end

	local val8 = dd + (mmx*2) +  math.floor(((mmx+1)*3)/5)   + yy + math.floor(yy/4)  - math.floor(yy/100)  + math.floor(yy/400) + 2
	local val9 = math.floor(val8/7)
	local day_of_week = val8-(val9*7)

	if (day_of_week == 0) then
	  day_of_week = 7
	end
---nabbed code
local weekday = days[day_of_week]

local void_calendar = {
	normal = "11001111010011110010100101011001000011111100110011010111010001010110001101110101010101011001111000110010111011000101100011010100001000001110101110111111001101100000001111101110100011101001110000000101100110110101101110010001110110110101110000111111011111000010111000000001100001000011100000011111110000011110010111100110101001110100100111100010011111111010001001000",
	leap =   "11001111010011110010100101011000000111111001100110101110100001010110001101110101010101011011111000110010111011000101100011010100001000001110101110111110001101100000001111101110100011101001110000000101100110110101101110010001110110110101110000111111011111000010111000000001110001000011100000011111110000011110010111100110101001110100100",
}
local void_day
if is_leap_year then
	if day_of_year <= 335 then
		void_day = void_calendar.leap:sub(day_of_year, day_of_year)
		void_day = void_day == "0"
	end
else
	void_day = void_calendar.normal:sub(day_of_year, day_of_year)
	void_day = void_day == "0"
end --true for void, false for not, nil for random



--Custom stuff:

--https://stackoverflow.com/a/22123033
local function greg_get_easter(year, offset)
	offset = offset or 0
	local leap_year
	if year % 4 == 0 then
		if year % 100 == 0 then
			if year % 400 == 0 then
				leap_year = true
			else
				leap_year = false
			end
		else
			leap_year = true
		end
	else
		leap_year = false
	end
	local a = year % 19
	local b = math.floor(year / 100)
	local c = year % 100
	local d = math.floor(b / 4)
	local e = b % 4
	local f = math.floor((b + 8) / 25)
	local g = math.floor((b - f + 1) / 3)
	local h = (19 * a + b - d - g + 15) % 30
	local i = math.floor(c / 4)
	local k = c % 4
	local L = (32 + 2 * e + 2 * i - h - k) %7
	local m = math.floor((a + 11 * h + 22 * L) / 451)
	local month = math.floor((h + L - 7 * m + 114 + offset) / 31)
	local day = (h + L - 7 * m + 114 + offset) % 31 + 1
	if month == 2 then --adjust dates in February
		day = leap_year and day - 2 or day - 3
	end
	return day, month
end


local halloween = (TimeLocal.month == 10 and TimeLocal.day >= 7) or (TimeLocal.month == 11 and TimeLocal.day <= 7) --halloween from 7th of october to 7th of november, for 32 spooky days!
local christmas = TimeLocal.month == 12 and TimeLocal.day >= 1 and TimeLocal.day <= 30 --boxing day is the day christmas dies.

dofile("mods/noita.fairmod/files/content/seasonals/gregorian_hebrew_conversion.lua")
local hanukkah = get_hanukkah(TimeLocal) --this will return false if not hanukkah, and otherwise return what day of hanukkah it is

local valentines = TimeLocal.month == 2 and TimeLocal.day == 14
local easter_sunday = false
local shrove_tuesday = false
do
	local day,month = greg_get_easter(TimeLocal.year)
	if TimeLocal.day == day and TimeLocal.month == month then
		easter_sunday = true
	else
		day,month = greg_get_easter(TimeLocal.year, -47)
		shrove_tuesday = TimeLocal.day == day and TimeLocal.month == month
	end
end

local fairmod_release_absolute = AbsoluteFromGregorianDate(GregorianDate.create(10, 31, 2024))
local current_absolute = AbsoluteFromGregorianDate(GregorianDate.create(TimeUTC.month, TimeUTC.day, TimeUTC.year))
if not ModSettingGet("fairmod.first_played") then ModSettingSet("fairmod.first_played", current_absolute) end
ModSettingSet("fairmod.last_played", current_absolute)

local copiday = TimeLocal.day == 11 and TimeLocal.month == 11







return {
	TimeLocal = TimeLocal,
	TimeUTC = TimeUTC,
	Timezone = TimeLocal.hour - TimeUTC.hour,

	----local: (stuff based on localtime)
	---@type int day of the year within the range [1, 366]
	day_of_year = day_of_year,
	day_of_week = day_of_week,
	weekday = weekday, --day of the week string


	--bools:

	---@type bool is it currently a leap year?
	is_leap_year = is_leap_year,
	---@type bool|nil --`true` if Void, `false` if Air, `nil` if Random
	void_day = void_day,
	---@type bool is it currently Halloween?
	halloween = halloween,
	---@type bool is it currently Christmas?
	christmas = christmas,
	---@type false|number false if not Hanukkah, otherwise returns what day of Hanukkah it is
	hanukkah = hanukkah,
	valentines = valentines, --is it valentine's day?
	easter_sunday = easter_sunday, --is it easter sunday?
	shrove_tuesday = shrove_tuesday, --is it shrove tuesday?

	spring = false,
	summer = false,
	autumn = false,
	winter = false,

	copiday = copiday,
}