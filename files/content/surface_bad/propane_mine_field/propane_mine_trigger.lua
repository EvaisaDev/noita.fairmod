function collision_trigger(colliding_entity_id)
	local entity = GetUpdatedEntityID()
	local damage_model_comp = EntityGetFirstComponent(entity, "DamageModelComponent")
	if not damage_model_comp then return end
	ComponentSetValue2(damage_model_comp, "hp", 0.1)
	EntityInflictDamage(entity, 5, "DAMAGE_MELEE", "", "BLOOD_EXPLOSION", 0, 0)
end
