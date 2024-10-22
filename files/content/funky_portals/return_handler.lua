function interacting(entity_who_interacted, entity_interacted, interactable_name)
	local from_x, from_y = EntityGetTransform(entity_who_interacted)
	EntityLoad("data/entities/particles/teleportation_source.xml", from_x, from_y)

	local target_x = from_x
	local target_y = from_y
	local variable_storage_comps = EntityGetComponent(entity_interacted, "VariableStorageComponent")
	if variable_storage_comps ~= nil then
		for i, comp in ipairs(variable_storage_comps) do
			local name = ComponentGetValue2(comp, "name")
			if name == "target_x" then
				target_x = ComponentGetValue2(comp, "value_float")
			elseif name == "target_y" then
				target_y = ComponentGetValue2(comp, "value_float")
			end
		end
	end

	print("Teleporting from " .. from_x .. ", " .. from_y)
	print("Teleporting to " .. target_x .. ", " .. target_y)

	local portal = EntityLoad("mods/noita.fairmod/files/content/speedrun_door/portal_kolmi.xml", from_x, from_y)
	local teleport_comp = EntityGetFirstComponent(portal, "TeleportComponent")

	ComponentSetValue2(teleport_comp, "target", target_x, target_y)
end
