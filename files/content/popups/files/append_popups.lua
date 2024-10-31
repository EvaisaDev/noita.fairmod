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
		"Become a Noitillionaire Today!",
	},

	-- [IMG]path = image NOTE must be start of line and only works alone
	-- [GIF]path = animated image --NOT FUNCTIONAL NOR IMPLEMENTED IN ANY CAPACITY, SOMETHING TO WORK ON
	-- @@ = rainbow
	-- ** = white
	-- || = RAGE

	Random_Ads = {
		"noita NOITA *Noita* |noita| @Noita@ noita NOITA @Noita@ *Noita* noita *NOITA* *noita* Noita @Noita@ noita |noita| *Noita* @noita@ noita @Noita@ noita *Noita* |NOITA| @NOITA@ Noita noita @noita@ *noita* Noita *noita* *NOITA* noita",
		"*STOP* doing *ORBS!* newline *COLLECTABLES* were not supposed to be given *UNLOCKS* newline YEARS of *SEEDSEARCH* yet no *LEGIT* @34@ *ORB* FOUND for going higher than *SEVEN* *ORBS* newline Wanted to go higher anyway for a laugh? we had a tool for that: it was called @COPIS@ @CHEAT@ @MENU@ newline 'yes please give me @CLOUD@ @OF@ @THUNDER'@ - STATEMENTS DREAMED UP BY THE |UTTERLY.| |DERANGED.|",
		[[Are you *kidding* ??? What the |****| are you talking about man ? You are a *biggest* |looser| i ever seen in my life ! You was casting *firebolt* in your *mines* when i was casting @copis@ @things@ |die| much more faster then *you!* You are not *proffesional*, because *proffesionals* knew how to *build* *wands* and |not| |cheese,| you are like a |hiisi| *crying* after i |beat| |you!| Be *brave*, be *honest* to yourself and stop this |trush| |talkings!!!| *Everybody* know that i am @very@ @good@ @modder,@ i can make *any* *spell* in the world in *single* *sitting!* And *"g"raham* *"b"urger* is |nobody| for me, just a *modder* who are |nerfing| every single time when *modding,* ( remember what you say about @Mana@ @Heart@ ) !!! Stop playing with my name, i deserve to have a @good@ @name@ during whole my *modding* carrier, I am *Officially* *inviting* you to |MOD| |JAM|  with the |Prize| |fund!| Both of us will @invest@ @5000$@ and *winner* takes it @all!@ I suggest all other people who's intrested in this situation, just take a look at *my* *results* in @2022@ and @2023@ @github,@ and that should be enough... No need to listen for |every| |crying| |hesii,| @Copernicus@ @Things@ is *always* *play* @Fair@ ! And if someone will continue *Officially* talk about me like that, *we* *will* |meet| |in| |Court!| @God@ @bless@ @with@ @true!@ *True* will |never| |die| ! Liers will |kicked| |off...|]],
		"imagine having to start with *2x* *gc* + the |demolitionist| *perk* from @copi's@ @things@ i think??? and then *giga* *nuke* or *giga* *holy* *bomb*",
		"[IMG]Mods/noita.fairmod/files/content/popups/why_are_you_looking_here.png",
		"hello? can anyone hear me?? hello???? please i dont know @DOWNLOAD@ @COPI'S@ @THINGS@ *DOWNLOAD* *COPI'S* *THINGS* @DOWNLOAD@ @COPI'S@ @THINGS@ |DOWNLOAD| |COPI'S| |THINGS!!!!|",
		"note to self: add more trojans to popups",
	},

	forcePrefab = false, --do this and delete all other prefabs if you need to test a specific popup or something.

	Prefabs = {
		{ -- very in depth example of what you can do:
			EXE = "EVIL_POPUP.EXE", --leaving this blank will pick randomly from the Random_EXEs table
			MESSAGE = "*I* *am* *an* |EVIL| *message* *that* *can* |*only*| *be* *closed* *by* *one* *who* *is* @pure@ @of@ @heart@ |*.*| |*.*| |*.*| newline %or% %clicks% %this% %cool-ass% %link%", --leaving this blank will pick randomly from the Random_Ads table

			CLICK_EVENTS = { --click events should be in order, so the first hyperlink in a text will run the first function, second runs the second etc.
				function(self) --if the hyperlink is clicked
					self.hyperlink_clicked = true
					self.disableSound = false
					self.CUSTOM_9PIECE = nil
					self.CUSTOM_9PIECE_BAR = nil
					self.CUSTOM_X = nil
				end,
				function(self)
					print("function 2!!!")
					self.CLICK_EVENTS[1](self)
				end,
				function(self)
					print("function 3!!!")
					self.CLICK_EVENTS[1](self)
				end,
				function(self)
					print("function 4!!!")
					self.CLICK_EVENTS[1](self)
				end,
				function(self)
					print("function 5!!!")
					self.CLICK_EVENTS[1](self)
				end,
			},
			OPEN_FUNCTION = function(self) --OPEN_FUNCTION runs only once when the window is opened
				print("Window opened -v-")
			end,

			--IS_OPEN_FUNCTION = function() end, --runs every frame, would recommend you avoid using this

			hyperlink_clicked = false, --you can put custom variables in here and they will be saved accordingly

			CLOSE_FUNCTION = function(self) --returning false AND ONLY FALSE will not close the window. Anything else, such as not returning at all, will close the window still.
				if not self.hyperlink_clicked then return false end
				print("Player closed the window >:|")
			end,

			disableSound = true, --this disables the sound made when you click the X button
			CUSTOM_9PIECE = "mods/noita.fairmod/files/content/popups/custom_9piece.png",
			CUSTOM_9PIECE_BAR = "mods/noita.fairmod/files/content/popups/custom_9piecebar.png",
			CUSTOM_X = "mods/noita.fairmod/files/content/popups/custom_button.png",
		}, --this is an example that shows basically everything you can do

		{ --and here's a better example showcasing a much smaller effect
			MESSAGE = "YOU'RE STEAM ID IS 765611steamid! \n Stay Safe! :thumbsup:",
			OPEN_FUNCTION = function(self)
				self.MESSAGE =
					self.MESSAGE:gsub("steamid", string.format("%.0f", math.random(10000000000, 99999999999))) --generate a random number and gsub it into self.MESSAGE
			end,
		}, -- i hope these help, have fun!
	},
}

return Popups
