local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

SetRandomSeed(x + GameGetFrameNum(), y)

local function dialog_thank_you(dialog)
	local interactable_component = EntityGetFirstComponentIncludingDisabled(entity_id, "InteractableComponent")
	-- remove the interactable component so the rat doesn't talk to you again
	if interactable_component then EntityRemoveComponent(entity_id, interactable_component) end

	local rotta_kart = EntityGetWithName("rotta_kart")

	if rotta_kart and EntityGetIsAlive(rotta_kart) then
		local audio_loop = EntityGetFirstComponentIncludingDisabled(rotta_kart, "AudioLoopComponent")
		if audio_loop then
			ComponentSetValue2(audio_loop, "event_name", ModSettingGet("noita.fairmod.streamer_mode") and "rats/birthday_streamer" or "rats/birthday")
			EntitySetComponentIsEnabled(rotta_kart, audio_loop, false)
			EntitySetComponentIsEnabled(rotta_kart, audio_loop, true)
		end
		GameAddFlagRun("fairmod_rat_birthday_dialogue")
		EntityLoad("mods/noita.fairmod/files/content/rat_wand/rat_wand.xml", 425, -120)
	end
	dialog.close()
end

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	if EntityHasTag(entity_interacted, "viewing") or GameHasFlagRun("fairmod_dialog_interacting") then return end
	if GameHasFlagRun("fairmod_interacted_with_anything_this_frame") then return end
	GameAddFlagRun("fairmod_interacted_with_anything_this_frame")
	GameAddFlagRun("fairmod_dialog_interacting")

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
								func = dialog_thank_you,
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
		on_closed = function()
			GameRemoveFlagRun("fairmod_dialog_interacting")
		end,
	})
end
