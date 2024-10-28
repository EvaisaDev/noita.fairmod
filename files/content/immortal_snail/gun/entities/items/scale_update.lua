local entity_id = GetUpdatedEntityID()
local _, _, rad = EntityGetTransform(entity_id)
local sprite_comp = EntityGetComponentIncludingDisabled(entity_id, "SpriteComponent", "item")
if sprite_comp ~= nil then
    for i=1, #sprite_comp do
        ComponentSetValue2(sprite_comp[i], "special_scale_y", (rad >= -math.pi / 2 and rad <= math.pi / 2) and 0.4 or -0.4)
    end
end