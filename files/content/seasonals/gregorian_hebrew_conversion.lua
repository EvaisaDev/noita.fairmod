--CODE NABBED FROM https://github.com/moshekaplan/calendrical_calculations/blob/master/calendrical_calculations.lua
-- very glad someone did this for me cuz i highly doubt i would've been willing to research and spend the time figuring out conversion from greg to heb calendars lmao. maybe, but maybe not

-- Based on public domain code from: http://emr.cs.iit.edu/~reingold/calendar.C
-- Only contains Hebrew and Gregorian date conversions
-- This code is also used on Wikipedia: https://en.wikipedia.org/wiki/Module:Next_Occurrence_of_Hebrew_Date


-- Absolute dates

-- "Absolute date" means the number of days elapsed since the Gregorian date
-- Sunday, December 31, 1 BC. (Since there was no year 0, the year following
-- 1 BC is 1 AD.) Thus the Gregorian date January 1, 1 AD is absolute date
-- number 1.

--  Gregorian dates

function LastDayOfGregorianMonth(month, year)
    -- Compute the last date of the month for the Gregorian calendar.
      
      if month == 2 then
        if ((((year % 4) == 0) and ((year % 100) ~= 0)) or ((year % 400) == 0)) then
          return 29;
        else
          return 28;
        end
      elseif month == 4 or month == 6 or month == 9 or month == 11 then
        return 30;
      else 
        return 31;
      end
    end
    
    GregorianDate = {}
    GregorianDate.__index = GregorianDate
    
    function GregorianDate.create(month, day, year)
       local gregoriandate = {}             -- our new object
       setmetatable(gregoriandate,GregorianDate)  -- make GregorianDate handle lookup
       -- initialize our object
        gregoriandate.month = month --  1 == January, ..., 12 == December
        gregoriandate.day = day     -- 1..LastDayOfGregorianMonth(month, year)
        gregoriandate.year = year   -- 
       return gregoriandate
    end
    
    
    function GregorianDateFromAbsolute(d)
      -- Computes the Gregorian date from the absolute date.
        
        -- Search forward year by year from approximate year
        local year = math.floor(d/366);
        while (d >= AbsoluteFromGregorianDate(GregorianDate.create(1,1,year+1))) do
          year = year + 1;
        end
        
        -- Search forward month by month from January
        local month = 1;
        while (d > AbsoluteFromGregorianDate(GregorianDate.create(month, LastDayOfGregorianMonth(month,year), year))) do
          month = month + 1;
        end
        
        local day = d - AbsoluteFromGregorianDate(GregorianDate.create(month,1,year)) + 1;
        
        return GregorianDate.create(month, day, year)
    end
    
    
    function AbsoluteFromGregorianDate(gregoriandate)
    -- Computes the absolute date from the Gregorian date.
        local N = gregoriandate.day;           -- days this month
        
        -- days in prior months this year
        local m = gregoriandate.month - 1;
        while (m > 0) do 
          N = N + LastDayOfGregorianMonth(m, gregoriandate.year);
          m = m - 1;
        end
        
        return (N                    -- days this year
           + 365 * (gregoriandate.year - 1)   -- days in previous years ignoring leap days
           + math.floor((gregoriandate.year - 1)/4)       -- Julian leap days before this year...
           - math.floor((gregoriandate.year - 1)/100)     -- ...minus prior century years...
           + math.floor((gregoriandate.year - 1)/400));   -- ...plus prior years divisible by 400
    
    end
    
    
    -- Hebrew dates
    
    HebrewEpoch = -1373429 -- Absolute date of start of Hebrew calendar
    
    function HebrewLeapYear(year)
    -- True if year is an Hebrew leap year
      if ((((7 * year) + 1) % 19) < 7)
      then
        return 1;
      else
        return 0;
      end
    end
     
    
    --Last month of Hebrew year.
    function LastMonthOfHebrewYear(year)
      if (HebrewLeapYear(year) == 1) then
        return 13;
      else
        return 12;
      end
    end
    
    
    
    function HebrewCalendarElapsedDays(year)
    -- Number of days elapsed from the Sunday prior to the start of the
    -- Hebrew calendar to the mean conjunction of Tishri of Hebrew year.
      
      local MonthsElapsed =
        (235 * math.floor((year - 1) / 19))           -- Months in complete cycles so far.
        + (12 * ((year - 1) % 19))          -- Regular months in this cycle.
        + math.floor((7 * ((year - 1) % 19) + 1) / 19); -- Leap months this cycle
      local PartsElapsed = 204 + 793 * (MonthsElapsed % 1080);
      local HoursElapsed =
        5 + 12 * MonthsElapsed + 793 * math.floor(MonthsElapsed  / 1080)
        + math.floor(PartsElapsed / 1080);
      local ConjunctionDay = 1 + 29 * MonthsElapsed + math.floor(HoursElapsed / 24);
      local ConjunctionParts = 1080 * (HoursElapsed % 24) + PartsElapsed % 1080;
      local AlternativeDay = 0;
      if ((ConjunctionParts >= 19440)        -- If new moon is at or after midday,
          or (((ConjunctionDay % 7) == 2)    -- ...or is on a Tuesday...
              and (ConjunctionParts >= 9924)  -- at 9 hours, 204 parts or later...
              and (HebrewLeapYear(year)) == 0)   -- ...of a common year,
          or (((ConjunctionDay % 7) == 1)    -- ...or is on a Monday at...
              and (ConjunctionParts >= 16789) -- 15 hours, 589 parts or later...
              and (HebrewLeapYear(year - 1) == 1))) then -- at the end of a leap year
        -- Then postpone Rosh HaShanah one day
        AlternativeDay = ConjunctionDay + 1;
      else
        AlternativeDay = ConjunctionDay;
      end
      
      if (((AlternativeDay % 7) == 0)-- If Rosh HaShanah would occur on Sunday,
          or ((AlternativeDay % 7) == 3)     -- or Wednesday,
          or ((AlternativeDay % 7) == 5))    -- or Friday
        -- Then postpone it one (more) day
      then
        return (1+ AlternativeDay);
      else
        return AlternativeDay;
      end
    end
    
    function DaysInHebrewYear(year) 
    -- Number of days in Hebrew year.
      
      return ((HebrewCalendarElapsedDays(year + 1)) -
              (HebrewCalendarElapsedDays(year)));
    end
    
    function LongHeshvan(year) 
    -- True if Heshvan is long in Hebrew year.
      
      if ((DaysInHebrewYear(year) % 10) == 5)
      then
        return 1;
      else
        return 0;
      end
    end
    
    function ShortKislev(year) 
    -- True if Kislev is short in Hebrew year.
      
      if ((DaysInHebrewYear(year) % 10) == 3)
      then
        return 1;
      else
        return 0;
      end
    end
      
    function LastDayOfHebrewMonth(month, year)
    -- Last day of month in Hebrew year.
      
      if ((month == 2)
          or (month == 4)
          or (month == 6)
          or ((month == 8) and LongHeshvan(year) == 0)
          or ((month == 9) and ShortKislev(year) == 1) --1 == 29, 0 == 30
          or (month == 10)
          or ((month == 12) and (HebrewLeapYear(year) == 0))
          or (month == 13))
      then
        return 29;
      else
        return 30;
      end
    end
    
    HebrewDate = {}
    HebrewDate.__index = HebrewDate
    
    function HebrewDate.create(month, day, year)
       local hebrewdate = {}             -- our new object
       setmetatable(hebrewdate,HebrewDate)  -- make HebrewDate handle lookup
       -- initialize our object
        hebrewdate.month = month -- 1...
        hebrewdate.day = day     -- 1..LastMonthOfHebrewYear(year)
        hebrewdate.year = year   -- 1..LastDayOfHebrewMonth(month, year)     
       return hebrewdate
    end
    
    
    function HebrewDateFromAbsolute(d)
      -- Computes the Hebrew date from the absolute date.
        local year = math.floor((d + HebrewEpoch) / 366); -- Approximation from below.
        -- Search forward for year from the approximation.
        while (d >= AbsoluteFromHebrewDate(HebrewDate.create(7,1,year + 1)))
        do
          year = year + 1;
        end
        -- Search forward for month from either Tishri or Nisan.
        local month = 0
        if (d < AbsoluteFromHebrewDate(HebrewDate.create(1, 1, year))) then  
          month = 7;  --  Start at Tishri
        else
          month = 1;  --  Start at Nisan
        end
        
        while (d > AbsoluteFromHebrewDate(HebrewDate.create(month, (LastDayOfHebrewMonth(month,year)), year))) do
            month = month + 1;
          end
        -- Calculate the day by subtraction.
        local day = d - AbsoluteFromHebrewDate(HebrewDate.create(month, 1, year)) + 1;
        return HebrewDate.create(month, day, year)
      end
    
    function AbsoluteFromHebrewDate(hebrewdate)
        -- Computes the absolute date of Hebrew date.
        local DayInYear = hebrewdate.day; -- Days so far this month.
        if (hebrewdate.month < 7) then -- Before Tishri, so add days in prior months
                         -- this year before and after Nisan.
          local m = 7;
          while (m <= (LastMonthOfHebrewYear(hebrewdate.year))) do
            DayInYear = DayInYear + LastDayOfHebrewMonth(m, hebrewdate.year);
            m = m + 1;
          end
          
          m = 1;
          while (m < hebrewdate.month) do
            DayInYear = DayInYear + LastDayOfHebrewMonth(m, hebrewdate.year);
            m = m + 1;
          end
          
        else  -- Add days in prior months this year
          local m = 7;
          while (m < hebrewdate.month) do
            DayInYear = DayInYear + LastDayOfHebrewMonth(m, hebrewdate.year);
            m = m + 1;
          end
        end
        return (DayInYear +
                (HebrewCalendarElapsedDays(hebrewdate.year)-- Days in prior years.
                 + HebrewEpoch));         -- Days elapsed before absolute date 1.
    end
    
    
    function find_gregorian_for_next_hebrew_date_occurrence(greg_year, greg_month, greg_day, heb_month, heb_day)
        local greg_absolute = AbsoluteFromGregorianDate(GregorianDate.create(greg_month, greg_day, greg_year))
        local hebrew_date = HebrewDateFromAbsolute(greg_absolute)
        
        local heb_year = hebrew_date.year
        
        -- Check if we already passed that date this year. If we have, increase the year by 1
        local this_years_hebrew_absolute = AbsoluteFromHebrewDate(HebrewDate.create(heb_month, heb_day, heb_year))
        if (greg_absolute > this_years_hebrew_absolute) then
            heb_year = heb_year + 1
        end
        
        -- Certain months only have 29 days. Advance years until we find a year with 30 days that month.
        if heb_day == 30 then
            while ((heb_month == 8) and not(LongHeshvan(heb_year))) or ((heb_month == 9) and ShortKislev(heb_year)) or ((heb_month == 12) and (HebrewLeapYear(heb_year) == 0)) do
                heb_year = heb_year + 1
            end
        end
    
        -- The year we're in has the date. Get the absolute and convert it back to a Gregorian date
        local absolute = AbsoluteFromHebrewDate(HebrewDate.create(heb_month, heb_day, heb_year))
        local gregorian = GregorianDateFromAbsolute(absolute)
        return gregorian
    end
    
    function GregorianMonthToName(monthNumber)
        if monthNumber == 1 then
            return "January"
        elseif monthNumber == 2 then
            return "February"
        elseif monthNumber == 3 then
            return "March"
        elseif monthNumber == 4 then
            return "April"
        elseif monthNumber == 5 then
            return "May"
        elseif monthNumber == 6 then
            return "June"
        elseif monthNumber == 7 then
            return "July"
        elseif monthNumber == 8 then
            return "August"
        elseif monthNumber == 9 then
            return "September"
        elseif monthNumber == 10 then
            return "October"
        elseif monthNumber == 11 then
            return "November"
        elseif monthNumber == 12 then
            return "December"
        end
    end
    
    
    function HebrewMonthNameToNumber(month)
        month = string.lower(month)
        if month == "nisan" then
            return 1
        elseif month == "iyar" then
            return 2
        elseif month == "sivan" then
            return 3
        elseif month == "tammuz" then
            return 4
        elseif month == "av" then
            return 5
        elseif month == "elul" then
            return 6
        elseif month == "tishrei" then
            return 7
        elseif month == "cheshvan" then
            return 8
        elseif month == "kislev" then
            return 9
        elseif month == "tevet" then
            return 10
        elseif month == "shevat" then
            return 11
        elseif month == "adar" then
            return 12
        else
            return nil
        end
    end


    --for anyone looking at the code, haii! o/
    --that is all.
    function get_hanukkah(gregs_date, offset)
        offset = offset or 0
        local absolute = AbsoluteFromGregorianDate(gregs_date) + offset + 1 --ignore the +1, p sure my math was off somewhere and i can't be bothered to fix it. if it works, it works.
        local hebs_date = HebrewDateFromAbsolute(absolute) --heb and greg are going on a date <3
        local shorty_offset = ShortKislev(hebs_date.year)
        --return (hebs_date.month == 9 and hebs_date.day >= 25) or (hebs_date.month == 9 and hebs_date.day <= 3 + shorty_offset) actually imma return what day of hanukkah it is
        local day = 0
        print(hebs_date.day .. "/" .. hebs_date.month)
        if hebs_date.month == 9 then
            for i = 1, hebs_date.day - 24 do
                day = day + 1
            end
            print(day)
        elseif hebs_date.month == 10 then
            for i = 1, hebs_date.day + 5 + shorty_offset do
                day = day + 1
            end
            print(day)
            print(day)
        end

        if day == 0 then return false
        else return day end
    end