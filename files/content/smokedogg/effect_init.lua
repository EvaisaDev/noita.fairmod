local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity(entity_id)

if EntityHasTag(owner, "player_unit") or EntityHasTag(owner, "polymorphed_player") then
	local x, y = EntityGetTransform(entity_id)
	local child_entity = EntityLoad("mods/noita.fairmod/files/content/smokedogg/fade_effect_entity.xml", x, y)
	EntityAddChild(owner, child_entity)
end
