local Popups = {
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
        "Hello, Geoffrey.",
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


    forcePrefab = true,

    Prefabs = {
        {
            EXE = "POPUP.EXE",
            MESSAGE = "This is an @example@ of what a %message%(1) |might| look like! newline *White* *text.*",
            CLICK_EVENTS = {
                function(self)
                    print("click registered! :D")
                end
            },
            OPEN_FUNCTION = function(self)
                print("Window opened -v-")
            end,

            --IS_OPEN_FUNCTION = function() end, --runs every frame, would recommend avoiding this

            custom_close_counter = 0,

            CLOSE_FUNCTION = function(self)
                print("Counter: " .. self.custom_close_counter)
                self.custom_close_counter = self.custom_close_counter + 1
                if self.custom_close_counter == 9 then
                    self.CUSTOM_X = nil
                elseif self.custom_close_counter >= 10 then
                    self.cannotClose = false 
                    self.disableSound = false
                    print("Player closed the window >:|")
                end
            end,

            disableSound = false,
            cannotClose = true,
            CUSTOM_9PIECE = "mods/noita.fairmod/files/content/popups/custom_9piece.png",
            CUSTOM_X = "mods/noita.fairmod/files/content/popups/custom_button.png",
        },
    }
}

return Popups