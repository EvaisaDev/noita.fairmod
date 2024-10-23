local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

SetRandomSeed(x + GameGetFrameNum(), y)

local tips = {
	"I think I saw a snail earlier!",
	"You can get a cool mask at the entrance!\nI didn't get one because I am already cute!!",
	"Did you know that you can get a free information booklet here?",
	"99% of gamblers quit before they win big!",
	"Did you know we added a helpful UI that gives you lots of info?\nPay attention to the right side of the screen!",
	"If you see spells that looks wrong..\nIgnore them! They are clearly bugs!!",
	"Did you know you can fish up all kinds of stuff?",
	"Perks sometimes have different effects!\nMake sure you inspect them closely!!",
}

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	dialog = dialog_system.open_dialog({
		name = "Information Hämis",
		portrait = "mods/noita.fairmod/files/content/information_kiosk/portrait.png",
		typing_sound = "default", -- There are currently 6: default, sans, one, two, three, four and "none" to turn it off, if not specified uses "default"
		text = "Heyyyy!! Welcome to this wonderful place!\nWhat can I do for you today?",
		options = {
			{
				text = "Ask for some tips",
				enabled = function(stats)
					return true
				end,
				func = function(dialog)
					dialog.show({
						text = tips[Random(1, #tips)],
						options = {
							{
								text = "Leave",
							},
						},
					})
				end,
			},
			{

				text = "Could I get an information booklet?",
				enabled = function(stats)
					return true
				end,
				func = function(dialog)
					dialog.show({
						text = "Sorry those are out of stock!\nHave a great day!!",
						options = {
							{
								text = "Leave",
							},
						},
					})
					-- entityload the booklet
				end,
			},
			{
				text = "Leave",
			},
		},
	})
end
