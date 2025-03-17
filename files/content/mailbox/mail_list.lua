return {
	welcome = {
		create_letter = true, -- creates a letter that spawns when the mailbox is opened.
		letter_title = "Welcome", -- only used if create_letter is true
		letter_content = [[
		Welcome to the Fair Mod!
		I'm sure you will die repeatedly, but don't let that discourage you.
		Also wear a helmet.
		- Eba]], -- only used if create_letter is true
		letter_sprite = nil, -- only used if create_letter is true
		letter_func = function(letter_entity) -- runs after the letter entity is created

		end,
		func = function(x, y) -- runs on mailbox open

		end,
	},
	copi = {
		create_letter = true, -- creates a letter that spawns when the mailbox is opened.
		letter_title = "A letter from Copi", -- only used if create_letter is true
		letter_content = [[
		hi its me copi have you been picking up the phone im trying to talk to you :)
		good luck!!
		- Copi]], -- only used if create_letter is true
		letter_sprite = nil, -- only used if create_letter is true
		letter_func = function(letter_entity) -- runs after the letter entity is created

		end,
		func = function(x, y) -- runs on mailbox open

		end,
	},
	copi_evil = {
		create_letter = true, -- creates a letter that spawns when the mailbox is opened.
		letter_special = 1,
		letter_title = "Take Control of your Life Today!", -- only used if create_letter is true
		letter_content = [[
		I know you've been struggling... dying to all kinds of things...
		I can help you. I've rigged the game, stacked the cards against you. But?
		Take this note, pick up the phone while holding it. Play along, and you
		can win for once. ;)
		- Copi]], -- only used if create_letter is true
		letter_sprite = nil, -- only used if create_letter is true
		letter_func = function(letter_entity) -- runs after the letter entity is created
			EntityAddTag(letter_entity, "glue_NOT")
			EntityAddTag(letter_entity, "grow")
		end,
		func = function(x, y) -- runs on mailbox open
			RemoveFlagPersistent("fairmod_evil_letter_buffer")
			GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/barren_puzzle_completed/create", x, y)
		end,
	},
	gamebro = {
		create_letter = true, -- creates a letter that spawns when the mailbox is opened.
		letter_title = "GameBrokenwand", -- only used if create_letter is true
		letter_content = [=[
		So ok. Fairmod is this mod that	a lot of hammies seem hella pumped of.
		And this mod is sitting on my mods folder for review, so I'm like, yeah ham
		I'll write something. But I don't know. I'm like, so this is about fairness
		or some ARG shit? That's fine, I'm sure that's like fucking dynamite in a 
		spell inventory for some ukkos. But all I'm saying is, when do you get to
		CAST anything? While you're playing fair or some shit, are you ever in jeopardy
		of getting shuffle on your wand or whatever from busting out, and I quote, 
		"the mad spells all wicked up-ins"? Know what I'm saying, Bro-Yo Ma? I didn't
		actually play this mod, but I gave it 1.5 hammies out of 5 hammies to keep it real.
		Rating for: Fairmod
		[#][\][ ][ ][ ]]=],
		letter_sprite = "mods/noita.fairmod/files/content/mailbox/gamebrokenwand.png", -- only used if create_letter is true
		letter_func = function(letter_entity) -- runs after the letter entity is created
		end,
		func = function(x, y) -- runs on mailbox open

		end,
	},
	fishbad = {
		create_letter = true,
		letter_title = "About the Fish...",
		letter_content = [[
		Hey, have you ran into any fishy business? You have, right?
		Word of advice, don't kill too many of the peaceful ones or
		the Gods will be upset.

		Those flying fish though? They can go straight to hell!
		- The Wandering Adventurer]],
	},
	bomb = {
		func = function(x, y)
			EntityLoad("data/entities/projectiles/mine_explosion.xml", x, y)
		end,
	},
	soma_prime = {
		func = function(x, y)
			RemoveFlagPersistent("fairmod_soma_prime_letter")
			EntityLoad("mods/noita.fairmod/files/content/immortal_snail/gun/entities/soma/soma.xml", x, y)
		end,
		create_letter = true, -- creates a letter that spawns when the mailbox is opened.
		letter_title = "A weapon from beyond the Void", -- only used if create_letter is true
		letter_content = [[
		What a waste. Your scarred robe comes to beg one more!?
		You will never pry the Sampo from the clutches of its rightful owner!
		I, Captain Kolmisilma, have ascended, and the New Game salutes me!
		You will die a lifetime, an eternity, a parallel universe of deaths before 
		you are blessed by the endlessness of this place, this paradise.
		I will never close an eye to the gift that is the New Game,
		even as my flesh hardens, a wall of cursed rock awaits my joining!
		- Captain Kolmisilma]], -- only used if create_letter is true
	},
	virus = {
		create_letter = true, -- creates a letter that spawns when the mailbox is opened.
		letter_title = "YOURE PWNED!!", -- only used if create_letter is true
		letter_content = [=[It's so over for you buddy. I HACKED you. you do NOT want to find out what happens at 99 mails.]=],
		letter_sprite = "mods/noita.fairmod/files/content/mailbox/haxx.png", -- only used if create_letter is true
		letter_func = function(letter_entity) -- runs after the letter entity is created
			SetRandomSeed(GameGetFrameNum(), letter_entity)
			if string.gsub(ModSettingGet("noita.fairmod.mail"), "virus,", "virus,") >=99 then
				ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "copibuddy,")
				string.gsub(ModSettingGet("noita.fairmod.mail"), "virus,", "")
			else
				for i=1, 3 do
					if Random()>0.5 then
						ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "virus,")
					end
				end
			end
		end,
	},
	-- @EBA ADD A COPIBUDDY MAIL :)))))
}
