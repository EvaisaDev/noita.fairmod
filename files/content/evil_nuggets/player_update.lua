local entity_id = GetUpdatedEntityID()

local x, y = EntityGetTransform(entity_id)

local radius = 128

local gold = EntityGetInRadiusWithTag( x, y, radius, "gold_nugget" ) or {}

for i, entity in ipairs(gold) do
	if(Random(1, 100) < 10 and not EntityHasTag(entity, "nugget_evilified"))then
		local item_component = EntityGetFirstComponent(entity, "ItemComponent")

		if(item_component ~= nil)then
			EntityRemoveComponent(entity, item_component)
		end


		EntityLoadToEntity("mods/noita.fairmod/files/content/evil_nuggets/ai.xml", entity)

		EntityAddTag(entity, "do_not_evil")

	end
	EntityAddTag(entity, "nugget_evilified")
end
