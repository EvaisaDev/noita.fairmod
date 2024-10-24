return {
	{
		name = "Unknown Caller",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		text = [[Hello!! Is your refridgerator running?]],
		options = {
			{
				text = "I.. Think so?",
				func = function(dialog)
					dialog.show({
						text = [[Well you better go catch it!!! HAHAHAHAHAHA!!!]],
						options = {
							{
								text = "Goodbye",
								func = function(dialog)
									dialog.close()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Who is this?",
				func = function(dialog)
					dialog.show({
						text = [[Well you better go catch it!!! HAHAHAHAHAHA!!!]],
						options = {
							{
								text = "Goodbye",
								func = function(dialog)
									dialog.close()
								end,
							},
						},
					})
				end,
			},
			{
				text = "I'm calling the police.",
				func = function(dialog)
					dialog.show({
						text = [[Well you better go catch it!!! HAHAHAHAHAHA!!!]],
						options = {
							{
								text = "Goodbye",
								func = function(dialog)
									dialog.close()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Goodbye",
				func = function(dialog)
					dialog.close()
				end,
			},
		},
	}
}