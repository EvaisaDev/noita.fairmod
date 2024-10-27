local entity_id = GetUpdatedEntityID()
local dmc = EntityGetFirstComponent(entity_id, "DamageModelComponent") --[[@cast dmc number]]
ComponentSetValue2(dmc, "invincibility_frames", 120)
ComponentSetValue2(dmc, "hp", 2147483647000)
ComponentSetValue2(dmc, "max_hp", 2147483647000)
ComponentSetValue2(dmc, "max_hp_cap", 0)

local audio_loop = EntityGetFirstComponentIncludingDisabled(entity_id, "AudioLoopComponent", "music")
ComponentSetValue2(audio_loop, "m_volume", math.max(0.0001, (ComponentGetValue2(audio_loop, "m_volume") or 1) - 0.005))
