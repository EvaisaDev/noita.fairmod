local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local viewed = EntityHasTag(entity_id, "viewing")

local minecraft_module = dofile_once("mods/noita.fairmod/files/content/minecraft/init.lua")

minecraft_module.Update(viewed)

function enabled_changed(entity_id, is_enabled)
	if not is_enabled then
		EntityRemoveTag(entity_id, "viewing")
	elseif not EntityHasTag(entity_id, "viewing") then
		EntityAddTag(entity_id, "viewing")
	end
end

function item_pickup( entity_item, entity_pickupper, item_name )
	GamePlaySound("mods/noita.fairmod/fairmod.bank", "minecraft/implayingminecraft", x, y)
end