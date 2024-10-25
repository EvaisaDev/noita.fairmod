return {
	{
		name = "Unknown Caller",
		portrait = "mods/noita.fairmod/files/content/payphone/portrait_blank.png",
		typing_sound = "default",
		text = [[Hello!! Is your refrigerator running?]],
		options = {
			{
				text = "I.. Think so?",
				func = function(dialog)
					dialog.show({
						text = [[Well you better go catch it!!! HAHAHAHAHAHA!!! {@func disconnected}
						(They hung up...)]],
						options = {
							{
								text = "...",
								func = function(dialog)
									hangup()
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
						text = [[Well you better go catch it!!! HAHAHAHAHAHA!!! {@func disconnected}
						(They hung up...)]],
						options = {
							{
								text = "...",
								func = function(dialog)
									hangup()
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
						text = [[Well you better go catch it!!! HAHAHAHAHAHA!!! {@func disconnected}
						(They hung up...)]],
						options = {
							{
								text = "...",
								func = function(dialog)
									hangup()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Goodbye",
				func = function(dialog)
					hangup()
				end,
			},
		},
	}
}