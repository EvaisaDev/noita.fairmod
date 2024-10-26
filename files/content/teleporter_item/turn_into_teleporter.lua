function material_area_checker_success()
	local entity = GetUpdatedEntityID()
	local x, y = EntityGetTransform(entity)
	EntityLoad("mods/noita.fairmod/files/content/teleporter_item/item.xml", x, y)
	EntityKill(entity)
end
