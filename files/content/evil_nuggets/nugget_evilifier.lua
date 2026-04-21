local entity_id = GetUpdatedEntityID()

SetRandomSeed(entity_id, GameGetFrameNum())
if Random(1,10) == 6 then EntityLoadToEntity("mods/noita.fairmod/files/content/evil_nuggets/ai.xml", entity) end