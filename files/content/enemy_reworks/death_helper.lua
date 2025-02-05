--- @class enemy_reworks_helper
local helper = {}

--- @param entity number
--- @return boolean
function helper.has_player_tag(entity)
	local tags = EntityGetTags(entity)
	if not tags then return false end
	for _, tag in ipairs({ "player_unit", "player_projectile", "projectile_player" }) do
		if tags:find(tag) then return true end
	end
	return false
end

--- @param entity number
--- @return boolean
function helper.is_player_herd(entity)
	local genome_comp = EntityGetFirstComponentIncludingDisabled(entity, "GenomeDataComponent")
	if not genome_comp then return false end
	local herd_id = ComponentGetValue2(genome_comp, "herd_id")
	if not herd_id then return false end
	return herd_id == "player"
end

--- Check if the entity is visible
--- @param entity number
--- @return boolean
function helper.is_entity_visible(entity)
	local cam_x, cam_y, cam_w, cam_h = GameGetCameraBounds()
	local ent_x, ent_y = EntityGetTransform(entity)

	-- Offset to account for some boundary around the camera
	local offset = 20
	if ent_x + offset < cam_x or ent_x - offset > cam_x + cam_w then return false end
	if ent_y + offset < cam_y or ent_y - offset > cam_y + cam_h then return false end

	return true
end

--- Returns true if kill is done by player
--- @param entity number
--- @return boolean
function helper.is_player_kill(entity)
	return helper.is_player_herd(entity) or helper.has_player_tag(entity)
end

return helper
