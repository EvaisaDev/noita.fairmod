local entity_id = GetUpdatedEntityID()

local animal_ai_comp = EntityGetFirstComponent(entity_id, "AnimalAIComponent")
if not animal_ai_comp then return end

ComponentSetValue2(animal_ai_comp, "attack_ranged_frames_between", 80)
ComponentSetValue2(animal_ai_comp, "attack_ranged_entity_count_max", 3)

local damage_model_comp = EntityGetFirstComponent(entity_id, "DamageModelComponent")
if not damage_model_comp then return end

ComponentSetValue2(damage_model_comp, "blood_material", "fairmod_hamisium")
ComponentSetValue2(damage_model_comp, "blood_spray_material", "fairmod_hamisium")
ComponentSetValue2(damage_model_comp, "ragdoll_material", "fairmod_hamis_meat")
