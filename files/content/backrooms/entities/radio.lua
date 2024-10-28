radio_is_on = radio_is_on or false

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	radio_is_on = not radio_is_on
	local entity = GetUpdatedEntityID()

	local audio_loop_off = EntityGetFirstComponentIncludingDisabled(entity, "AudioLoopComponent", "radio_off")
	local audio_loop_on = EntityGetFirstComponentIncludingDisabled(entity, "AudioLoopComponent", "radio_on")

	if radio_is_on then
		EntitySetComponentsWithTagEnabled(entity, "radio_on", true)
		EntitySetComponentsWithTagEnabled(entity, "radio_off", false)
	else
		EntitySetComponentsWithTagEnabled(entity, "radio_on", false)
		EntitySetComponentsWithTagEnabled(entity, "radio_off", true)
	end
end
