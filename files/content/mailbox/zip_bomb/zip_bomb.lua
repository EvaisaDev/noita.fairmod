dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")




function interacting(entity_who_interacted, entity_interacted, interactable_name)
	local entity = GetUpdatedEntityID()

	local x, y, r = EntityGetTransform(entity)
	local zip = EntityLoad("mods/noita.fairmod/files/content/mailbox/zip_bomb/zip_recursive.xml", x, y)

	local velocity_comp = EntityGetFirstComponentIncludingDisabled(zip, "VelocityComponent")
	if(velocity_comp)then
		local vel_x = math.random(-100, 100)
		local vel_y = -100
		ComponentSetValue2(velocity_comp, "mVelocity", vel_x, vel_y)
	end

	ModSettingSet("noita.fairmod.popups", (ModSettingGet("noita.fairmod.popups") or "") .. "idiot,")

	EntityDropItem(entity_who_interacted, entity_interacted)
	EntityKill(entity)
end

