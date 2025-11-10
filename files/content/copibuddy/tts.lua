-- Fucked up deranged phoneme tts
-- Do not expect this to sound decent in any way.

dofile_once("data/scripts/lib/utilities.lua")


local phoneme_durations = {
    AA0 = 0.090000,
    AA1 = 0.049977,
    AE1 = 0.070023,
    AH0 = 0.040000,
    AH1 = 0.060000,
    AO1 = 0.110023,
    AW1 = 0.219048,
    AY1 = 0.150000,
    B = 0.100045,
    CH = 0.150023,
    D = 0.059955,
    DH = 0.040000,
    EH1 = 0.029025,
    ER0 = 0.190000,
    EY1 = 0.359002,
    F = 0.080000,
    G = 0.040000,
    HH = 0.099955,
    IH0 = 0.040000,
    IH1 = 0.080000,
    IH2 = 0.070023,
    IY0 = 0.089977,
    IY1 = 0.180000,
    JH = 0.160000,
    K = 0.080000,
    L = 0.129977,
    M = 0.040000,
    N = 0.029932,
    NG = 0.059955,
    OW1 = 0.190000,
    OY1 = 0.240000,
    P = 0.040000,
    R = 0.089977,
    S = 0.160000,
    SH = 0.170000,
    T = 0.120000,
    TH = 0.040000,
    UH1 = 0.160000,
    UW1 = 0.190000,
    V = 0.050000,
    W = 0.099955,
    Y = 0.060045,
    Z = 0.070000,
    ZH = 0.139048,
}


local function duration_to_frames(seconds)
    return math.floor(seconds * 60)
end


local TTS = {}
TTS.__index = TTS

function TTS.new()
    local self = setmetatable({}, TTS)
    self.queue = {}
    self.current_phoneme = nil
    self.frames_remaining = 0
    self.is_playing = false
    return self
end


function TTS:add_phoneme(phoneme)
    if phoneme_durations[phoneme] then
        table.insert(self.queue, {
            phoneme = phoneme,
            frames = duration_to_frames(phoneme_durations[phoneme])
        })
    else
        print("Warning: Unknown phoneme: " .. tostring(phoneme))
    end
end


function TTS:speak(phoneme_input)
    
    if type(phoneme_input) == "table" then
        
        for _, phoneme in ipairs(phoneme_input) do
            self:add_phoneme(phoneme)
        end
    else
        
        for phoneme in string.gmatch(phoneme_input, "%S+") do
            self:add_phoneme(phoneme)
        end
    end
    
    if not self.is_playing then
        self:start_playback()
    end
end


function TTS:start_playback()
    if #self.queue > 0 then
        self.is_playing = true
        self:play_next()
    end
end


function TTS:play_next()
    if #self.queue > 0 then
        local next = table.remove(self.queue, 1)
        self.current_phoneme = next.phoneme
        self.frames_remaining = next.frames
        
        
        self:play_phoneme_entity(next.phoneme)
    else
        self.is_playing = false
        self.current_phoneme = nil
    end
end


function TTS:play_phoneme_entity(phoneme)
    
    
    GamePlaySound("mods/noita.fairmod/fairmod.bank", "copibuddytts/" .. phoneme, 0, 0)
end


function TTS:update()
    if self.is_playing then
        self.frames_remaining = self.frames_remaining - 1
        
        if self.frames_remaining <= 0 then
            self:play_next()
        end
    end
end


function TTS:is_active()
    return self.is_playing
end


function TTS:stop()
    self.queue = {}
    self.is_playing = false
    self.current_phoneme = nil
    self.frames_remaining = 0
end


function TTS.get_total_frames(phoneme_string)
    local total = 0
    for phoneme in string.gmatch(phoneme_string, "%S+") do
        if phoneme_durations[phoneme] then
            total = total + duration_to_frames(phoneme_durations[phoneme])
        end
    end
    return total
end


function TTS.text_to_phonemes(text)
    if not text or text == "" then
        return {}
    end
    
    local SAMReciter = dofile_once("mods/noita.fairmod/files/content/copibuddy/sam_reciter.lua")
    local phonemes = SAMReciter.TextToPhonemes(text)
    
    
    return phonemes
end

return TTS
