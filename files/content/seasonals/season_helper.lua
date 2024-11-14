local a,b,c,d,e,f,g,h = GameGetDateAndTimeLocal()
local TimeLocal = {
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

local is_leap_year = TimeLocal.year % 4 == 0

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
    local dw = val8-(val9*7) 

    if (dw == 0) then
      dw = 7
    end
---nabbed code
  

local weekday = days[dw]
if dw == 1 then dw = 8 end
local day_of_week = dw - 1


local void_calendar = {
    normal = "11001111010011110010100101011001000011111100110011010111010001010110001101110101010101011001111000110010111011000101100011010100001000001110101110111111001101100000001111101110100011101001110000000101100110110101101110010001110110110101110000111111011111000010111000000001100001000011100000011111110000011110010111100110101001110100100111100010011111111010001001000",
    leap =   "110011110100111100101001010110000001111110011001101011101000010101100011011101010101010110111110001100101110110001011000110101000010000011101011101111100011011000000011111011101000111010011100000001011001101101011011100100011101101101011100001111110111110000101110000000011100010000111000000111111100000111100101111001101010011101001000111100010011111111010001001000",
}

local void_day
if is_leap_year then
    void_day = void_calendar.leap:sub(day_of_year, day_of_year)
else
    void_day = void_calendar.normal:sub(day_of_year, day_of_year)
end
void_day = void_day == "1" and true or false

local halloween = (TimeLocal.month == 10 and TimeLocal.day >= 7) or (TimeLocal.month == 11 and TimeLocal.day <= 7) --halloween from 7th of october to 7th of november, for 32 spooky days!
local christmas = TimeLocal.month == 12 and TimeLocal.day >= 9 and TimeLocal.day <= 30 --boxing day is the day christmas dies. 

dofile("mods/noita.fairmod/files/content/seasonals/gregorian_hebrew_conversion.lua")
local hanukkah = get_hanukkah(TimeLocal)
--print("IS IT HANUKKAH???????? STUDY SHOWS: " .. tostring(get_hanukkah({day = 7, month = 12, year = 2023})))

local valentines = TimeLocal.month == 2 and TimeLocal.day == 14
local easter = nil --oh i cant be bothered, easter is also fucking weird cuz i need the fucking day of the week and shit lmao, ill figure this out later. i literally just finished setting up hanukkah, i have at least like 5 months before i need to care about this



--[[ sorry christians, calculating easter fucking sucks lmao
---nabbed code
local a = TimeLocal.year % 19
local b = math.floor(TimeLocal.year / 100)
local c = TimeLocal.year % 100
local d = math.floor(b / 4)
local e = b % 4
local f = math.floor((b + 8) / 25) 
local g = math.floor((b - f + 1) / 3)
local h = (19 * a + b - d - g + 15) % 30
local i = math.floor(c / 4)
local k = c % 4
local L = (32 + 2 * e + 2 * i - h - k) %7
local m = math.floor((a + 11 * h + 22 * L) / 451)
local shrove_month = math.floor((h + L - 7 * m + 114 - 47) / 31)
local shrove_day = (h + L - 7 * m + 114 - 47) % 31 + 1
if shrove_month == 2 then    --adjust dates in February 
    shrove_day = is_leap_year and shrove_day - 2 or shrove_day - 3
end
---nabbed code ]]


local copiday = TimeLocal.day == 0 and TimeLocal.month == 0







return {
    TimeLocal = TimeLocal,
    TimeUTC = TimeUTC,

    ----local: (stuff based on localtime)
    day_of_year = day_of_year, -- day of year 1-366
    day_of_week = day_of_week, --day of week 1-7
    weekday = weekday, --probs pointless but eh, who cares

    --bools:
    is_leap_year = is_leap_year,
    void_day = void_day,
    halloween = halloween,
    christmas = christmas,
    hanukkah = hanukkah,
    valentines = valentines,

    copiday = copiday
}