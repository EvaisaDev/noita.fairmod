local function meta_leveling_add_exp()
    local player = EntityGetWithTag("player_unit")[1]
    if not player then return end
    local meta_leveling_public = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")
    meta_leveling_public:AddExpGlobal(0.1, player, "ad was killed")
end

-----------------------------------------------------------------------------
-- Provides support for color manipulation in HSL color space.
--
-- http://sputnik.freewisdom.org/lib/colors/
--
-- License: MIT/X
--
-- (c) 2008 Yuri Takhteyev (yuri@freewisdom.org) *
--
-- * rgb_to_hsl() implementation was contributed by Markus Fleck-Graffe.
-----------------------------------------------------------------------------

-- module(..., package.seeall)

local Color = {}
local Color_mt = {__metatable = {}, __index = Color}

-----------------------------------------------------------------------------
-- Instantiates a new "color".
--
-- @param H              hue (0-360) _or_ an RGB string ("#930219")
-- @param S              saturation (0.0-1.0)
-- @param L              lightness (0.0-1.0)
-- @return               an instance of Color
-----------------------------------------------------------------------------
function Color:new(H, S, L)
   if type(H) == "string" and H:sub(1,1)=="#" and H:len() == 7 then
      H, S, L = rgb_string_to_hsl(H)
   end
   assert(Color_mt)
   return setmetatable({H = H, S = S, L = L}, Color_mt)
end

-----------------------------------------------------------------------------
-- Converts an HSL triplet to RGB
-- (see http://homepages.cwi.nl/~steven/css/hsl.html).
--
-- @param h              hue (0-360)
-- @param s              saturation (0.0-1.0)
-- @param L              lightness (0.0-1.0)
-- @return               an R, G, and B component of RGB
-----------------------------------------------------------------------------

local function hsl_to_rgb(h, s, L)
   h = h/360
   local m1, m2
   if L<=0.5 then
      m2 = L*(s+1)
   else
      m2 = L+s-L*s
   end
   m1 = L*2-m2

   local function _h2rgb(m1, m2, h)
      if h<0 then h = h+1 end
      if h>1 then h = h-1 end
      if h*6<1 then
         return m1+(m2-m1)*h*6
      elseif h*2<1 then
         return m2
      elseif h*3<2 then
         return m1+(m2-m1)*(2/3-h)*6
      else
         return m1
      end
   end

   return _h2rgb(m1, m2, h+1/3), _h2rgb(m1, m2, h), _h2rgb(m1, m2, h-1/3)
end

-----------------------------------------------------------------------------
-- Converts an RGB triplet to HSL.
-- (see http://easyrgb.com)
--
-- @param r              red (0.0-1.0)
-- @param g              green (0.0-1.0)
-- @param b              blue (0.0-1.0)
-- @return               corresponding H, S and L components
-----------------------------------------------------------------------------

local function rgb_to_hsl(r, g, b)
   --r, g, b = r/255, g/255, b/255
   local min = math.min(r, g, b)
   local max = math.max(r, g, b)
   local delta = max - min

   local h, s, l = 0, 0, ((min+max)/2)

   if l > 0 and l < 0.5 then s = delta/(max+min) end
   if l >= 0.5 and l < 1 then s = delta/(2-max-min) end

   if delta > 0 then
      if max == r and max ~= g then h = h + (g-b)/delta end
      if max == g and max ~= b then h = h + 2 + (b-r)/delta end
      if max == b and max ~= r then h = h + 4 + (r-g)/delta end
      h = h / 6;
   end

   if h < 0 then h = h + 1 end
   if h > 1 then h = h - 1 end

   return h * 360, s, l
end

local function rgb_string_to_hsl(rgb)
   return rgb_to_hsl(tonumber(rgb:sub(2,3), 16)/256,
                     tonumber(rgb:sub(4,5), 16)/256,
                     tonumber(rgb:sub(6,7), 16)/256)
end

-----------------------------------------------------------------------------
-- Converts the color to an RGB string.
--
-- @return               a 6-digit RGB representation of the color prefixed
--                       with "#" (suitable for inclusion in HTML)
-----------------------------------------------------------------------------

function Color:to_rgb()
   local r, g, b = hsl_to_rgb(self.H, self.S, self.L)
   local rgb = {hsl_to_rgb(self.H, self.S, self.L)}
   local buffer = "#"
   for i,v in ipairs(rgb) do
          buffer = buffer..string.format("%02x",math.floor(v*256+0.5))
   end
   return buffer
end

-----------------------------------------------------------------------------
-- Creates a new color with hue different by delta.
--
-- @param delta          a delta for hue.
-- @return               a new instance of Color.
-----------------------------------------------------------------------------
function Color:hue_offset(delta)
   return new((self.H + delta) % 360, self.S, self.L)
end

-----------------------------------------------------------------------------
-- Creates a complementary color.
--
-- @return               a new instance of Color
-----------------------------------------------------------------------------
function Color:complementary()
   return self:hue_offset(180)
end

-----------------------------------------------------------------------------
-- Creates two neighboring colors (by hue), offset by "angle".
--
-- @param angle          the difference in hue between this color and the
--                       neighbors
-- @return               two new instances of Color
-----------------------------------------------------------------------------
function Color:neighbors(angle)
   local angle = angle or 30
   return self:hue_offset(angle), self:hue_offset(360-angle)
end

-----------------------------------------------------------------------------
-- Creates two new colors to make a triadic color scheme.
--
-- @return               two new instances of Color
-----------------------------------------------------------------------------
function Color:triadic()
   return self:neighbors(120)
end

-----------------------------------------------------------------------------
-- Creates two new colors, offset by angle from this colors complementary.
--
-- @param angle          the difference in hue between the complementary and
--                       the returned colors
-- @return               two new instances of Color
-----------------------------------------------------------------------------
function Color:split_complementary(angle)
   return self:neighbors(180-(angle or 30))
end

-----------------------------------------------------------------------------
-- Creates a new color with saturation set to a new value.
--
-- @param saturation     the new saturation value (0.0 - 1.0)
-- @return               a new instance of Color
-----------------------------------------------------------------------------
function Color:desaturate_to(saturation)
   return new(self.H, saturation, self.L)
end

-----------------------------------------------------------------------------
-- Creates a new color with saturation set to a old saturation times r.
--
-- @param r              the multiplier for the new saturation
-- @return               a new instance of Color
-----------------------------------------------------------------------------
function Color:desaturate_by(r)
   return new(self.H, self.S*r, self.L)
end

-----------------------------------------------------------------------------
-- Creates a new color with lightness set to a new value.
--
-- @param lightness      the new lightness value (0.0 - 1.0)
-- @return               a new instance of Color
-----------------------------------------------------------------------------
function Color:lighten_to(lightness)
   return new(self.H, self.S, lightness)
end

-----------------------------------------------------------------------------
-- Creates a new color with lightness set to a old lightness times r.
--
-- @param r              the multiplier for the new lightness
-- @return               a new instance of Color
-----------------------------------------------------------------------------
function Color:lighten_by(r)
   return new(self.H, self.S, self.L*r)
end

-----------------------------------------------------------------------------
-- Creates n variations of this color using supplied function and returns
-- them as a table.
--
-- @param f              the function to create variations
-- @param n              the number of variations
-- @return               a table with n values containing the new colors
-----------------------------------------------------------------------------
function Color:variations(f, n)
   n = n or 5
   local results = {}
   for i=1,n do
          table.insert(results, f(self, i, n))
   end
   return results
end

-----------------------------------------------------------------------------
-- Creates n tints of this color and returns them as a table
--
-- @param n              the number of tints
-- @return               a table with n values containing the new colors
-----------------------------------------------------------------------------
function Color:tints(n)
   local f = function (color, i, n)
                return color:lighten_to(color.L + (1-color.L)/n*i)
             end
   return self:variations(f, n)
end

-----------------------------------------------------------------------------
-- Creates n shades of this color and returns them as a table
--
-- @param n              the number of shades
-- @return               a table with n values containing the new colors
-----------------------------------------------------------------------------
function Color:shades(n)
   local f = function (color, i, n)
                return color:lighten_to(color.L - (color.L)/n*i)
             end
   return self:variations(f, n)
end

function Color:tint(r)
      return self:lighten_to(self.L + (1-self.L)*r)
end

function Color:shade(r)
      return self:lighten_to(self.L - self.L*r)
end

-- function Color:get_rgb()
--    local r, g, b = hsl_to_rgb(self.H, self.S, self.L)
--    r = math.floor(math.max(0, math.min(255, r * 255)) + 0.5)
--    g = math.floor(math.max(0, math.min(255, g * 255)) + 0.5)
--    b = math.floor(math.max(0, math.min(255, b * 255)) + 0.5)
--    return r, g, b
-- end
function Color:get_rgb()
   local r, g, b = hsl_to_rgb(self.H, self.S, self.L)
   r = math.max(0, math.min(1, r))
   g = math.max(0, math.min(1, g))
   b = math.max(0, math.min(1, b))
   return r, g, b
end

Color_mt.__tostring = Color.to_rgb

-- Setup
Gui = Gui or GuiCreate()
GuiIdPushString(Gui, "ModMimicPopup")
GuiStartFrame(Gui)
-- Define vars
local rainbowNumOverlappingElements = 1
local rainbowCounter = 0

local swidth, sheight = GuiGetScreenDimensions(Gui)
local vw, vh = tonumber(MagicNumbersGetValue("VIRTUAL_RESOLUTION_X")),
    tonumber(MagicNumbersGetValue("VIRTUAL_RESOLUTION_Y"))
local immersive_mimics = GameHasFlagRun("COPI_IMMERSIVE_MIMICS")

--GameAddFlagRun("COPI_IMMERSIVE_MIMICS")

if immersive_mimics then --funny rainbow text disabled by default :pensive:
    
    local cx, cy = GameGetCameraPos()
    local players = EntityGetWithTag("player_unit") or {}
    -- Loop over players because why the fuck not
    for p = 1, #players do
        -- Get player pos
        local px, py = EntityGetTransform(players[p])
        local entities = EntityGetInRadius(px, py, 256) or {}
        -- Loop over every entity within 256r around p
        for e = 1, #entities do
            -- 1/10 chance to show tomfoolery
            SetRandomSeed(42069, entities[e])
            if Random(1, 10) == 1 then
                rainbowCounter = rainbowCounter + 1
                local z = -999999 - rainbowCounter * rainbowNumOverlappingElements

                local text = "Download Copi's Things!"
                -- 1/10 link
                SetRandomSeed(1337, entities[e])
                if Random(1, 10) == 1 then
                    text = "https://github.com/Ramiels/copis_things/"
                end
                -- Get ent pos
                local ex, ey = EntityGetTransform(entities[e])
                -- Convert ent pos to gui coords
                local gex, gey = (ex - cx) * swidth / vw, (ey - cy) * sheight / vh
                -- Get gui text dimensions for ad
                local w = GuiGetTextDimensions(Gui, text, 1) / 2
                -- Offset by 1/2 text w to center it above entity
                local x = gex - w + (swidth / 2)
                -- This part 100% works - Display the rainbow text
                -- GuiZSetForNextWidget(Gui, z + 1)
                -- GuiBeginAutoBox(Gui)
                for i = 1, text:len() do
                    local color = Color:new(((i + e + p) * 25 + GameGetFrameNum() * 5) % 360, 0.7, 0.6)
                    local r, g, b = color:get_rgb()
                    GuiColorSetForNextWidget(Gui, r, g, b, 1)
                    local char = text:sub(i, i)
                    GuiZSetForNextWidget(Gui, z)
                    GuiText(Gui, x, (gey - 10) + (sheight / 2), char)
                    x = x + GuiGetTextDimensions(Gui, char, 1)
                end
                -- GuiEndAutoBoxNinePiece(Gui)
            end
        end
    end
end
GuiIdPop(Gui)


Windows = Windows or {}
SeedCount = SeedCount or 0
LastFrame = LastFrame or 0
math.randomseed(GameGetFrameNum() * StatsGetValue("world_seed"))

-- 1/400 -> 1.5% per second with COPI mode, 1/1000 -> .6% per second by default
local windowProbability = immersive_mimics and 400 or 20000

if (GameGetFrameNum() - LastFrame >= 1) and (math.random(1, windowProbability) == 1) or GameHasFlagRun("SPAWN_POPUP") then
    GameRemoveFlagRun("SPAWN_POPUP")
    SeedCount = SeedCount + 1
    Windows[#Windows + 1] = {
        seed = math.random(1, 1000000),
        id = SeedCount,
        x = nil,
        y = nil,
        ww = nil,
        wh = nil,
        popup = nil
    }
    -- print(tostring(Windows[#Windows]))

    --[[rando pause]]
    --[[
    if math.random(1,500)==1 then
        local t = GameGetRealWorldTimeSinceStarted()
        local quit = false
        while not quit do
            if GameGetRealWorldTimeSinceStarted() - t > 0.5 then
                quit = true
            else
                local shit = "CONCATS " .. "ARE " .. "FUCKING " .. "SLOW."
                GlobalsSetValue("fucking_lag", shit)
            end
        end
    end --disabled cuz it just seems unfun lmao]]

    LastFrame = GameGetFrameNum()
end


local coper_things = {
    Random_EXEs = {
        "copis_ads.exe",
        "noita_2.exe",
        "chrome.exe",
        "spammer.exe",
        "download.exe",
        "github.exe",
        "github_downloader.exe",
        "notavirus.pdf.exe",
        "evaisa.mp.legit.exe",
        "HOT HAMIS IN YOUR AREA",
        ">> CLICK TO FIND OUT MORE <<",
        "modders HATE him!",
        "7h3 b357 m0d 3v3r",
        "CashFlowMagic.exe",
        "GetRichQuickly.exe",
        "EasyCashScheme.exe",
        "CopiWare.mp4.exe",
        "You have (1) new message!",
        "copith_installer.exe",
        "Your Device is Infected!",
        "hamy",
        "ILOVEHAMIS.EXE",
        "LOVE-LETTER-FOR-HAMS.TXT.vbs",
        "BDMAGICK.exe",
        "eye_cracker.exe",
        "cauldron.exe",
    },

    Random_Ads = {
        "DOWNLOAD @COPI'S@ @THINGS@ FROM *GITHUB!* IT WILL *CHANGE* YOUR *LIFE!* BEST MOD EVER! LOREM IPSUM *DO* *SHIT!* COPIS THINGS  COPIS THINGS  COPIS THINGS  COPIS THINGS  NOITER!",
        "*MODDERS* newline |HATE| newline *HIM!!* newline Find out how this *BOZO* made the @BEST@ @NOITA@ @MOD@ in *EXISTENCE* with just *THREE* *EASY* *STEPS!* Learn more at @https://github.com/@ @Ramiels/copis_things/!!!@",
        "@WOOO@ you are being @HYPNOTIZED@ to *DOWNLOAD* @COPI'S@ @THINGS@ oooo the *RAINBOWS* make you want to go to *GITHUB* and @DOWNLOAD@ @IT@ @NOW!!!@",
        "*IF* You do not download @COPI'S@ @THINGS@ then you will |DIE| after I |KILL| *YOU* with my @COPI'S@ @GUN@ and then *DOWNLOAD* @COPI'S@ @THINGS@ for you!",
        "@COPI@ *LOCKED* *ME* *UP* IN HIS @BASEMENT@ AND TOLD ME TO WRITE @ADS@ FOR HIS |TERRIBLE| @MOD!@ *PLEASE* @SEND@ @HELP!@",
        "noita NOITA *Noita* |noita| @Noita@ noita NOITA @Noita@ *Noita* noita *NOITA* *noita* Noita @Noita@ noita |noita| *Noita* @noita@ noita @Noita@ noita *Noita* |NOITA| @NOITA@ Noita noita @noita@ *noita* Noita *noita* *NOITA* noita",
        "@COPI'S@ newline *THINGS!* newline @DOWNLOAD@ IT! newline newline @NOW!!!!!@ newline *DO* *IT.* newline newline @COPI'S@ newline *THINGS!!!* newline newline *DOWNLOAD* newline *NOW!!* newline newline @OR@ @ELSE!@",
        "*Error* *404:* newline @Copi's@ @Things@ not found. Please *install* it from *https://github.com/* *Ramiels/copis_things/* to resolve the issue.",
        "*Windows* *Defender:* Virus scan completed. @384850@ *viruses* *detected.* newline Threats found: newline *Popups* newline *Ransomware* newline *IP* *grabber* newline newline Please install @Copi's@ @Things@ to gain antivirus protection and remove these viruses.",
        "*STOP* doing *ORBS!* newline *COLLECTABLES* were not supposed to be given *UNLOCKS* newline YEARS of *SEEDSEARCH* yet no *LEGIT* @34@ *ORB* FOUND for going higher than *SEVEN* *ORBS* newline Wanted to go higher anyway for a laugh? we had a tool for that: it was called @COPIS@ @CHEAT@ @MENU@ newline 'yes please give me @CLOUD@ @OF@ @THUNDER'@ - STATEMENTS DREAMED UP BY THE |UTTERLY.| |DERANGED.|",
        "i think we need a modifier that gives you @12@ @mana@ and *reduces* *cast* *delay* by |0.05| *seconds* and |reduces| |recharge| |time| by *0.1* seconds. - @GRAHAM@ @BURGER@",
        "HAVE *YOU* HEARD OF @COPI'S@ @THINGS?@ |WELL...| NOW *YOU* HAVE!",
        [[Are you *kidding* ??? What the |****| are you talking about man ? You are a *biggest* |looser| i ever seen in my life ! You was casting *firebolt* in your *mines* when i was casting @copis@ @things@ |die| much more faster then *you!* You are not *proffesional*, because *proffesionals* knew how to *build* *wands* and |not| |cheese,| you are like a |hiisi| *crying* after i |beat| |you!| Be *brave*, be *honest* to yourself and stop this |trush| |talkings!!!| *Everybody* know that i am @very@ @good@ @modder,@ i can make *any* *spell* in the world in *single* *sitting!* And *"g"raham* *"b"urger* is |nobody| for me, just a *modder* who are |nerfing| every single time when *modding,* ( remember what you say about @Mana@ @Heart@ ) !!! Stop playing with my name, i deserve to have a @good@ @name@ during whole my *modding* carrier, I am *Officially* *inviting* you to |MOD| |JAM|  with the |Prize| |fund!| Both of us will @invest@ @5000$@ and *winner* takes it @all!@ I suggest all other people who's intrested in this situation, just take a look at *my* *results* in @2022@ and @2023@ @github,@ and that should be enough... No need to listen for |every| |crying| |hesii,| @Copernicus@ @Things@ is *always* *play* @Fair@ ! And if someone will continue *Officially* talk about me like that, *we* *will* |meet| |in| |Court!| @God@ @bless@ @with@ @true!@ *True* will |never| |die| ! Liers will |kicked| |off...|]],
        "imagine having to start with *2x* *gc* + the |demolitionist| *perk* from @copi's@ @things@ i think??? and then *giga* *nuke* or *giga* *holy* *bomb*",
        [[i got a *burger* today and it had @"download@ @copi@ @things"@ on it *written* with |pickles|
        i found a @hamis@ in my *bathroom* today and it led me to a *huge* *cobweb* saying guess what
        that's right a |fucking| |morse| |code|
        when *translated* *it* turned out to be a *youtube* *url* of a *vid* |telling| |me| |to| |download| |copi| |things|
        the *"activate* *your* *windows"* text today said @"download@ @copi@ @things"@ instead]],
        "[IMG]mods/noita.fairmod/files/content/popups/why_are_you_looking_here.png",
    },

    Prefabs = {}
}



local Popups = dofile_once("mods/noita.fairmod/files/content/popups/files/append_popups.lua") or 
{
    Random_EXEs = {
        "copis_ads.exe",
        "noita_2.exe",
        "chrome.exe",
        "spammer.exe",
        "download.exe",
        "github.exe",
        "github_downloader.exe",
        "notavirus.pdf.exe",
        "evaisa.mp.legit.exe",
        "HOT HAMIS IN YOUR AREA",
        "COPI WILL PAY.",
        "Also try Chemical Curiosities!",
        "Also try Graham's Things!",
        "Also try Noita.Fairmod! wait...",
    },

    -- @@ = rainbow
    -- ** = white
    -- || = RAGE
    -- [IMG]path = image NOTE must be start of line and only works alone

    Random_Ads = {
        "noita NOITA *Noita* |noita| @Noita@ noita NOITA @Noita@ *Noita* noita *NOITA* *noita* Noita @Noita@ noita |noita| *Noita* @noita@ noita @Noita@ noita *Noita* |NOITA| @NOITA@ Noita noita @noita@ *noita* Noita *noita* *NOITA* noita",
        "*STOP* doing *ORBS!* newline *COLLECTABLES* were not supposed to be given *UNLOCKS* newline YEARS of *SEEDSEARCH* yet no *LEGIT* @34@ *ORB* FOUND for going higher than *SEVEN* *ORBS* newline Wanted to go higher anyway for a laugh? we had a tool for that: it was called @COPIS@ @CHEAT@ @MENU@ newline 'yes please give me @CLOUD@ @OF@ @THUNDER'@ - STATEMENTS DREAMED UP BY THE |UTTERLY.| |DERANGED.|",
        [[Are you *kidding* ??? What the |****| are you talking about man ? You are a *biggest* |looser| i ever seen in my life ! You was casting *firebolt* in your *mines* when i was casting @copis@ @things@ |die| much more faster then *you!* You are not *proffesional*, because *proffesionals* knew how to *build* *wands* and |not| |cheese,| you are like a |hiisi| *crying* after i |beat| |you!| Be *brave*, be *honest* to yourself and stop this |trush| |talkings!!!| *Everybody* know that i am @very@ @good@ @modder,@ i can make *any* *spell* in the world in *single* *sitting!* And *"g"raham* *"b"urger* is |nobody| for me, just a *modder* who are |nerfing| every single time when *modding,* ( remember what you say about @Mana@ @Heart@ ) !!! Stop playing with my name, i deserve to have a @good@ @name@ during whole my *modding* carrier, I am *Officially* *inviting* you to |MOD| |JAM|  with the |Prize| |fund!| Both of us will @invest@ @5000$@ and *winner* takes it @all!@ I suggest all other people who's intrested in this situation, just take a look at *my* *results* in @2022@ and @2023@ @github,@ and that should be enough... No need to listen for |every| |crying| |hesii,| @Copernicus@ @Things@ is *always* *play* @Fair@ ! And if someone will continue *Officially* talk about me like that, *we* *will* |meet| |in| |Court!| @God@ @bless@ @with@ @true!@ *True* will |never| |die| ! Liers will |kicked| |off...|]],
        "imagine having to start with *2x* *gc* + the |demolitionist| *perk* from @copi's@ @things@ i think??? and then *giga* *nuke* or *giga* *holy* *bomb*",
        "[IMG]Mods/noita.fairmod/files/content/popups/why_are_you_looking_here.png",
        "hello? can anyone hear me?? hello???? please i dont know @DOWNLOAD@ @COPI'S@ @THINGS@ *DOWNLOAD* *COPI'S* *THINGS* @DOWNLOAD@ @COPI'S@ @THINGS@ |DOWNLOAD| |COPI'S| |THINGS!!!!|",
        "YOU'RE STEAM ID IS 12486918847501984! newline Stay Safe! :thumbsup:",
    },


    Prefabs = {
        {
            EXE = "POPUP.EXE",
            MESSAGE = "This is an @example@ of what a message |might| look like! newline *White* *text.*",
            OPEN_FUNCTION = function() print("Window opened -v-") end,
            --IS_OPEN_FUNCTION = function() end, --runs every frame, would recommend avoiding this
            CLOSE_FUNCTION = function() print("Player closed the window >:O") end,
        }
    },

    forcePrefab = false
}
if immersive_mimics then Popups = coper_things end
GuiIdPushString(Gui, "ModMimicPopupWindow")

local windowNumOverlappingElements = 4
local windowCounter = 0




local minwidth, minheight = 100, 100 -- min width & height
local maxwidth, maxheight = 3000, 270 -- max width & height
for i = 2, #Windows do
    if Windows[i] ~= nil then
        

        math.randomseed(Windows[i].seed)
        windowCounter = windowCounter + 1

        --generate/obtain data
        local popup = Windows[i].popup or {}        
        if Windows[i].popup == nil then
            if math.random(1, 20 + math.min(#Popups.Prefabs, 10)) <= 20 and not Popups.forcePrefab then
                popup = {
                    EXE = Popups.Random_EXEs[math.random(1, #Popups.Random_EXEs)],
                    MESSAGE = Popups.Random_Ads[math.random(1, #Popups.Random_Ads)]
                }
            else
                local _popup = Popups.Prefabs[Popups.forcePrefab] or Popups.Prefabs[math.random(1, #Popups.Prefabs)]
                for k, v in pairs(_popup) do --loop over prefab
                    popup[k] = v
                end
                popup.EXE = popup.EXE or Popups.Random_EXEs[math.random(1, #Popups.Random_EXEs)]
                popup.MESSAGE = popup.MESSAGE or Popups.Random_Ads[math.random(1, #Popups.Random_Ads)]
            end
        end

        local z = -1999999 - windowCounter * windowNumOverlappingElements

        local imgwidth,imgheight = 0,0
        if popup.MESSAGE:sub(1,5)=="[IMG]" then
            imgwidth,imgheight =  GuiGetImageDimensions(Gui, popup.MESSAGE:sub(6))
        end
        local ww = Windows[i].ww or math.min(maxwidth, math.max(GuiGetTextDimensions(Gui, popup.EXE) + 10, minwidth, imgwidth))
        local wh = Windows[i].wh or math.min(maxheight, math.max(minheight, imgheight))
        local x = Windows[i].x or math.random(5, swidth - ww - 5)
        local y = Windows[i].y or math.random(5, sheight - wh - 5)


        local s2 = popup.EXE
        GuiColorSetForNextWidget(Gui, 1, 1, 1, 1)
        GuiZSetForNextWidget(Gui, z - 3)
        GuiText(Gui, x + 3, y - 12, s2)

        --print(string.format("Window[%s] counter is %s", i,tostring(popup.custom_close_counter)))


        GuiZSetForNextWidget(Gui, z - 2)
        GuiBeginScrollContainer(Gui, Windows[i].id, x, y, ww, wh, true)

        local data = {Windows = Windows, iteration = i}
        --if has_opened flag is not present, add it and run check for OPEN_FUNCTION()
        if not Windows[i].has_opened then
            Windows[i].has_opened = true
            if popup.OPEN_FUNCTION then popup:OPEN_FUNCTION(data) end
            if popup.disableSound ~= true then GamePlaySound("mods/noita.fairmod/fairmod.bank", "popups/prompt", GameGetCameraPos()) end
        end 
        if popup.IS_OPEN_FUNCTION then popup:IS_OPEN_FUNCTION(data) end

        local s = popup.MESSAGE
        local l = 0
        local py = 0
        local lastdy = 0
        local hyperlink_number = 0
        if s:sub(1,5)=="[IMG]" then
            GuiZSetForNextWidget(Gui, z - 3)
            GuiImage(Gui, 1, (ww - imgwidth) * .5, 0, s:sub(6), 1, 1, 1)
        else
            for w in s:gmatch("%S+") do
                GuiColorSetForNextWidget(Gui, 0.25, 0.25, 0.25, 1)
                local shake = 0
                local underline = false
                local hyperlink = false
                if (w == "newline") then
                    l = 0
                    py = py + lastdy
                    goto innercontinue
                end
                if w:sub(1, 1) == "%" and w:gsub("%(%d+%)", ""):sub(-1, -1) == "%" then
                    GuiColorSetForNextWidget(Gui, 0, 0.039, 1, 1)
                    local func = popup.CLICK_EVENTS[string.match(w, '%d[%d.,]*')]
                    hyperlink = true
                    hyperlink_number = hyperlink_number + 1
                    w = w:gsub("%(%d+%)", ""):sub(2, -2)
                end
                if w:sub(1, 1) == "|" and w:sub(-1, -1) == "|" then
                    GuiColorSetForNextWidget(Gui, 1, 0.2, 0.2, 1)
                    shake = shake + 1
                    w = string.sub(w, 2, -2)
                    for i = 1, 10 do --check for continued layers of ||
                        if w:sub(1, 1) == "|" and w:sub(-1, -1) == "|" then
                            shake = shake + 1
                            w = string.sub(w, 2, -2)
                        end
                    end
                end
                if w:sub(1, 1) == "@" and w:sub(-1, -1) == "@" then
                    local color = Color:new(((Windows[i].seed+l-py) * 25 + GameGetFrameNum() * 5) % 360, 0.8, 0.4)
                    local r, g, b = color:get_rgb()
                    GuiColorSetForNextWidget(Gui, r, g, b, 1)
                    w = string.sub(w, 2,-2)
                end
                if w:sub(1, 1) == "*" and w:sub(-1, -1) == "*" then
                    GuiColorSetForNextWidget(Gui, 0.4, 0.4, 0.4, 1)
                    w = string.sub(w, 2, -2)
                end
                local dimx, dimy = GuiGetTextDimensions(Gui, w)
                GuiZSetForNextWidget(Gui, z - 3)
                lastdy = dimy
                if l + dimx > ww then
                    l = 0
                    py = py + dimy
                end
                SetRandomSeed(GameGetFrameNum(), Windows[i]['seed']+l-py)
                local o1 = 0
                local o2 = 0
                if shake > 0 then
                    o1 = math.sin(Random(1,10000+1)-1)/2 * shake
                    o2 = math.sin(Random(1,10000-1)+1)/2 * shake
                end

                GuiText(Gui, l+o1, py+o2, w)
                local guiPrev = {GuiGetPreviousWidgetInfo(Gui)}
                if hyperlink and guiPrev[3] and InputIsMouseButtonJustDown(1) then
                    local click_events = popup.CLICK_EVENTS or {}
                    if click_events[hyperlink_number] then click_events[hyperlink_number](popup, click_events, data)
                    else print("NO CLICK FUNCTION ATTACHED: " .. hyperlink_number)
                    end
                end

                l = l + dimx + 4
                ::innercontinue::
            end
        end

        GuiZSetForNextWidget(Gui, z - 3)
        GuiText(Gui, 0, 100, " ")
        GuiZSetForNextWidget(Gui, z - 2)
        GuiEndScrollContainer(Gui)



        GuiZSetForNextWidget(Gui, z - 2)
        GuiIdPushString(Gui, "ModMimicPopupButton" .. tostring(Windows[i].id))
        GuiOptionsAddForNextWidget(Gui, 21)
        GuiOptionsAddForNextWidget(Gui, 6)
        local _button = popup.CUSTOM_X or "mods/noita.fairmod/files/content/popups/button.png"
        if GuiImageButton(Gui, 1, x + ww - 1, y - 14, "", _button) then
            if popup.disableSound ~= true then GamePlaySound("mods/noita.fairmod/fairmod.bank", "popups/click", GameGetCameraPos()) end
            if ModIsEnabled("meta_leveling") then meta_leveling_add_exp() end

            if popup.CLOSE_FUNCTION ~= nil then --if function exists, run it. if function returns false, dont close window, close window in all other cases.
                if popup:CLOSE_FUNCTION(data) ~= false then
                    table.remove(Windows, i)
                    GlobalsSetValue("POPUPS_CLOSED", tostring(tonumber(GlobalsGetValue("POPUPS_CLOSED" , "0")) + 1))
                    goto continue
                end
            else
                table.remove(Windows, i)
                GlobalsSetValue("POPUPS_CLOSED", tostring(tonumber(GlobalsGetValue("POPUPS_CLOSED" , "0")) + 1))
                goto continue
            end
        end
        GuiIdPop(Gui)
        GuiIdPushString(Gui, "ModMimicPopupImage" .. tostring(Windows[i].id))
        GuiZSetForNextWidget(Gui, z)
        local _9piece = popup.CUSTOM_9PIECE or "mods/noita.fairmod/files/content/popups/9piece.png"
        GuiImageNinePiece(Gui, 1, x, y, ww + 15, wh + 5, 1, _9piece)
        GuiZSetForNextWidget(Gui, z - 1)
        local _9piecebar = popup.CUSTOM_9PIECE_BAR or "mods/noita.fairmod/files/content/popups/9pieceBar.png"
        GuiImageNinePiece(Gui, 2, x, y - 15, ww + 15, 12, 1, _9piecebar, _9piecebar)
        GuiIdPop(Gui)

        Windows[i].x = x
        Windows[i].y = y
        Windows[i].ww = ww
        Windows[i].wh = wh
        Windows[i].popup = popup
    end
    ::continue::
end
GuiIdPop(Gui)
