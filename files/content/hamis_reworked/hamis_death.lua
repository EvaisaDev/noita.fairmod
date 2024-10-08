--- @param entity entity_id
--- @return boolean
local function entity_has_player_tag(entity)
	local tags = EntityGetTags(entity)
	if not tags then return false end
	for _, tag in ipairs { "player_unit", "player_projectile", "projectile_player" } do
		if tags:find(tag) then return true end
	end
	return false
end

--- @param entity entity_id
--- @return boolean
local function is_player_herd(entity)
	local genome_comp = EntityGetFirstComponentIncludingDisabled(entity, "GenomeDataComponent")
	if not genome_comp then return false end
	local herd_id = ComponentGetValue2(genome_comp, "herd_id")
	if not herd_id then return false end
	return herd_id == "player"
end

--- @type script_damage_received
local script_damage_received = function(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
	if not EntityGetIsAlive(entity_thats_responsible) then return end

	if is_player_herd(entity_thats_responsible) or entity_has_player_tag(entity_thats_responsible) then
		SetValueBool("fairmod_damaged_by_player", true)
	end
end
damage_received = script_damage_received

--- @type script_death
local script_death = function(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
	local died_entity = GetUpdatedEntityID()

	if GetValueBool("fairmod_damaged_by_player", false) then

	end
end
death = script_death
