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
	-- NEEDS SPAWN CONDITIOn
	-- NEEDS clear_duplicates IGNORE
	-- NEEDS COPIBUDDY MAIL
	virus = {
		create_letter = true, -- creates a letter that spawns when the mailbox is opened.
		letter_title = "YOURE PWNED!!", -- only used if create_letter is true
		letter_content = [[It's so over for you buddy. I HACKED you. you do NOT want to find out what happens at 99 mails.]],
		letter_sprite = "mods/noita.fairmod/files/content/mailbox/haxx.png", -- only used if create_letter is true
		post_func = function(x, y, index) -- runs after the letter entity is created
			SetRandomSeed(GameGetFrameNum() + index * 435, GameGetFrameNum() * 324)
			-- check how many virus, mails there are
			local mail = ModSettingGet("noita.fairmod.mail") or ""
			local count = 0
			for i in string.gmatch(mail, "virus,") do
				count = count + 1
			end

			if(GameHasFlagRun("virus_finished"))then
				return
			end

			if count >=99 then
				GameAddFlagRun("virus_finished")
				ModSettingSet("noita.fairmod.popups", (ModSettingGet("noita.fairmod.popups") or "") .. "copibuddyinstaller,")
				ModSettingSet("noita.fairmod.mail", string.gsub((ModSettingGet("noita.fairmod.mail") or ""), "virus,", ""))
			else
				for i=1, 5 do
					if Random()>0.5 then
						print("Adding virus mail")
						ModSettingSet("noita.fairmod.mail", (ModSettingGet("noita.fairmod.mail") or "") .. "virus,")
					end
				end
			end
		end,
	},
	hardhat = {
		create_letter = true, -- creates a letter that spawns when the mailbox is opened.
		letter_title = "Hard Hat", -- only used if create_letter is true
		letter_content = [[Hello player,
		I couldn't help but notice you seem to be getting hit by heavy objects all over the place.
		Firstly I would like to say, skill issue. 
		However as I am a kind soul in this letter I have attached a hard hat which should help you survive.
		Please stop dying I am getting bored.
		- Eba]], -- only used if create_letter is true
		letter_sprite = nil, -- only used if create_letter is true
		func = function(x, y)
			local entity = EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/hard_hat/hard_hat.xml", x, y)

			PhysicsApplyForce(entity, Random(-40, 40), -70)
		end,
	},
	nokia = { -- won a free Nokia 3310
		create_letter = true, -- creates a letter that spawns when the mailbox is opened.
		letter_title = "Congratulations! You've Won a FREE Nokia 3310!", -- only used if create_letter is true
		letter_content = [[
			Dear Valued Customer,
			We are excited to announce that you have been selected as the lucky winner of a brand new Nokia 3310! 
			Your prize has been included in the mailbox, note that no warranty is provided for the product.
			If you have any questions, please feel free to contact our support team at copisthings@gmail.com.
			Congratulations once again, and thank you for being a valued customer.

			Best regards,
			The Prize Fulfillment Team
			Not A Scam Company LTD]],
		func = function(x, y) -- runs on mailbox open
			local entity = EntityLoad("mods/noita.fairmod/files/content/payphone/entities/nokia/nokia.xml", x, y)
			PhysicsApplyForce(entity, Random(-150, 150), -150)
		end,

	},
	zipbomb = {
		create_letter = true, -- creates a letter that spawns when the mailbox is opened.
		letter_title = "ILOVEYOU", -- only used if create_letter is true
		letter_content = [[Kindly check the attached LOVELETTER coming from me.]], -- only used if create_letter is true
		letter_sprite = nil, -- only used if create_letter is true
		func = function(x, y)
			local entity = EntityLoad("mods/noita.fairmod/files/content/mailbox/zip_bomb/zip_bomb.xml", x, y)
			local velocity_comp = EntityGetFirstComponentIncludingDisabled(entity, "VelocityComponent")
			if(velocity_comp)then
				local vel_x = math.random(-100, 100)
				local vel_y = -100
				ComponentSetValue2(velocity_comp, "mVelocity", vel_x, vel_y)
			end
		end,
	},
	hampill = { -- illegal drug
		create_letter = true, -- creates a letter that spawns when the mailbox is opened.
		letter_title = "Silkyroad delivery", -- only used if create_letter is true
		letter_content = [[
			SHIP TO: 1 Mountain Blvd.
			Purchaser info: Copi 'c' Things.
			Your order of HÄMIS ENHANCEMENT PILLS have arrived. It is not recommended that non-hamis consume them.
			MAKE SURE TO KICK!]],
		func = function(x, y) -- runs on mailbox open
			local entity = EntityLoad("mods/noita.fairmod/files/content/mailbox/hampill/hampill.xml", x, y)
			local velocity_comp = EntityGetFirstComponentIncludingDisabled(entity, "VelocityComponent")
			if(velocity_comp)then
				local vel_x = math.random(-100, 100)
				local vel_y = -100
				ComponentSetValue2(velocity_comp, "mVelocity", vel_x, vel_y)
			end
		end,
	},
	spam1 = { -- spam
		create_letter = true, -- creates a letter that spawns when the mailbox is opened.
		letter_title = "Azathoth Prime", -- only used if create_letter is true
		letter_content = [[
			SHIP TO: 1 Mountain Blvd.
			Purchaser info: Copi 'c' Things.
			Here are the results. Be careful.]],
		func = function(x, y) -- runs on mailbox open
			local entity = EntityLoad("data/entities/items/pickup/potion.xml", x, y)
		 	RemoveFlagPersistent("spam1")
		end,
	},
	spam2 = { -- spam
		create_letter = true, -- creates a letter that spawns when the mailbox is opened.
		letter_title = "Azathoth Prime", -- only used if create_letter is true
		letter_content = [[
			SHIP TO: 1 Mountain Blvd.
			Purchaser info: John Pork.
			OHOHOHOHOHO!! MERRY CHRISTMASCERATE!!
			I GOT YOU THIS SNOWBALL! FROM THE ANTIARCTIC!]],
		func = function(x, y) -- runs on mailbox open
			local entity = EntityLoad("mods/noita.fairmod/files/content/snowman/snowball_item.xml", x, y)
		 	RemoveFlagPersistent("spam2")
		end,
	},
	spam3 = { -- spam
		create_letter = true, -- creates a letter that spawns when the mailbox is opened.
		letter_title = "Azathoth Prime", -- only used if create_letter is true
		letter_content = [[
			SHIP TO: 1 Mountain Blvd.
			Purchaser info: Eric from Cuba.
			wtf is this strange specimin bro. good luck with it.]],
		func = function(x, y) -- runs on mailbox open
			local copi = EntityLoad("mods/noita.fairmod/files/content/payphone/content/copi/copi_ghost.xml", x, y)
			EntityRemoveTag(copi, "enemy")
			-- spawn poof
			EntityLoad("mods/noita.fairmod/files/content/copibuddy/sprites/poof.xml", x, y)
		 	RemoveFlagPersistent("spam3")
		end,
	},
	spam4 = { -- spam
		create_letter = true, -- creates a letter that spawns when the mailbox is opened.
		letter_title = "Azathoth Prime", -- only used if create_letter is true
		letter_content = [[
			SHIP TO: 1 Mountain Blvd.
			Purchaser info: bonga line.
			Here's some spells I stole. These will help you.]],
		func = function(x, y) -- runs on mailbox open
			dofile("data/scripts/gun/gun.lua")
			for j=1, 5 do
				SetRandomSeed(GameGetFrameNum()+x, 69+j)
				local result = actions[Random(1, #actions)]
				CreateItemActionEntity( result.id, x, y )
			end
		 	RemoveFlagPersistent("spam4")
		end,
	},
}
