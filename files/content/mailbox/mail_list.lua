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
	bomb = {
		func = function(x, y)
			EntityLoad("data/entities/projectiles/mine_explosion.xml", x, y)
		end,
	},
}
