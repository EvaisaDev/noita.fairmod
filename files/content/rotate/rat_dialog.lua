local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

SetRandomSeed(x + GameGetFrameNum(), y)

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	dialog = dialog_system.open_dialog({
		name = "Rat",
		portrait = "mods/noita.fairmod/files/content/rotate/rat_portrait.png",
		typing_sound = "default", -- There are currently 6: default, sans, one, two, three, four and "none" to turn it off, if not specified uses "default"
		text = "Hii!!! Are you michael?",
		options = {
			{
				text = "The one and only!",
				func = function(dialog)
					dialog.show({
						text = "Woww!! Happy birthday!!",
						options = {
							{
								text = "Thank you!!",
								func = function(dialog)
									local interactable_component = EntityGetFirstComponentIncludingDisabled(entity_id, "InteractableComponent")
									-- remove the interactable component so the rat doesn't talk to you again
									EntityRemoveComponent(entity_interacted, interactable_component)

									local rotta_kart = EntityGetWithName("rotta_kart")

									if(rotta_kart and EntityGetIsAlive(rotta_kart))then
										local audio_loop = EntityGetFirstComponentIncludingDisabled(rotta_kart, "AudioLoopComponent")
										ComponentSetValue2(audio_loop, "event_name", "rats/birthday")
										EntitySetComponentIsEnabled(rotta_kart, audio_loop, false)
										EntitySetComponentIsEnabled(rotta_kart, audio_loop, true)
									end
									dialog.close()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Nope, that's not me.",
				func = function(dialog)
					dialog.show({
						text = "Ohh, sorry for the confussle",
						options = {
							{
								text = "No problem!",
							},
						},
					})
				end,
			},
			{
				text = "Leave",
			},
		},
	})
end
