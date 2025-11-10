-- SAM Reciter - Text to Phoneme conversion
-- Lua port with SAM ruleset
-- Original by Christian Schiffler

local SAMReciter = {}


local FLAG_VOWEL = 0x01
local FLAG_CONSONANT = 0x02
local FLAG_VOICED = 0x04
local FLAG_FRONT_VOWEL = 0x08
local FLAG_SIBILANT = 0x10
local FLAG_DIPTHONG = 0x20


local charFlags = {
    ['A'] = FLAG_VOWEL,
    ['E'] = bit.bor(FLAG_VOWEL, FLAG_FRONT_VOWEL),
    ['I'] = bit.bor(FLAG_VOWEL, FLAG_FRONT_VOWEL),
    ['O'] = FLAG_VOWEL,
    ['U'] = FLAG_VOWEL,
    ['Y'] = bit.bor(FLAG_VOWEL, FLAG_FRONT_VOWEL),
    ['B'] = bit.bor(FLAG_CONSONANT, FLAG_VOICED),
    ['C'] = bit.bor(FLAG_CONSONANT, FLAG_SIBILANT),
    ['D'] = bit.bor(FLAG_CONSONANT, FLAG_VOICED),
    ['F'] = FLAG_CONSONANT,
    ['G'] = bit.bor(FLAG_CONSONANT, FLAG_SIBILANT, FLAG_VOICED),
    ['H'] = FLAG_CONSONANT,
    ['J'] = bit.bor(FLAG_CONSONANT, FLAG_VOICED),
    ['K'] = FLAG_CONSONANT,
    ['L'] = bit.bor(FLAG_CONSONANT, FLAG_VOICED),
    ['M'] = bit.bor(FLAG_CONSONANT, FLAG_VOICED),
    ['N'] = bit.bor(FLAG_CONSONANT, FLAG_VOICED),
    ['P'] = FLAG_CONSONANT,
    ['Q'] = FLAG_CONSONANT,
    ['R'] = bit.bor(FLAG_CONSONANT, FLAG_VOICED),
    ['S'] = bit.bor(FLAG_CONSONANT, FLAG_SIBILANT),
    ['T'] = FLAG_CONSONANT,
    ['V'] = bit.bor(FLAG_CONSONANT, FLAG_VOICED),
    ['W'] = bit.bor(FLAG_CONSONANT, FLAG_VOICED),
    ['X'] = bit.bor(FLAG_CONSONANT, FLAG_SIBILANT),
    ['Z'] = bit.bor(FLAG_CONSONANT, FLAG_SIBILANT, FLAG_VOICED),
    [' '] = 0,
}

local function isVowel(c)
    local f = charFlags[c]
    return f and bit.band(f, FLAG_VOWEL) ~= 0
end

local function isConsonant(c)
    local f = charFlags[c]
    return f and bit.band(f, FLAG_CONSONANT) ~= 0
end

local function isVoiced(c)
    local f = charFlags[c]
    return f and bit.band(f, FLAG_VOICED) ~= 0
end

local function isFrontVowel(c)
    local f = charFlags[c]
    return f and bit.band(f, FLAG_FRONT_VOWEL) ~= 0
end

local function isSibilant(c)
    local f = charFlags[c]
    return f and bit.band(f, FLAG_SIBILANT) ~= 0
end


local function matchesPattern(text, pos, pattern, direction)
    if pattern == "" then return true end
    
    local pIdx = 1
    local tIdx = pos
    
    while pIdx <= #pattern do
        local pChar = string.sub(pattern, pIdx, pIdx)
        
        if tIdx < 1 or tIdx > #text then
            return false
        end
        
        local tChar = string.sub(text, tIdx, tIdx)
        
        if pChar == '#' then
            
            if not isVowel(tChar) then return false end
            while tIdx >= 1 and tIdx <= #text and isVowel(string.sub(text, tIdx, tIdx)) do
                tIdx = tIdx + direction
            end
            tIdx = tIdx - direction
        elseif pChar == ':' then
            
            while tIdx >= 1 and tIdx <= #text and isConsonant(string.sub(text, tIdx, tIdx)) do
                tIdx = tIdx + direction
            end
            tIdx = tIdx - direction
        elseif pChar == '^' then
            
            if not isConsonant(tChar) then return false end
        elseif pChar == '+' then
            
            if not isFrontVowel(tChar) then return false end
        elseif pChar == '.' then
            
            if not isVoiced(tChar) then return false end
        elseif pChar == '&' then
            
            if not isSibilant(tChar) then return false end
        elseif pChar == '@' then
            
            if tChar ~= 'T' and tChar ~= 'S' and tChar ~= 'R' and tChar ~= 'D' and 
               tChar ~= 'L' and tChar ~= 'Z' and tChar ~= 'N' and tChar ~= 'J' then
                return false
            end
        elseif pChar == '%' then
            
            local rest = string.sub(text, tIdx)
            if not (string.match(rest, "^ER") or string.match(rest, "^E ") or 
                    string.match(rest, "^ES") or string.match(rest, "^ED") or
                    string.match(rest, "^ING") or string.match(rest, "^ELY")) then
                return false
            end
            return true  
        elseif pChar == ' ' then
            if tChar ~= ' ' then return false end
        else
            
            if pChar ~= tChar then return false end
        end
        
        pIdx = pIdx + 1
        tIdx = tIdx + direction
    end
    
    return true
end


local FLAG_NUMERIC = 0x01
local FLAG_RULESET2 = 0x02
local FLAG_VOICED = 0x04
local FLAG_0X08 = 0x08
local FLAG_DIPTHONG = 0x10
local FLAG_CONSONANT = 0x20
local FLAG_VOWEL_OR_Y = 0x40
local FLAG_ALPHA_OR_QUOT = 0x80


local rules = {}
local rules2 = {}


local function addRules(tbl, rulesStr)
    for rule in string.gmatch(rulesStr, "[^|]+") do
        table.insert(tbl, rule)
    end
end


addRules(rules, " (A.)=EH4Y.| (A) =AH| (ARE) =AAR| (AR)O=AXR|(AR)#=EH4R| ^(AS)#=EY4S|(A)WA=AX|(AW)=AO5| :(ANY)=EH4NIY|(A)^+#=EY5|#:(ALLY)=ULIY| (AL)#=UL|(AGAIN)=AXGEH4N|#:(AG)E=IHJ|(A)^%=EY|(A)^+:#=AE| :(A)^+ =EY4| (ARR)=AXR|(ARR)=AE4R| ^(AR) =AA5R|(AR)=AA5R|(AIR)=EH4R|(AI)=EY4|(AY)=EY5|(AU)=AO4|#:(AL) =UL|#:(ALS) =ULZ|(ALK)=AO4K|(AL)^=AOL|(ABLE)=EY4BUL|(ABLE)=AXBUL|(A)VO=EY4|(ANG)+=EY4NJ|(ATARI)=AHTAA4RIY|(A)TOM=AE|(A)TTI=AE| (AT) =AET| (A)T=AH|(A)=AE")
addRules(rules, " (B) =BIY4| (BE)^#=BIH|(BEING)=BIY4IHNX| (BOTH) =BOW4TH| (BUS)#=BIH4Z|(BUIL)=BIH4L|(B)=B")
addRules(rules, " (C) =SIY4| (CH)^=K|^E(CH)=K|(CHA)R#=KEH5|(CH)=CH| S(CI)#=SAY4|(CI)A=SH|(CI)O=SH|(CI)EN=SH|(CITY)=SIHTIY|(C)+=S|(CK)=K|(COMMODORE)=KAA4MAHDOHR|(COM)=KAHM|(CUIT)=KIHT|(CREA)=KRIYEY|(C)=K")
addRules(rules, " (D) =DIY4| (DR.) =DAA4KTER|#:(DED) =DIHD|.E(D) =D|#:^E(D) =T| (DE)^#=DIH| (DO) =DUW| (DOES)=DAHZ|(DONE) =DAH5N|(DOING)=DUW4IHN| (DOW)=DAW|#(DU)A=JUW|#(DU)^#=JAX|(D)=D")
addRules(rules, " (E) =IYIY4|#:(E) =|:^(E) =| :(E) =IY|#(ED) =D|#:(E)D =|(EV)ER=EH4V|(E)^%=IY4|(ERI)#=IY4RIY|(ERI)=EH4RIH|#:(ER)#=ER|(ERROR)=EH4ROHR|(ERASE)=IHREY5S|(ER)#=EHR|(ER)=ER| (EVEN)=IYVEHN|#:(E)W=|@(EW)=UW|(EW)=YUW|(E)O=IY|#:&(ES) =IHZ|#:(E)S =|#:(ELY) =LIY|#:(EMENT)=MEHNT|(EFUL)=FUHL|(EE)=IY4|(EARN)=ER5N| (EAR)^=ER5|(EAD)=EHD|#:(EA) =IYAX|(EA)SU=EH5|(EA)=IY5|(EIGH)=EY4|(EI)=IY4| (EYE)=AY4|(EY)=IY|(EU)=YUW5|(EQUAL)=IY4KWUL|(E)=EH")
addRules(rules, " (F) =EH4F|(FUL)=FUHL|(FRIEND)=FREH5ND|(FATHER)=FAA4DHER|(F)F=|(F)=F")
addRules(rules, " (G) =JIY4|(GIV)=GIH5V| (G)I^=G|(GE)T=GEH5|SU(GGES)=GJEH4S|(GG)=G| B#(G)=G|(G)+=J|(GREAT)=GREY4T|(GON)E=GAO5N|#(GH)=| (GH)=G|(G)=G")
addRules(rules, " (H) =EY4CH| (HAV)=/HAE6V| (HERE)=/HIYR| (HOUR)=AW5ER|(HOW)=/HAW|(H)#=/H|(H)=")
addRules(rules, " (IN)=IHN| (I) =AY4|(I) =AY|(IN)D=AY5N|SEM(I)=IY| ANT(I)=AY|(IER)=IYER|#:R(IED) =IYD|(IED) =AY5D|(IEN)=IYEHN|(IE)T=AY4EH|(I')=AY5| :(I)^%=AY5| :(IE) =AY4|(I)%=IY|(IE)=IY4| (IDEA)=AYDIY5AH|I^(DENT)=DIHEHNT|(I)^+=IH|(IR)#=AYR|(IZ)%=AYZ|(IS)%=AYZ|I^(I)^#=IH|+^(I)^+=AY|#:^(I)^+=IH|(I)^+=AY|(IR)=ER|(IGH)=AY4|(ILD)=AY5LD| (IGN)=IHGN|(IGN) =AY4N|(IGN)^=AY4N|(IGN)%=AY4N|(ICRO)=AY4KROH|(IQUE)=IY4K|(I)=IH")
addRules(rules, " (J) =JEY4|(J)=J")
addRules(rules, " (K) =KEY4| (K)N=|(K)=K")
addRules(rules, " (L) =EH4L|(LO)C#=LOW|L(L)=|#:^(L)%=UL|(LEAD)=LIYD| (LAUGH)=LAE4F|(L)=L")
addRules(rules, " (M) =EH4M| (MR.) =MIH4STER| (MS.)=MIH5Z| (MRS.) =MIH4SIXZ|(MOV)=MUW4V|(MACHIN)=MAHSHIY5N|M(M)=|(M)=M")
addRules(rules, " (N) =EH4N|E(NG)+=NJ|(NG)R=NGG|(NG)#=NGG|(NGL)%=NGGUL|(NG)=NG|(NK)=NGK| (NOW) =NAW4|N(N)=|(NON)E=NAH4N|(N)=N")
addRules(rules, " (O) =OH4W|(OF) =AHV| (OH) =OW4|(OROUGH)=ER4OW|#:(OR) =ER|#:(ORS) =ERZ|(OR)=AOR| (ONE)=WAHN|#(ONE) =WAHN|(OW)=OW| (OVER)=OW5VER|PR(O)V=UW4|(OV)=AH4V|(O)^%=OW5|(O)^EN=OW|(O)^I#=OW5|(OL)D=OW4L|(OUGHT)=AO5T|(OUGH)=AH5F| (OU)=AW|H(OU)S#=AW4|(OUS)=AXS|(OUR)=OHR|(OULD)=UH5D|(OU)^L=AH5|(OUP)=UW5P|(OU)=AW|(OY)=OY|(OING)=OW4IHNX|(OI)=OY5|(OOR)=OH5R|(OOK)=UH5K|(OOD)=UH5D|(OO)=UW5|(O)E=OW|(O) =OW|(OA)=OW4| (ONLY)=OW4NLIY| (ONCE)=WAH4NS|(ON')T=OW4N|C(O)N=AA|(O)NG=AO| :^(O)N=AH|I(ON)=UN|#:(ON) =UN|#^(ON)=UN|(O)ST =OW|(OF)^=AO4F|(OTHER)=AH5DHER|R(O)B=RAA|^R(O):#=OW5|(OSS) =AO5S|#:^(OM)=AHM|(O)=AA")
addRules(rules, " (P) =PIY4|(PH)=F|(PEOP)=PIY4P|(POW)=PAW4|(PUT) =PUHT|(P)P=|(P)S=|(P)N=|(PROF.)=PROHFEH4SER|(P)=P")
addRules(rules, " (Q) =KYUW4|(QUAR)=KWOH5R|(QU)=KW|(Q)=K")
addRules(rules, " (R) =AA5R| (RE)^#=RIY|(R)R=|(R)=R")
addRules(rules, " (S) =EH4S|(SH)=SH|#(SION)=ZHUN|(SOME)=SAHM|#(SUR)#=ZHER|(SUR)#=SHER|#(SU)#=ZHUW|#(SSU)#=SHUW|#(SED) =ZD|#(S)#=Z|(SAID)=SEHD|^(SION)=SHUN|(S)S=|.(S) =Z|#:.E(S) =Z|#:^#(S) =S|U(S) =S| :#(S) =Z| (SCH)=SK|(S)C+=|#(SM)=ZUM|#(SN)='ZUN|(STLE)=SUL|(S)=S")
addRules(rules, " (T) =TIY4| (THE) #=DHIY| (THE) =DHAX|(TO) =TUX| (THAT)=DHAET| (THIS) =DHIHS| (THEY)=DHEY| (THERE)=DHEHR|(THER)=DHER|(THESE) =DHIYZ|(THEN)=DHEHN|(THROUGH)=THRUW4|(THOSE)=DHOHZ|(THOUGH) =DHOW|(TODAY)=TUXDEY|(TOMO)RROW=TUMAA5|(TO)TAL=TOW5| (THUS)=DHAH4S|(TH)=TH|#:(TED) =TIXD|S(TI)#N=CH|(TI)O=SH|(TI)A=SH|(TIEN)=SHUN|(TUR)#=CHER|(TU)A=CHUW| (TWO)=TUW|&(T)EN =|(T)=T")
addRules(rules, " (U) =YUW4| (UN)I=YUWN| (UN)=AHN| (UPON)=AXPAON|@(UR)#=UH4R|(UR)#=YUH4R|(UR)=ER|(U)^ =AH|(U)^^=AH5|(UY)=AY5| G(U)#=|G(U)%=|G(U)#=W|#N(U)=YUW|@(U)=UW|(U)=YUW")
addRules(rules, " (V) =VIY4|(VIEW)=VYUW5|(V)=V")
addRules(rules, " (W) =DAH4BULYUW| (WERE)=WER|(WA)SH=WAA|(WA)ST=WEY|(WA)S=WAH|(WA)T=WAA|(WHERE)=WHEHR|(WHAT)=WHAHT|(WHOL)=/HOWL|(WHO)=/HUW|(WH)=WH|(WAR)#=WEHR|(WAR)=WAOR|(WOR)^=WER|(WR)=R|(WOM)A=WUHM|(WOM)E=WIHM|(WEA)R=WEH|(WANT)=WAA5NT|ANS(WER)=ER|(W)=W")
addRules(rules, " (X) =EH4KS| (X)=Z|(X)=KS")
addRules(rules, " (Y) =WAY4|(YOUNG)=YAHNX| (YOUR)=YOHR| (YOU)=YUW| (YES)=YEHS| (Y)=Y|F(Y)=AY|PS(YCH)=AYK|#:^(Y)=IY|#:^(Y)I=IY| :(Y) =AY| :(Y)#=AY| :(Y)^+:#=IH| :(Y)^#=AY|(Y)=IH")
addRules(rules, " (Z) =ZIY4|(Z)=Z")


addRules(rules2, "(A)=|" .. "(!)=.|" .. '(")=.|' .. "(#)=NAEMBAXR|($)=DAALER|(%)=PERSEHN|(&)=AEND|(')=|(*)=STAAR|(+)=PLAHSS|(,)=.|(-)=.|(.)=.|(/)=SLAE4SH|(0)=ZIY4ROW|(1)=WAH4N|(2)=TUW4|(3)=THRIY4|(4)=FOH4R|(5)=FAY4V|(6)=SIH4KS|(7)=SEH4VUN|(8)=EY4T|(9)=NAY4N|(:)=.|(;)=.|(<)=LEHS|(=)=IY4KWULZ|(>)=GREY4TER|(?)=.|(@)=AET|(^)=KAE4RIXT")


local function parseRule(ruleStr)
    local leftParen = string.find(ruleStr, "%(")
    local rightParen = string.find(ruleStr, "%)")
    local equals = string.find(ruleStr, "=")
    
    if not leftParen or not rightParen or not equals then
        return nil
    end
    
    return {
        prefix = string.sub(ruleStr, 1, leftParen - 1),
        match = string.sub(ruleStr, leftParen + 1, rightParen - 1),
        suffix = string.sub(ruleStr, rightParen + 1, equals - 1),
        phoneme = string.sub(ruleStr, equals + 1)
    }
end


function SAMReciter.TextToPhonemes(text)
    if not text or text == "" then
        return {}
    end
    
    
    text = " " .. string.upper(text) .. " "
    print("SAM input: '" .. text .. "' length=" .. #text)
    
    local output = {}
    local pos = 1
    local lastPos = 0
    
    while pos <= #text do
        if pos == lastPos then
            
            print("ERROR: Stuck at position " .. pos .. " char: '" .. string.sub(text, pos, pos) .. "'")
            break
        end
        lastPos = pos
        
        local matched = false
        local currentChar = string.sub(text, pos, pos)
        
        
        for _, ruleStr in ipairs(rules) do
            local rule = parseRule(ruleStr)
            if rule and rule.match ~= "" then
                local matchEnd = pos + #rule.match - 1
                
                if matchEnd <= #text then
                    local matchStr = string.sub(text, pos, matchEnd)
                    
                    if matchStr == rule.match then
                        
                        local prefixMatches = matchesPattern(text, pos - 1, rule.prefix, -1)
                        
                        
                        local suffixMatches = matchesPattern(text, matchEnd + 1, rule.suffix, 1)
                        
                        if prefixMatches and suffixMatches then
                            print(string.format("Matched at pos %d: '%s' -> '%s'", pos, matchStr, rule.phoneme))
                            if rule.phoneme ~= "" then
                                
                                for phoneme in string.gmatch(rule.phoneme, "%S+") do
                                    table.insert(output, phoneme)
                                end
                            end
                            pos = matchEnd + 1
                            matched = true
                            break
                        end
                    end
                end
            end
        end
        
        
        if not matched then
            for _, ruleStr in ipairs(rules2) do
                local rule = parseRule(ruleStr)
                if rule and rule.match ~= "" then
                    local matchEnd = pos + #rule.match - 1
                    if matchEnd <= #text then
                        local matchStr = string.sub(text, pos, matchEnd)
                        if matchStr == rule.match then
                            print(string.format("Punct at pos %d: '%s' -> '%s'", pos, matchStr, rule.phoneme))
                            if rule.phoneme ~= "" and rule.phoneme ~= "." then
                                table.insert(output, rule.phoneme)
                            end
                            pos = matchEnd + 1
                            matched = true
                            break
                        end
                    end
                end
            end
        end
        
        if not matched then
            
            print(string.format("Skip pos %d: '%s'", pos, currentChar))
            pos = pos + 1
        end
    end
    
    print("SAM finished at pos " .. pos .. " of " .. #text)
    print("SAM raw phonemes: " .. table.concat(output, " "))
    
    
    local converted = {}
    for _, phoneme in ipairs(output) do
        local arpabet = SAMtoARPAbet(phoneme)
        if arpabet then
            for _, p in ipairs(arpabet) do
                table.insert(converted, p)
            end
        else
            print("WARNING: No ARPAbet mapping for SAM phoneme: " .. phoneme)
        end
    end
    
    return converted
end


function SAMtoARPAbet(sam_phoneme)
    
    local clean = string.gsub(sam_phoneme, "[0-9/']", "")
    
    
    local mapping = {
        
        ["IY"] = {"IY1"},
        ["IH"] = {"IH1"},
        ["EH"] = {"EH1"},
        ["AE"] = {"AE1"},
        ["AA"] = {"AA1"},
        ["AO"] = {"AO1"},
        ["UH"] = {"UH1"},
        ["UW"] = {"UW1"},
        ["AH"] = {"AH1"},
        ["AX"] = {"AH0"},
        ["ER"] = {"ER1"},
        ["AY"] = {"AY1"},
        ["AW"] = {"AW1"},
        ["OW"] = {"OW1"},
        ["OY"] = {"OY1"},
        ["UX"] = {"AH0"},
        ["EY"] = {"EY1"},
        
        
        ["AAR"] = {"AA1", "R"},
        ["AXR"] = {"AH0", "R"},
        ["EHR"] = {"EH1", "R"},
        ["UHR"] = {"UH1", "R"},
        ["OHR"] = {"AO1", "R"},
        ["HAW"] = {"HH", "AW1"},
        ["YUW"] = {"Y", "UW1"},
        
        
        ["P"] = {"P"},
        ["B"] = {"B"},
        ["T"] = {"T"},
        ["D"] = {"D"},
        ["K"] = {"K"},
        ["G"] = {"G"},
        ["F"] = {"F"},
        ["V"] = {"V"},
        ["TH"] = {"TH"},
        ["DH"] = {"DH"},
        ["S"] = {"S"},
        ["Z"] = {"Z"},
        ["SH"] = {"SH"},
        ["ZH"] = {"ZH"},
        ["HH"] = {"HH"},
        ["H"] = {"HH"},
        ["M"] = {"M"},
        ["N"] = {"N"},
        ["NG"] = {"NG"},
        ["L"] = {"L"},
        ["R"] = {"R"},
        ["W"] = {"W"},
        ["Y"] = {"Y"},
        ["CH"] = {"CH"},
        ["J"] = {"JH"},
        ["JH"] = {"JH"},
        
        
        ["DHIHS"] = {"DH", "IH1", "S"},
        ["DHAX"] = {"DH", "AH0"},
        ["DHEY"] = {"DH", "EY1"},
        ["DHAET"] = {"DH", "AE1", "T"},
        ["DHEHR"] = {"DH", "EH1", "R"},
        ["DHER"] = {"DH", "ER1"},
        ["DHIYZ"] = {"DH", "IY1", "Z"},
        ["DHEHN"] = {"DH", "EH1", "N"},
        ["DHOHZ"] = {"DH", "OW1", "Z"},
        ["DHOW"] = {"DH", "AW1"},
        ["DUWIHN"] = {"D", "UW1", "IH1", "NG"},
        ["TUXDEY"] = {"T", "AH0", "D", "EY1"},
        ["IHN"] = {"IH1", "N"},
        ["AOR"] = {"AO1", "R"},
        ["AHV"] = {"AH0", "V"},
        ["AOL"] = {"AO1", "L"},
        
        
        ["."] = {},
    }
    
    
    local result = mapping[clean]
    if result then
        return result
    end
    
    
    
    local base = string.gsub(clean, "%d", "")
    if mapping[base] then
        return mapping[base]
    end
    
    
    if #clean <= 3 then
        return {clean}
    end
    
    return nil
end

return SAMReciter
