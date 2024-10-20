local hamisits = {
	"data/ragdolls/longleg/head",
	"data/ragdolls/longleg/leg1",
	"data/ragdolls/longleg/foot1",
	"data/ragdolls/longleg/leg2",
	"data/ragdolls/longleg/foot2",
	"data/ragdolls/longleg/leg3",
	"data/ragdolls/longleg/foot3",
}

--- @param entity entity_id
--- @return boolean
local function has_player_tag(entity)
	local tags = EntityGetTags(entity)
	if not tags then return false end
	for _, tag in ipairs({ "player_unit", "player_projectile", "projectile_player" }) do
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

--- Sets objects value in component
--- @param component_id component_id
--- @param object_name string
--- @param objects {[string]: any}
local function set_values_in_object(component_id, object_name, objects)
	for field, value in pairs(objects) do
		ComponentObjectSetValue2(component_id, object_name, field, value)
	end
end

local function hamis_land()
	local hamis = GetUpdatedEntityID()
	local damage_model = EntityGetFirstComponent(hamis, "DamageModelComponent")
	if not damage_model then return end
	ComponentSetValue2(damage_model, "ragdoll_fx_forced", "NO_RAGDOLL_FILE")
	local x, y = EntityGetTransform(hamis)

	local kill_count = tonumber(GlobalsGetValue("FAIRMOD_HAMIS_KILLED", "1")) or 1

	for i = 1, kill_count do
		for j, body_part in ipairs(hamisits) do
			SetRandomSeed(x + j, y + i)
			local x_off = Random(-10, 10)
			SetRandomSeed(x + i, y + j)
			local y_off = Random(-10, 10)
			EntityLoad("mods/noita.fairmod/vfs/hamis/" .. body_part .. "/longleg.xml", x + x_off, y + y_off)
		end
	end

	GamePlaySound("data/audio/Desktop/animals.bank", "animals/ghost/death", x, y)
	GameCreateParticle("blood", x, y, 50, 100, 100, false)
	GameCreateParticle("material_darkness", x, y, 10, 10, 10, false)
	GlobalsSetValue("FAIRMOD_HAMIS_KILLED", tostring(kill_count + 1))
end

--- Sets flag if was damaged by player
--- @type script_damage_received
local script_damage_received = function(
	damage,
	message,
	entity_thats_responsible,
	is_fatal,
	projectile_thats_responsible
)
	if not EntityGetIsAlive(entity_thats_responsible) then return end

	if is_player_herd(entity_thats_responsible) or has_player_tag(entity_thats_responsible) then
		SetValueBool("fairmod_damaged_by_player", true)
	end
end
damage_received = script_damage_received

--- Hellish creature if killed by player
--- @type script_death
local script_death = function(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
	local died_entity = GetUpdatedEntityID()

	if GetValueBool("fairmod_damaged_by_player", false) then hamis_land() end
end
death = script_death
