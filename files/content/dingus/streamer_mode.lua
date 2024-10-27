local entity = GetUpdatedEntityID()

local audio_loop = EntityGetFirstComponentIncludingDisabled(entity, "AudioLoopComponent", "music")
if not audio_loop then return end

if(ModSettingGet("noita.fairmod.streamer_mode"))then
	ComponentSetValue2(audio_loop, "event_name", "dingus/loop_streamer")
	EntitySetComponentIsEnabled(entity, audio_loop, false)
	EntitySetComponentIsEnabled(entity, audio_loop, true)
end
