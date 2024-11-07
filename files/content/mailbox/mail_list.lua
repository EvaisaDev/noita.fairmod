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
	bomb = {
		func = function(x, y)
			EntityLoad("data/entities/projectiles/mine_explosion.xml", x, y)
		end,
	},
}
