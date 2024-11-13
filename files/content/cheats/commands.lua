
return {
	{
		command = "ngplus",
		name = "New Game+",
		description = "Warped to ng+ [%s]",
        args = {
            {
                type = "string",
                allow_nil = true,
            },
        },
		func = function(player, input_args)
			dofile("data/scripts/newgame_plus.lua")
			do_newgame_plus(input_args[1])
		end,
	},
    {
        command = "godprint",
        not_cheat = true,
        devmode = false, --default is true for commands
        args = {
            {
                type = "string",
            },
            {
                type = "string",
                allow_nil = true,
            },
        },
        func = function(player, input_args)
            GamePrintImportant(input_args[1], input_args[2])
        end
    }
}