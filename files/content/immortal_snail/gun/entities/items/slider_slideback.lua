--stylua: ignore start
local eid = GetUpdatedEntityID()
local scomps = EntityGetComponent(eid, "SpriteComponent") or {}
for i = 1, #scomps do
	if
		ComponentGetValue2(scomps[i], "image_file") == "mods/noita.fairmod/files/content/immortal_snail/gun/entities/items/glock_slide.xml"
	then
		local offset = ComponentGetValue2(scomps[i], "offset_x")
		if offset ~= 10 then ComponentSetValue2(scomps[i], "offset_x", math.max(10, offset - 0.2)) end
	end
end
--stylua: ignore end
