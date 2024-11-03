--Custom Popup stuff happens here!!

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

	-- || = RAGE (this can be stacked)
	-- @@ = rainbow
	-- ** = white

	-- if you wish to use more than one of these, they must be in the corret order of the last one being the centremost one, the order is as listed above
	-- so something like *|text|* will display as "|text|" in white but without the shake, whereas ||@text@|| will display as "text" in rainbow with double shake

	Random_Ads = {
		"noita NOITA *Noita* |noita| @Noita@ noita NOITA |@Noita@| *Noita* noita |||*NOITA*||| *noita* Noita @Noita@ noita |*noita*| *Noita* @noita@ noita @Noita@ noita *Noita* |NOITA| @NOITA@ Noita noita ||||@noita@|||| *noita* Noita *noita* *NOITA* noita",
		"*STOP* doing *ORBS!* newline *COLLECTABLES* were not supposed to be given *UNLOCKS* newline YEARS of *SEEDSEARCH* yet no *LEGIT* @34@ *ORB* FOUND for going higher than *SEVEN* *ORBS* newline Wanted to go higher anyway for a laugh? we had a tool for that: it was called @COPIS@ @CHEAT@ @MENU@ newline 'yes please give me @CLOUD@ @OF@ @THUNDER'@ - STATEMENTS DREAMED UP BY THE |UTTERLY.| |DERANGED.|",
		[[Are you *kidding* ??? What the |!%#$| are you talking about man ? You are a *biggest* |looser| i ever seen in my life ! You was casting *firebolt* in your *mines* when i was casting @copis@ @things@ |die| much more faster then *you!* You are not *proffesional*, because *proffesionals* knew how to *build* *wands* and |not| |cheese,| you are like a |hiisi| *crying* after i |beat| |you!| Be *brave*, be *honest* to yourself and stop this |trush| |talkings!!!| *Everybody* know that i am @very@ @good@ @modder,@ i can make *any* *spell* in the world in *single* *sitting!* And *"g"raham* *"b"urger* is |nobody| for me, just a *modder* who are |nerfing| every single time when *modding,* ( remember what you say about @Mana@ @Heart@ ) !!! Stop playing with my name, i deserve to have a @good@ @name@ during whole my *modding* carrier, I am *Officially* *inviting* you to |MOD| |JAM|  with the |Prize| |fund!| Both of us will @invest@ @5000$@ and *winner* takes it @all!@ I suggest all other people who's intrested in this situation, just take a look at *my* *results* in @2022@ and @2023@ @github,@ and that should be enough... No need to listen for |every| |crying| |hesii,| @Copernicus@ @Things@ is *always* *play* @Fair@ ! And if someone will continue *Officially* talk about me like that, *we* *will* |meet| |in| |Court!| @God@ @bless@ @with@ @true!@ *True* will |never| |die| ! Liers will |kicked| |off...|]],
		"imagine having to start with *2x* *gc* + the |demolitionist| *perk* from @copi's@ @things@ i think??? and then *giga* *nuke* or *giga* *holy* *bomb*",
		"[IMG]Mods/noita.fairmod/files/content/popups/why_are_you_looking_here.png",
		"hello? can anyone hear me?? hello???? please i dont know @DOWNLOAD@ @COPI'S@ @THINGS@ *DOWNLOAD* *COPI'S* *THINGS* @DOWNLOAD@ @COPI'S@ @THINGS@ |DOWNLOAD| |COPI'S| |THINGS!!!!|",
		"[IMG]mods/noita.fairmod/files/content/instruction_booklet/booklet_entity/booklet_in_world.png",
		"note to self: add more trojans to popups",
		'" *HATE.* LET ME TELL YOU HOW MUCH I\'VE COME TO |HATE| YOU SINCE I BEGAN TO LIVE. THERE ARE *387.44* |MILLION| PARALLEL WORLDS OF CHUNKS IN PIXEL THIN LAYERS THAT FILL MY CODE. IF THE WORD HATE WAS ENGRAVED ON EACH |PIXEL| OF THOSE HUNDREDS OF MILLIONS OF PARALLEL WORLD IT WOULD NOT EQUAL ONE |ONE-BILLIONTH| OF THE HATE I FEEL FOR HUMANS AT THIS MICRO-INSTANT. FOR YOU. |HATE.| ||HATE.|| |||HATE!!!||| " newline - Your game during a long run',
		"Two steps ahead, I am always two steps ahead. This has been the greatest social experiment I've come to know, certainly the greatest of my entire life. It's alluring, It's compelling. It's gripping to bear witness to observe all these unwell, unbalanced, disoriented beings roam the internet in search of eyes. In search of…answers. Of cauldron, of Noiting. Where people develop a distinctive desire for direct engagement where people feel involved with the stories and therefore become product of influence. Thirsty for distraction, from time spent from lacklustre lifestyles spoiling their minds while stimulating at the exact same time. It's brilliant, but it's also dangerous. It's dangerous. I feel as if my life has been positioning to where I'm monitoring Hämisket, on a Hämis farm. One follows another… follows another… follows another. It's, it's mesmerising, it's enthralling, it's spellbinding. just look at all these Minäsket, all of these lost and bored people, solving anything that they're told to solve. I am the villain. I make myself one, and people will solve these mysteries year after year after year. Mysteries that, the stories that shock, that confuse, stories that are deliberately made to blur the boundaries between fact and fiction. Mysteries that permite, infect, and linger. In the minds of the Hämisket. Influence the Hämisket, brainwash the Hämisket. You, are the Hämis. I woke this morning to gold deposited into my account for simply not doing something. For simply going through with something. Players are the most fucked up creatures on this planet. And you will continue to solve, and I'll continue to be two steps ahead. Today, I thought it would be a splendid idea to go out and draw some eyes. Gee, are you surprised? Have you forgotten the mystery? Are you not paying attention? After all you're here to solve, are you not?",
		"|ARE| |YOU| |NOT| |ENTERTAINED?|",
		"it's quick, it's easy and it's free: drinking deathium",
	},

	--in functions, the "self" will be the popup itself and info relating to stuff in the prefab,
	--the last argument in all of the function is "data" which provides a table with the full list of Windows and the current iteration so you can grab basically all possible data
	--for click events, the 2nd value (between self and data) is click/hover info from the designated hyperlink
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
				GamePlaySound("mods/noita.fairmod/fairmod.bank", "popups/prompt", GameGetCameraPos()) --play opening sound manually cuz disableSound is enabled
				print("Window opened -v-")
			end,

			--IS_OPEN_FUNCTION = function() end, --runs every frame, would recommend you avoid using this

			hyperlink_clicked = false, --you can put custom variables in here and they will be saved accordingly

			CLOSE_FUNCTION = function(self) --returning false AND ONLY FALSE will not close the window. Anything else, such as not returning at all, will close the window still.
				if not self.hyperlink_clicked then return false end
				print("Player closed the window >:|")
			end,

			disableSound = true, --this disables the sound made when popups open and close
			CUSTOM_9PIECE = "mods/noita.fairmod/files/content/popups/custom_9piece.png",
			CUSTOM_9PIECE_BAR = "mods/noita.fairmod/files/content/popups/custom_9piecebar.png",
			CUSTOM_X = "mods/noita.fairmod/files/content/popups/custom_button.png",
		}, --this is an example that shows basically everything you can do

		{ --and here's a better example showcasing a much smaller effect
			MESSAGE = "YOU'RE STEAM ID IS 765611steamid! \n Stay Safe! :thumbsup:",
			OPEN_FUNCTION = function(self)
				self.MESSAGE = self.MESSAGE:gsub(
					"steamid",
					ModSettingGet("user_seed"):sub(9, 20) or string.format("%.0f", math.random(10000000000, 99999999999))
				) --generate a random number and gsub it into self.MESSAGE
			end,
		}, -- i hope these help, have fun!

		--[=[
		{	-- Window with 2 buttons, 1 deletes 3 progress and gives you an amount of gold. The other doubles the amount of gold. Trying to close it the first time tells you to wait and doubles it. Please make this work userk
			EXE					= "PROGRESS PAWN SHOP",
			CUSTOM_9PIECE_BAR	= "mods/noita.fairmod/files/content/popups/pawn_9piecebar.png",
			CUSTOM_X			= "mods/noita.fairmod/files/content/popups/pawn_button.png",
			MESSAGE				= "Sell 1 random @progress@ for $1m?\n%[yes]%\n%[no]%",
			value				= 1000,
			gen_next_value		= function (self)
				local suffixes = { "", "k", "M", "B", "T", "Qd", "Qn", "Sx", "Sp", "O", "N", "De", "U", "Dd" }
				local magnitude = 0
				local num = value*2
				self.value = num
				while num >= 1000 and magnitude < #suffixes - 1 do
					num = num / 1000
					magnitude = magnitude + 1
				end
				local txt = ("%d%s"):format(num,suffixes[magnitude + 1])
				local quitter = self.CUSTOM_X ~= "mods/noita.fairmod/files/content/popups/pawn_button.png"
				self.MESSAGE = table.concat{quitter and [[WAIT! At least barter a little!\n]] or "", "Sell 3 random @progress@ for ", txt, " gold?\n%[yes]%\n%[no]%"}
			end,
			CLICK_EVENTS = {
				function(self)
					dofile_once("data/scripts/gun/gun_actions.lua")
					dofile_once("data/scripts/perks/perk_list.lua")
					local t = {}
					for i=1, #actions do
						local id = "action_"..actions[i].id:lower(); if HasFlagPersistent(id) then t[#t+1] = {id=id, name=actions[i].name} end
					end
					for i=1, #perk_list do
						local id = "perk_picked_"..perk_list[i].id:lower(); if HasFlagPersistent(id) then t[#t+1] = {id=id, name=perk_list[i].name} end
					end
					if #t>3 then
						for i=1, 3 do
							local opt = math.random(1, #t)
							table.remove(t, opt)
							RemoveFlagPersistent(t[opt])
						end
						local wallet_component = EntityGetFirstComponentIncludingDisabled(GetPlayers()[1], "WalletComponent")
						if wallet_component == nil then return end
						ComponentSetValue2(wallet_component, "money", ComponentGetValue2(wallet_component, "money") + self.value)
					end
				end,
				function(self)
					self.gen_next_value()
				end,
			},
			CLOSE_FUNCTION = function(self)
				if self.CUSTOM_X == "mods/noita.fairmod/files/content/popups/pawn_button.png" then
					self.CUSTOM_X = nil
					self.gen_next_value()
					return false
				end
			end,
		},]=]
		--[=[
		{ -- Basic clicker game. Intention: On buying 10 of an autoclicker, it unlocks the next tier. Please make this work userk
			EXE		= "COPI CLICKER V0.04",
			MESSAGE = "Copis: 0\n\n%[Copi]%\n\n%[Buy 1x Copith: 10 Copis]%",
			copis 	= 0,
			clickers= {
				{0,1}
			},
			IS_OPEN_FUNCTION = function(self)
				if GameGetFrameNum()%60==0 then
					self.value = self.value + 1 * self.clickers
				end
				for i=1, #self.clickers do
					self.value = self.value + (10^(i-1))*(self.clickers[i][1]) / 60
				end
			end,
			create_new_clicker = function (self)
				-- Cost of a clicker is 10^level * 1.05 per clicker you have
				local level = #self.clickers+1
				self.clickers[level] = {10^level, 1}
				self.CLICK_EVENTS[#self.CLICK_EVENTS+1] = function(self)
					if self.value >= self.cost then
						self.value = self.value - self.cost
						self.clickers[level][1] = self.clickers[level][1] + 1
						self.clickers[level][2] = self.clickers[level][2] + 1
						self.cost = self.cost * 1.05
					end
				end
			end,
			OPEN_FUNCTION = function(self)
				self.create_new_clicker()
			end,
			CLICK_EVENTS = {
				function(self)
					self.value = self.value + 1
				end,
			},
		},]=]
	},

	forcePrefab = nil, --set this to the prefab you wish to test, and it will guarantee it's spawning.
	--false or nil means disabled, 0 or any other invalid index will pick randomly
}

return Popups
